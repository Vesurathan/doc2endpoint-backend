from datetime import datetime, timedelta, timezone

from fastapi import APIRouter, Depends
from sqlalchemy import func, text
from sqlalchemy.orm import Session

from db.database import get_db
from models.api_key import APIKey
from models.api_usage import APIUsage
from models.dataset import Dataset, DatasetStatus
from models.user import User
from routes.auth import get_current_user

router = APIRouter(prefix="/analytics", tags=["analytics"])


@router.get("/summary")
def summary(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    now = datetime.now(timezone.utc)
    month_start = now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)

    dataset_count = db.query(func.count(Dataset.id)).filter(Dataset.user_id == current_user.id).scalar()
    active_count = db.query(func.count(Dataset.id)).filter(Dataset.user_id == current_user.id, Dataset.status == DatasetStatus.active).scalar()
    key_count = db.query(func.count(APIKey.id)).filter(APIKey.user_id == current_user.id, APIKey.is_active == True).scalar()

    user_key_ids = [r[0] for r in db.query(APIKey.id).filter(APIKey.user_id == current_user.id).all()]
    calls_month = 0
    calls_total = 0
    if user_key_ids:
        calls_month = db.query(func.count(APIUsage.id)).filter(
            APIUsage.api_key_id.in_(user_key_ids),
            APIUsage.created_at >= month_start,
        ).scalar() or 0
        calls_total = db.query(func.count(APIUsage.id)).filter(APIUsage.api_key_id.in_(user_key_ids)).scalar() or 0

    return {
        "dataset_count": dataset_count,
        "active_dataset_count": active_count,
        "api_key_count": key_count,
        "calls_this_month": calls_month,
        "calls_total": calls_total,
    }


@router.get("/calls-over-time")
def calls_over_time(
    days: int = 30,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    user_key_ids = [r[0] for r in db.query(APIKey.id).filter(APIKey.user_id == current_user.id).all()]
    if not user_key_ids:
        return {"data": []}

    since = datetime.now(timezone.utc) - timedelta(days=days)
    rows = (
        db.query(
            func.date_trunc("day", APIUsage.created_at).label("day"),
            func.count(APIUsage.id).label("calls"),
        )
        .filter(APIUsage.api_key_id.in_(user_key_ids), APIUsage.created_at >= since)
        .group_by("day")
        .order_by("day")
        .all()
    )

    # Fill in zeros for missing days
    result_map = {r.day.date(): r.calls for r in rows}
    today = datetime.now(timezone.utc).date()
    data = []
    for i in range(days):
        day = today - timedelta(days=days - 1 - i)
        data.append({"date": day.isoformat(), "calls": result_map.get(day, 0)})

    return {"data": data}


@router.get("/by-dataset")
def by_dataset(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    user_key_ids = [r[0] for r in db.query(APIKey.id).filter(APIKey.user_id == current_user.id).all()]
    if not user_key_ids:
        return {"data": []}

    rows = (
        db.query(
            Dataset.id,
            Dataset.name,
            Dataset.table_name,
            func.count(APIUsage.id).label("calls"),
        )
        .join(APIUsage, APIUsage.dataset_id == Dataset.id)
        .filter(APIUsage.api_key_id.in_(user_key_ids))
        .group_by(Dataset.id, Dataset.name, Dataset.table_name)
        .order_by(func.count(APIUsage.id).desc())
        .limit(10)
        .all()
    )

    return {
        "data": [
            {"id": r.id, "name": r.name, "table_name": r.table_name, "calls": r.calls}
            for r in rows
        ]
    }


@router.get("/recent-calls")
def recent_calls(
    limit: int = 20,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    user_key_ids = [r[0] for r in db.query(APIKey.id).filter(APIKey.user_id == current_user.id).all()]
    if not user_key_ids:
        return {"data": []}

    rows = (
        db.query(APIUsage, APIKey.name.label("key_name"), Dataset.name.label("dataset_name"))
        .join(APIKey, APIKey.id == APIUsage.api_key_id)
        .join(Dataset, Dataset.id == APIUsage.dataset_id)
        .filter(APIUsage.api_key_id.in_(user_key_ids))
        .order_by(APIUsage.created_at.desc())
        .limit(limit)
        .all()
    )

    return {
        "data": [
            {
                "id": r.APIUsage.id,
                "method": r.APIUsage.method,
                "path": r.APIUsage.path,
                "status_code": r.APIUsage.status_code,
                "response_time_ms": r.APIUsage.response_time_ms,
                "dataset_name": r.dataset_name,
                "key_name": r.key_name,
                "created_at": r.APIUsage.created_at.isoformat(),
            }
            for r in rows
        ]
    }
