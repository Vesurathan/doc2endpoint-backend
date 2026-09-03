import random
import string
from datetime import datetime, timezone, timedelta

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from pydantic import BaseModel, EmailStr
import httpx
from db.database import get_db
from models.user import User
from core.security import hash_password, verify_password, create_access_token, decode_token
from services.email import send_verification_email
from services.disposable_emails import is_disposable

router = APIRouter(prefix="/auth", tags=["auth"])
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")


class RegisterRequest(BaseModel):
    full_name: str
    email: EmailStr
    password: str


class UserOut(BaseModel):
    id: int
    full_name: str
    email: str
    plan: str
    is_admin: bool = False
    has_password: bool = True   # False for Google-only accounts

    class Config:
        from_attributes = True

    @classmethod
    def from_orm_user(cls, user: User) -> "UserOut":
        return cls(
            id=user.id,
            full_name=user.full_name,
            email=user.email,
            plan=user.plan,
            is_admin=user.is_admin,
            has_password=bool(user.hashed_password),
        )


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserOut


def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)) -> User:
    payload = decode_token(token)
    if not payload:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid or expired token")
    user = db.query(User).filter(User.id == payload.get("sub")).first()
    if not user or not user.is_active:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="User not found")
    return user


# ─── Helpers ─────────────────────────────────────────────────────────────────

def _generate_code() -> str:
    return "".join(random.choices(string.digits, k=6))


def _send_verification(user: User) -> None:
    code = _generate_code()
    user.verification_code = code
    user.verification_expires_at = datetime.now(timezone.utc) + timedelta(hours=24)
    send_verification_email(user.email, user.full_name, code)


# ─── Email / password auth ────────────────────────────────────────────────────

@router.post("/register", status_code=201)
def register(body: RegisterRequest, db: Session = Depends(get_db)):
    if is_disposable(body.email):
        raise HTTPException(
            status_code=400,
            detail="Temporary or disposable email addresses are not allowed. Please use a real email address.",
        )
    if db.query(User).filter(User.email == body.email).first():
        raise HTTPException(status_code=400, detail="Email already registered")
    user = User(
        full_name=body.full_name,
        email=body.email,
        hashed_password=hash_password(body.password),
        is_verified=False,
    )
    db.add(user)
    db.flush()  # get user.id before sending email
    _send_verification(user)
    db.commit()
    db.refresh(user)
    return {"message": "Account created. Please check your email for a verification code.", "email": user.email}


@router.post("/login", response_model=TokenResponse)
def login(form: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == form.username).first()
    if not user:
        raise HTTPException(status_code=400, detail="Incorrect email or password")
    if not user.hashed_password:
        raise HTTPException(status_code=400, detail="This account uses Google Sign-In. Please continue with Google.")
    if not verify_password(form.password, user.hashed_password):
        raise HTTPException(status_code=400, detail="Incorrect email or password")
    if not user.is_verified:
        raise HTTPException(
            status_code=403,
            detail="EMAIL_NOT_VERIFIED",
        )
    token = create_access_token({"sub": str(user.id)})
    return {"access_token": token, "user": UserOut.from_orm_user(user)}


# ─── Email verification ───────────────────────────────────────────────────────

class VerifyEmailRequest(BaseModel):
    email: EmailStr
    code: str


class ResendVerificationRequest(BaseModel):
    email: EmailStr


@router.post("/verify-email", status_code=200)
def verify_email(body: VerifyEmailRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == body.email).first()
    if not user:
        raise HTTPException(status_code=404, detail="No account found with that email.")
    if user.is_verified:
        raise HTTPException(status_code=400, detail="Email is already verified.")
    if not user.verification_code or user.verification_code != body.code.strip():
        raise HTTPException(status_code=400, detail="Invalid verification code.")
    if user.verification_expires_at and user.verification_expires_at < datetime.now(timezone.utc):
        raise HTTPException(status_code=400, detail="Verification code has expired. Request a new one.")

    user.is_verified = True
    user.verification_code = None
    user.verification_expires_at = None
    db.commit()

    token = create_access_token({"sub": str(user.id)})
    return {"access_token": token, "token_type": "bearer", "user": UserOut.from_orm_user(user)}


@router.post("/resend-verification", status_code=200)
def resend_verification(body: ResendVerificationRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == body.email).first()
    if not user:
        raise HTTPException(status_code=404, detail="No account found with that email.")
    if user.is_verified:
        raise HTTPException(status_code=400, detail="Email is already verified.")
    _send_verification(user)
    db.commit()
    return {"message": "A new verification code has been sent to your email."}


@router.get("/me")
def me(current_user: User = Depends(get_current_user)):
    return UserOut.from_orm_user(current_user)


# ─── Google OAuth ─────────────────────────────────────────────────────────────

class GoogleAuthRequest(BaseModel):
    access_token: str


@router.post("/google", response_model=TokenResponse)
async def google_auth(body: GoogleAuthRequest, db: Session = Depends(get_db)):
    # Verify token with Google and fetch user info
    async with httpx.AsyncClient() as client:
        resp = await client.get(
            "https://www.googleapis.com/oauth2/v2/userinfo",
            headers={"Authorization": f"Bearer {body.access_token}"},
            timeout=10.0,
        )

    if resp.status_code != 200:
        raise HTTPException(status_code=401, detail="Invalid Google token. Please try again.")

    gdata = resp.json()
    email = gdata.get("email")
    if not email or not gdata.get("verified_email", True):
        raise HTTPException(status_code=400, detail="Could not retrieve a verified email from Google.")

    google_id = gdata.get("id", "")
    full_name = gdata.get("name") or email.split("@")[0].replace(".", " ").title()

    # Find existing user — first by google_id, then by email
    user = db.query(User).filter(User.google_id == google_id).first()
    if not user:
        user = db.query(User).filter(User.email == email).first()

    if user:
        # Link Google ID to existing email/password account if not already linked
        if not user.google_id:
            user.google_id = google_id
            db.commit()
        if not user.is_active:
            raise HTTPException(status_code=403, detail="This account has been deactivated.")
    else:
        # Brand-new Google user — create account
        user = User(
            full_name=full_name,
            email=email,
            hashed_password=None,
            google_id=google_id,
            is_verified=True,  # Google already verified the email
        )
        db.add(user)
        db.commit()
        db.refresh(user)

    token = create_access_token({"sub": str(user.id)})
    return {"access_token": token, "user": UserOut.from_orm_user(user)}


# ─── Profile management ───────────────────────────────────────────────────────

class UpdateProfileRequest(BaseModel):
    full_name: str


class ChangePasswordRequest(BaseModel):
    current_password: str
    new_password: str


@router.patch("/me")
def update_profile(body: UpdateProfileRequest, current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    if not body.full_name.strip():
        raise HTTPException(status_code=400, detail="Name cannot be empty")
    current_user.full_name = body.full_name.strip()
    db.commit()
    db.refresh(current_user)
    return UserOut.from_orm_user(current_user)


@router.post("/change-password", status_code=200)
def change_password(body: ChangePasswordRequest, current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    if not current_user.hashed_password:
        raise HTTPException(status_code=400, detail="This account uses Google Sign-In and has no password. Set a new password instead.")
    if not verify_password(body.current_password, current_user.hashed_password):
        raise HTTPException(status_code=400, detail="Current password is incorrect")
    if len(body.new_password) < 8:
        raise HTTPException(status_code=400, detail="Password must be at least 8 characters")
    current_user.hashed_password = hash_password(body.new_password)
    db.commit()
    return {"message": "Password updated successfully"}


@router.post("/set-password", status_code=200)
def set_password(body: ChangePasswordRequest, current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    """Allows Google-only users to add a password to their account."""
    if current_user.hashed_password:
        raise HTTPException(status_code=400, detail="Account already has a password. Use change-password instead.")
    if len(body.new_password) < 8:
        raise HTTPException(status_code=400, detail="Password must be at least 8 characters")
    current_user.hashed_password = hash_password(body.new_password)
    db.commit()
    return {"message": "Password set successfully"}


@router.delete("/me", status_code=204)
def delete_account(current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    from models.dataset import Dataset
    from sqlalchemy import text

    datasets = db.query(Dataset).filter(Dataset.user_id == current_user.id).all()
    for ds in datasets:
        if ds.table_name:
            try:
                db.execute(text(f'DROP TABLE IF EXISTS "{ds.table_name}"'))
            except Exception:
                pass

    db.delete(current_user)
    db.commit()
