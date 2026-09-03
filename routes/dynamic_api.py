import time
from datetime import datetime, timezone

from fastapi import APIRouter, Depends, HTTPException, Request, Query
from sqlalchemy import text
from sqlalchemy.orm import Session

from db.database import get_db, engine
from models.api_key import APIKey
from models.api_usage import APIUsage
from models.dataset import Dataset, DatasetStatus
from core.security import verify_password

router = APIRouter(prefix="/api/v1", tags=["generated-api"])

_MAX_LIMIT = 1000
_DEFAULT_LIMIT = 100


# ─── Auth helper ─────────────────────────────────────────────────────────────

def _resolve_api_key(request: Request, db: Session) -> tuple[APIKey, Dataset]:
    raw_key = (
        request.headers.get("X-API-Key")
        or request.query_params.get("api_key")
    )
    if not raw_key:
        raise HTTPException(401, "API key required. Pass X-API-Key header or ?api_key= param.")

    table_name = request.path_params.get("table_name", "")
    # Allow custom endpoint slugs — check custom_endpoint first, fall back to table_name
    from sqlalchemy import or_
    dataset = db.query(Dataset).filter(
        or_(Dataset.custom_endpoint == table_name, Dataset.table_name == table_name),
        Dataset.status == DatasetStatus.active,
    ).first()
    if not dataset:
        raise HTTPException(404, f"No active dataset found for endpoint '{table_name}'.")

    prefix = raw_key[:16]
    is_public = getattr(dataset, "is_public", False)

    if is_public:
        candidates = db.query(APIKey).filter(
            APIKey.key_prefix == prefix,
            APIKey.is_active == True,
        ).all()
    else:
        candidates = db.query(APIKey).filter(
            APIKey.key_prefix == prefix,
            APIKey.user_id == dataset.user_id,
            APIKey.is_active == True,
        ).all()

    matched = next((k for k in candidates if verify_password(raw_key, k.key_hash)), None)
    if not matched:
        raise HTTPException(403, "Invalid or inactive API key.")

    if not is_public and matched.dataset_id is not None and matched.dataset_id != dataset.id:
        raise HTTPException(403, "This API key does not have access to this dataset.")

    matched.last_used_at = datetime.now(timezone.utc)
    db.commit()
    return matched, dataset


def _client_ip(request: Request) -> str:
    """Best-effort client IP, respects X-Forwarded-For from reverse proxies."""
    forwarded = request.headers.get("X-Forwarded-For")
    if forwarded:
        return forwarded.split(",")[0].strip()
    if request.client:
        return request.client.host
    return "unknown"


def _log_usage(
    db: Session,
    api_key_id: int,
    dataset_id: int,
    method: str,
    path: str,
    status_code: int,
    ms: int,
    ip_address: str | None = None,
    query_string: str | None = None,
):
    db.add(APIUsage(
        api_key_id=api_key_id,
        dataset_id=dataset_id,
        method=method,
        path=path,
        status_code=status_code,
        response_time_ms=ms,
        ip_address=ip_address,
        query_string=query_string,
    ))
    db.commit()


# ─── Query builder (safe against injection) ──────────────────────────────────

def _build_query(
    table_name: str,
    valid_cols: set[str],
    user_params: dict,
    fixed_filters: dict,          # from api_key.row_filters — always applied
    page: int,
    limit: int,
    order_by: str,
    order: str,
):
    conditions = []
    bind = {}

    # ── Fixed row-level filters (API key scope) — user cannot override ────────
    for col, val in (fixed_filters or {}).items():
        if col in valid_cols:
            conditions.append(f'"fixed_{col}" = :fixed_{col}')
            # Use a distinct bind key prefix so user params can't collide
            conditions[-1] = f'"{col}" = :fixed_{col}'
            bind[f"fixed_{col}"] = val

    # ── User-supplied request filters ─────────────────────────────────────────
    for key, val in user_params.items():
        if "__gte" in key:
            col = key.replace("__gte", "")
            if col in valid_cols:
                conditions.append(f'"{col}" >= :gte_{col}')
                bind[f"gte_{col}"] = val
        elif "__lte" in key:
            col = key.replace("__lte", "")
            if col in valid_cols:
                conditions.append(f'"{col}" <= :lte_{col}')
                bind[f"lte_{col}"] = val
        elif "__like" in key:
            col = key.replace("__like", "")
            if col in valid_cols:
                conditions.append(f'"{col}"::TEXT ILIKE :like_{col}')
                bind[f"like_{col}"] = f"%{val}%"
        elif key in valid_cols:
            # Skip if this column already has a fixed filter
            if f"fixed_{key}" not in bind:
                conditions.append(f'"{key}" = :eq_{key}')
                bind[f"eq_{key}"] = val

    where = f"WHERE {' AND '.join(conditions)}" if conditions else ""

    sort_col = order_by if order_by in valid_cols else "id"
    sort_dir = "DESC" if order.upper() == "DESC" else "ASC"
    offset = (page - 1) * limit

    count_sql = text(f'SELECT COUNT(*) FROM "{table_name}" {where}')
    data_sql = text(
        f'SELECT * FROM "{table_name}" {where} ORDER BY "{sort_col}" {sort_dir} LIMIT :limit OFFSET :offset'
    )
    bind["limit"] = limit
    bind["offset"] = offset

    return count_sql, data_sql, bind


# ─── Endpoints ───────────────────────────────────────────────────────────────

@router.get("/{table_name}")
def list_records(
    request: Request,
    table_name: str,
    page: int = Query(1, ge=1),
    limit: int = Query(_DEFAULT_LIMIT, ge=1, le=_MAX_LIMIT),
    order_by: str = Query("id"),
    order: str = Query("asc"),
    db: Session = Depends(get_db),
):
    start = time.time()
    api_key, dataset = _resolve_api_key(request, db)
    ip = _client_ip(request)
    qs = str(request.query_params) if request.query_params else None

    cols = dataset.confirmed_schema.get("columns", [])
    valid = {c["name"] for c in cols if c.get("expose", True)} | {"id"}

    user_params = {
        k: v for k, v in request.query_params.items()
        if k not in ("page", "limit", "order_by", "order", "api_key")
    }

    fixed_filters = api_key.row_filters or {}

    count_sql, data_sql, bind = _build_query(
        table_name, valid, user_params, fixed_filters, page, limit, order_by, order
    )

    try:
        with engine.connect() as conn:
            total = conn.execute(count_sql, bind).scalar()
            rows = conn.execute(data_sql, bind).mappings().all()
    except Exception as e:
        ms = int((time.time() - start) * 1000)
        _log_usage(db, api_key.id, dataset.id, "GET", request.url.path, 500, ms, ip, qs)
        raise HTTPException(500, f"Query error: {str(e)}")

    ms = int((time.time() - start) * 1000)
    _log_usage(db, api_key.id, dataset.id, "GET", request.url.path, 200, ms, ip, qs)

    return {
        "data": [dict(r) for r in rows],
        "total": total,
        "page": page,
        "limit": limit,
        "pages": max(1, -(-total // limit)),
    }


@router.get("/{table_name}/schema")
def get_schema(
    request: Request,
    table_name: str,
    db: Session = Depends(get_db),
):
    _, dataset = _resolve_api_key(request, db)
    cols = dataset.confirmed_schema.get("columns", [])
    return {
        "dataset": dataset.name,
        "table": table_name,
        "columns": [
            {
                "name": c["name"],
                "type": c.get("type", "string"),
                "description": c.get("description", ""),
            }
            for c in cols if c.get("expose", True)
        ],
        "row_count": dataset.row_count,
    }


@router.get("/{table_name}/{record_id}")
def get_record(
    request: Request,
    table_name: str,
    record_id: int,
    db: Session = Depends(get_db),
):
    start = time.time()
    api_key, dataset = _resolve_api_key(request, db)
    ip = _client_ip(request)

    try:
        with engine.connect() as conn:
            row = conn.execute(
                text(f'SELECT * FROM "{table_name}" WHERE id = :id'),
                {"id": record_id},
            ).mappings().first()
    except Exception as e:
        ms = int((time.time() - start) * 1000)
        _log_usage(db, api_key.id, dataset.id, "GET", request.url.path, 500, ms, ip)
        raise HTTPException(500, f"Query error: {str(e)}")

    ms = int((time.time() - start) * 1000)
    if not row:
        _log_usage(db, api_key.id, dataset.id, "GET", request.url.path, 404, ms, ip)
        raise HTTPException(404, "Record not found")

    _log_usage(db, api_key.id, dataset.id, "GET", request.url.path, 200, ms, ip)
    return {"data": dict(row)}
