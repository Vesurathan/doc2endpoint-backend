from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
from sqlalchemy import text
from db.database import Base, engine
import models.user
import models.dataset
import models.api_key
import models.api_usage
from routes import auth, datasets, api_keys, analytics, dynamic_api, admin, billing

Base.metadata.create_all(bind=engine)

# ── Safe column migrations (idempotent) ──────────────────────────────────────
def _run_migrations():
    migrations = [
        # Users
        "ALTER TABLE users ADD COLUMN IF NOT EXISTS google_id VARCHAR(100)",
        "ALTER TABLE users ALTER COLUMN hashed_password DROP NOT NULL",
        # Datasets — public gallery
        "ALTER TABLE datasets ADD COLUMN IF NOT EXISTS is_public BOOLEAN DEFAULT FALSE",
        "ALTER TABLE datasets ADD COLUMN IF NOT EXISTS public_description TEXT",
        # Datasets — webhooks
        "ALTER TABLE datasets ADD COLUMN IF NOT EXISTS webhook_url VARCHAR(1000)",
        "ALTER TABLE datasets ADD COLUMN IF NOT EXISTS webhook_secret VARCHAR(100)",
        # Datasets — scheduled sync
        "ALTER TABLE datasets ADD COLUMN IF NOT EXISTS sync_url VARCHAR(2000)",
        "ALTER TABLE datasets ADD COLUMN IF NOT EXISTS sync_interval_hours INTEGER",
        "ALTER TABLE datasets ADD COLUMN IF NOT EXISTS last_synced_at TIMESTAMP WITH TIME ZONE",
        # Users — Stripe billing
        "ALTER TABLE users ADD COLUMN IF NOT EXISTS stripe_customer_id VARCHAR(100)",
        "ALTER TABLE users ADD COLUMN IF NOT EXISTS stripe_subscription_id VARCHAR(100)",
        # API keys — row-level access control
        "ALTER TABLE api_keys ADD COLUMN IF NOT EXISTS row_filters JSONB",
        # API usage — activity log enrichment
        "ALTER TABLE api_usage ADD COLUMN IF NOT EXISTS ip_address VARCHAR(60)",
        "ALTER TABLE api_usage ADD COLUMN IF NOT EXISTS query_string VARCHAR(1000)",
        # Datasets — custom endpoint slug
        "ALTER TABLE datasets ADD COLUMN IF NOT EXISTS custom_endpoint VARCHAR(255)",
        "CREATE UNIQUE INDEX IF NOT EXISTS ix_datasets_custom_endpoint ON datasets (custom_endpoint) WHERE custom_endpoint IS NOT NULL",
        # Users — email verification
        "ALTER TABLE users ADD COLUMN IF NOT EXISTS is_verified BOOLEAN DEFAULT FALSE",
        "ALTER TABLE users ADD COLUMN IF NOT EXISTS verification_code VARCHAR(10)",
        "ALTER TABLE users ADD COLUMN IF NOT EXISTS verification_expires_at TIMESTAMP WITH TIME ZONE",
    ]
    with engine.begin() as conn:
        for sql in migrations:
            try:
                conn.execute(text(sql))
            except Exception:
                pass

_run_migrations()

# ── Scheduler (sync jobs) ─────────────────────────────────────────────────────
from apscheduler.schedulers.background import BackgroundScheduler
from services.sync import run_due_syncs

scheduler = BackgroundScheduler()
scheduler.add_job(run_due_syncs, "interval", minutes=30, id="sync_datasets", max_instances=1)

@asynccontextmanager
async def lifespan(app: FastAPI):
    scheduler.start()
    yield
    scheduler.shutdown(wait=False)

# ── App ───────────────────────────────────────────────────────────────────────
app = FastAPI(title="Doc2Endpoint", version="1.0.0", lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:5173",
        "http://localhost:3000",
        "https://www.doc2endpoint.com",
        "https://doc2endpoint.com",
        "https://api.doc2endpoint.com",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
    expose_headers=["*"],
)

app.include_router(auth.router)
app.include_router(datasets.router)
app.include_router(api_keys.router)
app.include_router(analytics.router)
app.include_router(dynamic_api.router)
app.include_router(admin.router)
app.include_router(billing.router)


@app.get("/health")
def health():
    return {"status": "ok"}
