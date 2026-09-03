"""
Scheduled sync service — runs every 30 min via APScheduler.
Fetches datasets whose next sync time has passed and re-loads data.
"""
import io
import logging
from datetime import datetime, timezone

import httpx
import pandas as pd
from sqlalchemy import text

from db.database import SessionLocal, engine
from models.dataset import Dataset, DatasetStatus
from services.webhook import fire_webhook

logger = logging.getLogger(__name__)


def _next_sync(ds: Dataset) -> datetime | None:
    if not ds.sync_url or not ds.sync_interval_hours:
        return None
    base = ds.last_synced_at or ds.created_at
    from datetime import timedelta
    return base + timedelta(hours=ds.sync_interval_hours)


def run_due_syncs():
    """Called by APScheduler every 30 minutes."""
    db = SessionLocal()
    try:
        now = datetime.now(timezone.utc)
        candidates = db.query(Dataset).filter(
            Dataset.status == DatasetStatus.active,
            Dataset.sync_url.isnot(None),
            Dataset.sync_interval_hours.isnot(None),
        ).all()

        for ds in candidates:
            nxt = _next_sync(ds)
            if nxt and now >= nxt:
                try:
                    sync_dataset(ds, db)
                    logger.info("Synced dataset %s (%s)", ds.id, ds.name)
                except Exception as exc:
                    logger.error("Sync failed for dataset %s: %s", ds.id, exc)
    finally:
        db.close()


def sync_dataset(ds: Dataset, db) -> int:
    """
    Fetch sync_url, parse as CSV/Excel, replace table data.
    Returns new row count.
    """
    with httpx.Client(follow_redirects=True, timeout=30) as client:
        resp = client.get(ds.sync_url)
        resp.raise_for_status()

    content_type = resp.headers.get("content-type", "")
    raw = resp.content

    # Parse
    if "csv" in content_type or ds.sync_url.lower().endswith(".csv") or "spreadsheets" in ds.sync_url:
        # Google Sheets CSV export & plain CSV
        df = pd.read_csv(io.BytesIO(raw))
    elif "excel" in content_type or ds.sync_url.lower().endswith((".xlsx", ".xls")):
        df = pd.read_excel(io.BytesIO(raw))
    else:
        # Default: try CSV
        df = pd.read_csv(io.BytesIO(raw))

    df = df.dropna(how="all")

    cols = (ds.confirmed_schema or {}).get("columns", [])
    exposed = [c for c in cols if c.get("expose", True)]
    col_name_map = {c.get("original_name", c["name"]): c["name"] for c in exposed}

    # Map original column names → confirmed names
    matched = {orig: new for orig, new in col_name_map.items() if orig in df.columns}
    if not matched:
        # Fallback: match by confirmed name directly
        matched = {c["name"]: c["name"] for c in exposed if c["name"] in df.columns}

    if not matched:
        raise ValueError(f"No matching columns found. Available: {list(df.columns)}")

    df = df[list(matched.keys())].rename(columns=matched)
    target_cols = [c for c in [c["name"] for c in exposed] if c in df.columns]
    df = df[target_cols]

    row_count = len(df)

    with engine.begin() as conn:
        # Replace all rows
        conn.execute(text(f'TRUNCATE TABLE "{ds.table_name}"'))
        if not df.empty:
            placeholders = ", ".join(f":{c}" for c in df.columns)
            col_list = ", ".join(f'"{c}"' for c in df.columns)
            insert_sql = text(f'INSERT INTO "{ds.table_name}" ({col_list}) VALUES ({placeholders})')
            conn.execute(insert_sql, df.where(df.notna(), None).to_dict(orient="records"))

    ds.row_count = row_count
    ds.last_synced_at = datetime.now(timezone.utc)
    db.commit()

    # Fire webhook if configured
    if ds.webhook_url:
        fire_webhook(ds.webhook_url, ds.webhook_secret, {
            "event": "dataset.synced",
            "dataset_id": ds.id,
            "dataset_name": ds.name,
            "row_count": row_count,
            "synced_at": ds.last_synced_at.isoformat(),
        })

    return row_count
