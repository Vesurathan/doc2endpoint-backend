import secrets
from datetime import datetime, timezone

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy.orm import Session

from core.security import hash_password
from db.database import get_db
from models.api_key import APIKey
from models.dataset import Dataset, DatasetStatus
from models.user import User
from routes.auth import get_current_user

router = APIRouter(prefix="/api-keys", tags=["api-keys"])


class CreateKeyRequest(BaseModel):
    name: str
    dataset_id: int | None = None
    # Optional row-level filters: {"region": "US", "status": "active"}
    # Every query with this key will have these applied as mandatory WHERE clauses
    row_filters: dict | None = None


def _key_out(k: APIKey, full_key: str | None = None) -> dict:
    return {
        "id": k.id,
        "name": k.name,
        "key_prefix": k.key_prefix,
        "full_key": full_key,
        "dataset_id": k.dataset_id,
        "is_active": k.is_active,
        "row_filters": k.row_filters or {},
        "last_used_at": k.last_used_at.isoformat() if k.last_used_at else None,
        "created_at": k.created_at.isoformat(),
    }


@router.post("/", status_code=201)
def create_key(
    body: CreateKeyRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    if body.dataset_id:
        ds = db.query(Dataset).filter(
            Dataset.id == body.dataset_id,
            Dataset.user_id == current_user.id,
            Dataset.status == DatasetStatus.active,
        ).first()
        if not ds:
            raise HTTPException(404, "Dataset not found or not active")

    raw_key = f"d2e_{secrets.token_urlsafe(32)}"
    prefix = raw_key[:16]

    key = APIKey(
        user_id=current_user.id,
        dataset_id=body.dataset_id,
        name=body.name,
        key_prefix=prefix,
        key_hash=hash_password(raw_key),
        row_filters=body.row_filters or None,
    )
    db.add(key)
    db.commit()
    db.refresh(key)
    return _key_out(key, full_key=raw_key)


@router.get("/")
def list_keys(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    keys = (
        db.query(APIKey)
        .filter(APIKey.user_id == current_user.id)
        .order_by(APIKey.created_at.desc())
        .all()
    )
    return [_key_out(k) for k in keys]


@router.delete("/{key_id}")
def revoke_key(
    key_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    key = db.query(APIKey).filter(APIKey.id == key_id, APIKey.user_id == current_user.id).first()
    if not key:
        raise HTTPException(404, "API key not found")
    key.is_active = False
    db.commit()
    return {"message": "API key revoked"}


@router.post("/auto-create/{dataset_id}", status_code=201)
def auto_create_for_dataset(
    dataset_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    ds = db.query(Dataset).filter(Dataset.id == dataset_id, Dataset.user_id == current_user.id).first()
    if not ds:
        raise HTTPException(404, "Dataset not found")

    raw_key = f"d2e_{secrets.token_urlsafe(32)}"
    prefix = raw_key[:16]
    key = APIKey(
        user_id=current_user.id,
        dataset_id=dataset_id,
        name=f"{ds.name} — Default Key",
        key_prefix=prefix,
        key_hash=hash_password(raw_key),
    )
    db.add(key)
    db.commit()
    db.refresh(key)
    return _key_out(key, full_key=raw_key)
