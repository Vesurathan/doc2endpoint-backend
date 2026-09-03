from datetime import datetime, timedelta, timezone

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy import func
from sqlalchemy.orm import Session

from core.security import hash_password
from db.database import get_db
from models.api_key import APIKey
from models.api_usage import APIUsage
from models.dataset import Dataset, DatasetStatus
from models.user import User, Plan
from routes.auth import get_current_user

router = APIRouter(prefix="/admin", tags=["admin"])


# ─── Admin guard ─────────────────────────────────────────────────────────────

def require_admin(current_user: User = Depends(get_current_user)) -> User:
    if not current_user.is_admin:
        raise HTTPException(403, "Admin access required")
    return current_user


# ─── Bootstrap (first admin — only works when zero admins exist) ──────────────

@router.post("/bootstrap", status_code=201)
def bootstrap_admin(db: Session = Depends(get_db)):
    existing = db.query(User).filter(User.is_admin == True).first()
    if existing:
        raise HTTPException(400, "An admin already exists. Use the admin panel to manage roles.")
    first_user = db.query(User).order_by(User.id.asc()).first()
    if not first_user:
        raise HTTPException(404, "No users found. Register first, then call this endpoint.")
    first_user.is_admin = True
    db.commit()
    return {"message": f"✅ {first_user.email} is now an admin.", "user_id": first_user.id}


# ─── System-wide stats ────────────────────────────────────────────────────────

@router.get("/stats")
def system_stats(db: Session = Depends(get_db), _: User = Depends(require_admin)):
    now = datetime.now(timezone.utc)
    month_start = now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)
    week_start = now - timedelta(days=7)

    total_users = db.query(func.count(User.id)).scalar()
    active_users = db.query(func.count(User.id)).filter(User.is_active == True).scalar()
    new_users_week = db.query(func.count(User.id)).filter(User.created_at >= week_start).scalar()

    plan_counts = (
        db.query(User.plan, func.count(User.id))
        .group_by(User.plan)
        .all()
    )

    total_datasets = db.query(func.count(Dataset.id)).scalar()
    active_datasets = db.query(func.count(Dataset.id)).filter(Dataset.status == DatasetStatus.active).scalar()
    total_rows = db.query(func.sum(Dataset.row_count)).scalar() or 0

    total_keys = db.query(func.count(APIKey.id)).filter(APIKey.is_active == True).scalar()
    calls_month = db.query(func.count(APIUsage.id)).filter(APIUsage.created_at >= month_start).scalar() or 0
    calls_total = db.query(func.count(APIUsage.id)).scalar() or 0

    return {
        "users": {
            "total": total_users,
            "active": active_users,
            "new_this_week": new_users_week,
            "by_plan": {r[0]: r[1] for r in plan_counts},
        },
        "datasets": {
            "total": total_datasets,
            "active": active_datasets,
            "total_rows_stored": total_rows,
        },
        "api_keys": {"active": total_keys},
        "api_calls": {
            "this_month": calls_month,
            "total": calls_total,
        },
    }


# ─── System analytics ─────────────────────────────────────────────────────────

@router.get("/analytics/calls-over-time")
def calls_over_time(days: int = 30, db: Session = Depends(get_db), _: User = Depends(require_admin)):
    since = datetime.now(timezone.utc) - timedelta(days=days)
    rows = (
        db.query(func.date_trunc("day", APIUsage.created_at).label("day"), func.count(APIUsage.id).label("calls"))
        .filter(APIUsage.created_at >= since)
        .group_by("day")
        .order_by("day")
        .all()
    )
    result_map = {r.day.date(): r.calls for r in rows}
    today = datetime.now(timezone.utc).date()
    data = [{"date": (today - timedelta(days=days - 1 - i)).isoformat(), "calls": result_map.get((today - timedelta(days=days - 1 - i)), 0)} for i in range(days)]
    return {"data": data}


@router.get("/analytics/new-users-over-time")
def new_users_over_time(days: int = 30, db: Session = Depends(get_db), _: User = Depends(require_admin)):
    since = datetime.now(timezone.utc) - timedelta(days=days)
    rows = (
        db.query(func.date_trunc("day", User.created_at).label("day"), func.count(User.id).label("count"))
        .filter(User.created_at >= since)
        .group_by("day")
        .order_by("day")
        .all()
    )
    result_map = {r.day.date(): r.count for r in rows}
    today = datetime.now(timezone.utc).date()
    data = [{"date": (today - timedelta(days=days - 1 - i)).isoformat(), "count": result_map.get((today - timedelta(days=days - 1 - i)), 0)} for i in range(days)]
    return {"data": data}


@router.get("/analytics/top-users")
def top_users(limit: int = 10, db: Session = Depends(get_db), _: User = Depends(require_admin)):
    rows = (
        db.query(User.id, User.full_name, User.email, User.plan, func.count(APIUsage.id).label("calls"))
        .outerjoin(APIKey, APIKey.user_id == User.id)
        .outerjoin(APIUsage, APIUsage.api_key_id == APIKey.id)
        .group_by(User.id, User.full_name, User.email, User.plan)
        .order_by(func.count(APIUsage.id).desc())
        .limit(limit)
        .all()
    )
    return {"data": [{"id": r.id, "full_name": r.full_name, "email": r.email, "plan": r.plan, "calls": r.calls} for r in rows]}


# ─── User management ──────────────────────────────────────────────────────────

class UpdateUserRequest(BaseModel):
    plan: str | None = None
    is_active: bool | None = None
    is_admin: bool | None = None


@router.get("/users")
def list_users(
    search: str = "",
    plan: str = "",
    page: int = 1,
    limit: int = 20,
    db: Session = Depends(get_db),
    _: User = Depends(require_admin),
):
    q = db.query(User)
    if search:
        q = q.filter(
            User.email.ilike(f"%{search}%") | User.full_name.ilike(f"%{search}%")
        )
    if plan and plan in [p.value for p in Plan]:
        q = q.filter(User.plan == Plan(plan))
    total = q.count()
    users = q.order_by(User.created_at.desc()).offset((page - 1) * limit).limit(limit).all()
    return {
        "total": total,
        "page": page,
        "pages": max(1, -(-total // limit)),
        "data": [_user_out(u, db) for u in users],
    }


@router.get("/users/{user_id}")
def get_user(user_id: int, db: Session = Depends(get_db), _: User = Depends(require_admin)):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(404, "User not found")
    return _user_out(user, db, detailed=True)


@router.patch("/users/{user_id}")
def update_user(user_id: int, body: UpdateUserRequest, db: Session = Depends(get_db), admin: User = Depends(require_admin)):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(404, "User not found")
    if body.plan and body.plan in [p.value for p in Plan]:
        user.plan = Plan(body.plan)
    if body.is_active is not None:
        user.is_active = body.is_active
    if body.is_admin is not None:
        if user.id == admin.id and not body.is_admin:
            raise HTTPException(400, "You cannot remove your own admin access.")
        user.is_admin = body.is_admin
    db.commit()
    db.refresh(user)
    return _user_out(user, db)


@router.delete("/users/{user_id}", status_code=204)
def delete_user(user_id: int, db: Session = Depends(get_db), admin: User = Depends(require_admin)):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(404, "User not found")
    if user.id == admin.id:
        raise HTTPException(400, "You cannot delete your own account from the admin panel.")
    db.delete(user)
    db.commit()


# ─── Dataset management ───────────────────────────────────────────────────────

@router.get("/datasets")
def list_all_datasets(
    search: str = "",
    status: str = "",
    page: int = 1,
    limit: int = 20,
    db: Session = Depends(get_db),
    _: User = Depends(require_admin),
):
    q = db.query(Dataset, User.email.label("user_email"), User.full_name.label("user_name")) \
          .join(User, User.id == Dataset.user_id)
    if search:
        q = q.filter(Dataset.name.ilike(f"%{search}%"))
    if status:
        q = q.filter(Dataset.status == status)
    total = q.count()
    rows = q.order_by(Dataset.created_at.desc()).offset((page - 1) * limit).limit(limit).all()
    return {
        "total": total,
        "page": page,
        "pages": max(1, -(-total // limit)),
        "data": [
            {
                "id": r.Dataset.id,
                "name": r.Dataset.name,
                "doc_type": r.Dataset.doc_type,
                "status": r.Dataset.status,
                "row_count": r.Dataset.row_count,
                "table_name": r.Dataset.table_name,
                "created_at": r.Dataset.created_at.isoformat(),
                "user_email": r.user_email,
                "user_name": r.user_name,
                "user_id": r.Dataset.user_id,
            }
            for r in rows
        ],
    }


@router.delete("/datasets/{dataset_id}", status_code=204)
def delete_dataset(dataset_id: int, db: Session = Depends(get_db), _: User = Depends(require_admin)):
    from sqlalchemy import text
    from db.database import engine
    ds = db.query(Dataset).filter(Dataset.id == dataset_id).first()
    if not ds:
        raise HTTPException(404, "Dataset not found")
    if ds.table_name:
        with engine.begin() as conn:
            conn.execute(text(f'DROP TABLE IF EXISTS "{ds.table_name}"'))
    db.delete(ds)
    db.commit()


# ─── API key management ───────────────────────────────────────────────────────

@router.get("/api-keys")
def list_all_keys(
    page: int = 1,
    limit: int = 20,
    db: Session = Depends(get_db),
    _: User = Depends(require_admin),
):
    q = db.query(APIKey, User.email.label("user_email")) \
          .join(User, User.id == APIKey.user_id)
    total = q.count()
    rows = q.order_by(APIKey.created_at.desc()).offset((page - 1) * limit).limit(limit).all()
    return {
        "total": total,
        "data": [
            {
                "id": r.APIKey.id,
                "name": r.APIKey.name,
                "key_prefix": r.APIKey.key_prefix,
                "is_active": r.APIKey.is_active,
                "user_email": r.user_email,
                "last_used_at": r.APIKey.last_used_at.isoformat() if r.APIKey.last_used_at else None,
                "created_at": r.APIKey.created_at.isoformat(),
            }
            for r in rows
        ],
    }


@router.delete("/api-keys/{key_id}", status_code=204)
def revoke_any_key(key_id: int, db: Session = Depends(get_db), _: User = Depends(require_admin)):
    key = db.query(APIKey).filter(APIKey.id == key_id).first()
    if not key:
        raise HTTPException(404, "Key not found")
    key.is_active = False
    db.commit()


# ─── Helpers ──────────────────────────────────────────────────────────────────

def _user_out(user: User, db: Session, detailed: bool = False) -> dict:
    base = {
        "id": user.id,
        "full_name": user.full_name,
        "email": user.email,
        "plan": user.plan,
        "is_active": user.is_active,
        "is_admin": user.is_admin,
        "created_at": user.created_at.isoformat(),
    }
    if detailed:
        dataset_count = db.query(func.count(Dataset.id)).filter(Dataset.user_id == user.id).scalar()
        key_ids = [r[0] for r in db.query(APIKey.id).filter(APIKey.user_id == user.id).all()]
        call_count = db.query(func.count(APIUsage.id)).filter(APIUsage.api_key_id.in_(key_ids)).scalar() if key_ids else 0
        base.update({"dataset_count": dataset_count, "total_api_calls": call_count, "api_key_count": len(key_ids)})
    return base
