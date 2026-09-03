"""
Doc2Endpoint — Seed Script
====================
Creates test accounts, sample datasets with real data loaded into Postgres,
API keys, and usage history so the whole UI can be tested immediately.

Run:
    cd backend
    source venv/bin/activate
    python seed.py
"""

import secrets
import random
from datetime import datetime, timedelta, timezone

from sqlalchemy import text

from db.database import Base, engine, SessionLocal
from models.user import User, Plan
from models.dataset import Dataset, DatasetStatus, DocType, ConversationMessage
from models.api_key import APIKey
from models.api_usage import APIUsage
from core.security import hash_password

# ─── Test accounts ────────────────────────────────────────────────────────────

ACCOUNTS = [
    {
        "full_name": "Admin User",
        "email": "admin@docapi.com",
        "password": "Admin123!",
        "plan": Plan.pro,
        "is_admin": True,
    },
    {
        "full_name": "Alice Johnson",
        "email": "alice@example.com",
        "password": "Test123!",
        "plan": Plan.premium,
        "is_admin": False,
    },
    {
        "full_name": "Bob Smith",
        "email": "bob@example.com",
        "password": "Test123!",
        "plan": Plan.free,
        "is_admin": False,
    },
    {
        "full_name": "Carol Williams",
        "email": "carol@example.com",
        "password": "Test123!",
        "plan": Plan.pro,
        "is_admin": False,
    },
]

# ─── Sample dataset definitions ───────────────────────────────────────────────

def _now():
    return datetime.now(timezone.utc)

def _days_ago(n):
    return _now() - timedelta(days=n)


SAMPLE_DATASETS = [
    {
        "name": "Customer Invoices",
        "doc_type": DocType.excel,
        "original_filename": "invoices_q1_2026.xlsx",
        "row_count": 120,
        "columns": [
            {"name": "invoice_id",    "original_name": "Invoice ID",    "type": "string",   "description": "Unique invoice identifier", "expose": True},
            {"name": "customer_name", "original_name": "Customer Name", "type": "string",   "description": "Full name of the customer", "expose": True},
            {"name": "amount",        "original_name": "Amount",        "type": "number",   "description": "Invoice total in USD",      "expose": True},
            {"name": "status",        "original_name": "Status",        "type": "string",   "description": "paid | pending | overdue",  "expose": True},
            {"name": "issue_date",    "original_name": "Issue Date",    "type": "datetime", "description": "Date invoice was issued",   "expose": True},
            {"name": "due_date",      "original_name": "Due Date",      "type": "datetime", "description": "Payment due date",          "expose": True},
        ],
        "table_suffix": "invoices",
        "rows_fn": lambda: [
            {
                "invoice_id": f"INV-{1000 + i:04d}",
                "customer_name": random.choice([
                    "Acme Corp", "TechWave Ltd", "Blue Sky Inc", "Nova Systems",
                    "Orbit Digital", "Peak Solutions", "Bright Minds Co", "Swift Analytics",
                    "Cedar Group", "Atlas Ventures",
                ]),
                "amount": round(random.uniform(150, 12000), 2),
                "status": random.choices(["paid", "pending", "overdue"], weights=[60, 30, 10])[0],
                "issue_date": (_days_ago(random.randint(5, 90))).strftime("%Y-%m-%d"),
                "due_date": (_days_ago(random.randint(-30, 60))).strftime("%Y-%m-%d"),
            }
            for i in range(120)
        ],
        "created_days_ago": 12,
        "api_calls": 340,
    },
    {
        "name": "Product Catalog",
        "doc_type": DocType.csv,
        "original_filename": "products_master.csv",
        "row_count": 80,
        "columns": [
            {"name": "product_id",  "original_name": "Product ID",  "type": "string",  "description": "SKU / product code",       "expose": True},
            {"name": "name",        "original_name": "Name",        "type": "string",  "description": "Product display name",     "expose": True},
            {"name": "category",    "original_name": "Category",    "type": "string",  "description": "Product category",         "expose": True},
            {"name": "price",       "original_name": "Price",       "type": "number",  "description": "Retail price in USD",      "expose": True},
            {"name": "stock",       "original_name": "Stock",       "type": "integer", "description": "Units in stock",           "expose": True},
            {"name": "supplier",    "original_name": "Supplier",    "type": "string",  "description": "Supplier company name",    "expose": True},
        ],
        "table_suffix": "products",
        "rows_fn": lambda: [
            {
                "product_id": f"SKU-{random.randint(1000, 9999)}",
                "name": random.choice([
                    "Pro Laptop Stand", "Wireless Keyboard", "USB-C Hub", "Monitor Light",
                    "Ergonomic Mouse", "Webcam HD", "Desk Organizer", "Cable Tray",
                    "Standing Mat", "Headset Pro", "Screen Cleaner", "HDMI Switch",
                    "Blue Light Glasses", "Whiteboard Pack", "Desk Pad",
                ]),
                "category": random.choice(["Electronics", "Accessories", "Furniture", "Stationery", "Peripherals"]),
                "price": round(random.uniform(9.99, 499.99), 2),
                "stock": random.randint(0, 500),
                "supplier": random.choice(["SupplyCo", "TechDistrib", "OfficeMax Supply", "GlobalParts Inc"]),
            }
            for i in range(80)
        ],
        "created_days_ago": 25,
        "api_calls": 210,
    },
    {
        "name": "Employee Records",
        "doc_type": DocType.excel,
        "original_filename": "hr_employees_2026.xlsx",
        "row_count": 60,
        "columns": [
            {"name": "employee_id",  "original_name": "Employee ID",  "type": "string",  "description": "Internal employee ID",     "expose": True},
            {"name": "full_name",    "original_name": "Full Name",    "type": "string",  "description": "Employee full name",       "expose": True},
            {"name": "department",   "original_name": "Department",   "type": "string",  "description": "Team or department",       "expose": True},
            {"name": "role",         "original_name": "Role",         "type": "string",  "description": "Job title",                "expose": True},
            {"name": "salary",       "original_name": "Salary",       "type": "number",  "description": "Annual salary USD",        "expose": False},
            {"name": "hire_date",    "original_name": "Hire Date",    "type": "datetime","description": "Date employee was hired",  "expose": True},
            {"name": "location",     "original_name": "Location",     "type": "string",  "description": "Office or remote",         "expose": True},
        ],
        "table_suffix": "employees",
        "rows_fn": lambda: [
            {
                "employee_id": f"EMP-{100 + i:03d}",
                "full_name": random.choice([
                    "James Carter", "Maya Patel", "Lucas Fernandez", "Zoe Thompson",
                    "Ethan Brooks", "Sophia Kim", "Noah Williams", "Isabella Chen",
                    "Liam Davis", "Ava Rodriguez", "Oliver Martinez", "Emma Wilson",
                ]),
                "department": random.choice(["Engineering", "Sales", "Marketing", "HR", "Finance", "Design", "Operations"]),
                "role": random.choice(["Manager", "Senior Engineer", "Analyst", "Designer", "Director", "Associate"]),
                "salary": round(random.uniform(55000, 180000), 2),
                "hire_date": (_days_ago(random.randint(30, 1825))).strftime("%Y-%m-%d"),
                "location": random.choice(["New York", "San Francisco", "Remote", "London", "Austin", "Chicago"]),
            }
            for i in range(60)
        ],
        "created_days_ago": 7,
        "api_calls": 95,
    },
    {
        "name": "Monthly Sales",
        "doc_type": DocType.csv,
        "original_filename": "sales_jan_may_2026.csv",
        "row_count": 200,
        "columns": [
            {"name": "sale_id",    "original_name": "Sale ID",    "type": "string",   "description": "Unique sale reference",     "expose": True},
            {"name": "product",    "original_name": "Product",    "type": "string",   "description": "Product sold",              "expose": True},
            {"name": "region",     "original_name": "Region",     "type": "string",   "description": "Sales region",              "expose": True},
            {"name": "quantity",   "original_name": "Quantity",   "type": "integer",  "description": "Units sold",                "expose": True},
            {"name": "revenue",    "original_name": "Revenue",    "type": "number",   "description": "Total revenue in USD",      "expose": True},
            {"name": "sale_date",  "original_name": "Sale Date",  "type": "datetime", "description": "Date of the sale",          "expose": True},
            {"name": "rep_name",   "original_name": "Rep Name",   "type": "string",   "description": "Sales representative name", "expose": True},
        ],
        "table_suffix": "sales",
        "rows_fn": lambda: [
            {
                "sale_id": f"SL-{2000 + i:05d}",
                "product": random.choice(["Pro Laptop Stand", "USB-C Hub", "Ergonomic Mouse", "Wireless Keyboard", "Monitor Light", "Webcam HD"]),
                "region": random.choice(["North America", "Europe", "Asia Pacific", "Latin America", "Middle East"]),
                "quantity": random.randint(1, 50),
                "revenue": round(random.uniform(50, 8000), 2),
                "sale_date": (_days_ago(random.randint(1, 150))).strftime("%Y-%m-%d"),
                "rep_name": random.choice(["Alex Turner", "Jordan Lee", "Sam Rivera", "Taylor Kim", "Morgan Patel"]),
            }
            for i in range(200)
        ],
        "created_days_ago": 3,
        "api_calls": 520,
    },
]

# ─── Seed helpers ─────────────────────────────────────────────────────────────

def _make_table_name(suffix, user_id):
    return f"ds_{user_id}_{suffix}_seed"


def _col_sql_type(col_type):
    return {
        "integer": "BIGINT",
        "number": "DOUBLE PRECISION",
        "boolean": "BOOLEAN",
        "datetime": "TEXT",
    }.get(col_type, "TEXT")


def _create_and_load_table(table_name, columns, rows):
    exposed = [c for c in columns if c.get("expose", True)]
    col_defs = ", ".join(f'"{c["name"]}" {_col_sql_type(c["type"])}' for c in exposed)
    exposed_names = {c["name"] for c in exposed}

    with engine.begin() as conn:
        conn.execute(text(f'DROP TABLE IF EXISTS "{table_name}"'))
        conn.execute(text(f'CREATE TABLE "{table_name}" (id SERIAL PRIMARY KEY, {col_defs})'))

        for row in rows:
            filtered = {k: v for k, v in row.items() if k in exposed_names}
            col_list = ", ".join(f'"{k}"' for k in filtered)
            placeholders = ", ".join(f":{k}" for k in filtered)
            conn.execute(text(f'INSERT INTO "{table_name}" ({col_list}) VALUES ({placeholders})'), filtered)


def _make_api_key(db, user_id, dataset_id, name):
    raw = f"d2e_{secrets.token_urlsafe(32)}"
    prefix = raw[:16]
    key = APIKey(
        user_id=user_id,
        dataset_id=dataset_id,
        name=name,
        key_prefix=prefix,
        key_hash=hash_password(raw),
        last_used_at=_days_ago(random.randint(0, 5)),
    )
    db.add(key)
    db.flush()
    return key


def _seed_usage(db, key_id, dataset_id, call_count, table_name):
    paths = [
        f"/api/v1/{table_name}",
        f"/api/v1/{table_name}?page=2",
        f"/api/v1/{table_name}/1",
        f"/api/v1/{table_name}/schema",
        f"/api/v1/{table_name}?status=paid",
        f"/api/v1/{table_name}?region=Europe",
    ]
    for _ in range(call_count):
        status = random.choices([200, 200, 200, 200, 200, 404, 403], weights=[70, 10, 5, 5, 5, 3, 2])[0]
        db.add(APIUsage(
            api_key_id=key_id,
            dataset_id=dataset_id,
            method="GET",
            path=random.choice(paths),
            status_code=status,
            response_time_ms=random.randint(8, 280),
            created_at=_days_ago(random.uniform(0, 30)),
        ))


def _seed_conversation(db, dataset_id, col_names):
    msgs = [
        ("assistant", f"I found {len(col_names)} columns in your file: **{', '.join(col_names)}**.\n\nDoes this look correct, or would you like to rename or hide any columns?"),
        ("user", "Looks good! Can you describe what the amount column means?"),
        ("assistant", "Sure! The `amount` column contains numeric values — it looks like it represents monetary amounts (currency). I've set its type to `number`. Should I keep it as-is?"),
        ("user", "Yes, that's perfect. Let's go with this."),
        ("assistant", "Great! Your schema is confirmed. Click **Confirm & Create API** whenever you're ready to go live."),
    ]
    for role, content in msgs:
        db.add(ConversationMessage(dataset_id=dataset_id, role=role, content=content))


# ─── Main seed ────────────────────────────────────────────────────────────────

def seed():
    Base.metadata.create_all(bind=engine)
    db = SessionLocal()

    try:
        # ── Users ──────────────────────────────────────────────────────────
        print("\n📧  Creating accounts…")
        users = {}
        for acc in ACCOUNTS:
            existing = db.query(User).filter(User.email == acc["email"]).first()
            if existing:
                print(f"   ⚠️  {acc['email']} already exists — skipping")
                users[acc["email"]] = existing
                continue
            user = User(
                full_name=acc["full_name"],
                email=acc["email"],
                hashed_password=hash_password(acc["password"]),
                plan=acc["plan"],
                is_admin=acc["is_admin"],
                is_active=True,
            )
            db.add(user)
            db.flush()
            users[acc["email"]] = user
            role = " 👑 ADMIN" if acc["is_admin"] else ""
            print(f"   ✅  {acc['email']}  /  {acc['password']}  [{acc['plan'].value}]{role}")

        db.commit()

        # ── Datasets (assigned to admin user) ──────────────────────────────
        admin_user = users["admin@docapi.com"]
        alice = users["alice@example.com"]

        print("\n📁  Creating sample datasets…")
        for i, ds_def in enumerate(SAMPLE_DATASETS):
            # Alternate between admin and alice
            owner = admin_user if i % 2 == 0 else alice
            table_name = _make_table_name(ds_def["table_suffix"], owner.id)

            existing_ds = db.query(Dataset).filter(Dataset.table_name == table_name).first()
            if existing_ds:
                print(f"   ⚠️  Dataset '{ds_def['name']}' already exists — skipping")
                continue

            schema = {
                "columns": ds_def["columns"],
                "row_count": ds_def["row_count"],
            }

            dataset = Dataset(
                user_id=owner.id,
                name=ds_def["name"],
                doc_type=ds_def["doc_type"],
                original_filename=ds_def["original_filename"],
                file_path=f"uploads/seed_{ds_def['table_suffix']}.csv",
                status=DatasetStatus.active,
                extracted_schema=schema,
                confirmed_schema={"columns": ds_def["columns"], "dataset_name": ds_def["name"]},
                table_name=table_name,
                row_count=ds_def["row_count"],
                created_at=_days_ago(ds_def["created_days_ago"]),
                updated_at=_days_ago(ds_def["created_days_ago"] - 1),
            )
            db.add(dataset)
            db.flush()

            # Seed agent conversation
            col_names = [c["name"] for c in ds_def["columns"][:4]]
            _seed_conversation(db, dataset.id, col_names)

            # Load actual rows into Postgres
            rows = ds_def["rows_fn"]()
            _create_and_load_table(table_name, ds_def["columns"], rows)

            # API key + usage
            key = _make_api_key(db, owner.id, dataset.id, f"{ds_def['name']} — Default Key")
            db.flush()
            _seed_usage(db, key.id, dataset.id, ds_def["api_calls"], table_name)

            print(f"   ✅  '{ds_def['name']}' → table: {table_name}  ({ds_def['row_count']} rows, {ds_def['api_calls']} API calls)")

        # ── Extra API key for alice (global) ───────────────────────────────
        existing_global = db.query(APIKey).filter(
            APIKey.user_id == alice.id,
            APIKey.dataset_id == None
        ).first()
        if not existing_global:
            raw = f"d2e_{secrets.token_urlsafe(32)}"
            db.add(APIKey(
                user_id=alice.id,
                dataset_id=None,
                name="Alice — Global Key",
                key_prefix=raw[:16],
                key_hash=hash_password(raw),
                last_used_at=_days_ago(1),
            ))

        db.commit()

        # ── Summary ────────────────────────────────────────────────────────
        print("\n" + "═" * 60)
        print("  ✅  Seed complete!")
        print("═" * 60)
        print("\n  TEST ACCOUNTS\n")
        print(f"  {'Email':<28} {'Password':<14} {'Plan':<10} {'Role'}")
        print(f"  {'─'*28} {'─'*14} {'─'*10} {'─'*10}")
        for acc in ACCOUNTS:
            role = "Admin" if acc["is_admin"] else "User"
            print(f"  {acc['email']:<28} {acc['password']:<14} {acc['plan'].value:<10} {role}")
        print()
        print("  SAMPLE DATASETS (live API endpoints)\n")
        for ds_def in SAMPLE_DATASETS:
            i = SAMPLE_DATASETS.index(ds_def)
            owner = admin_user if i % 2 == 0 else alice
            table_name = _make_table_name(ds_def["table_suffix"], owner.id)
            print(f"  • {ds_def['name']}")
            print(f"    GET /api/v1/{table_name}")
        print()
        print("  HOW TO GET AN API KEY")
        print("  1. Log in at http://localhost:5173")
        print("  2. Go to Dashboard → API Keys → New API Key")
        print("  3. curl http://localhost:8000/api/v1/<table> -H 'X-API-Key: <key>'")
        print()
        print("  ADMIN PORTAL → http://localhost:5173/admin")
        print("═" * 60 + "\n")

    except Exception as e:
        db.rollback()
        print(f"\n❌  Seed failed: {e}")
        import traceback
        traceback.print_exc()
    finally:
        db.close()


if __name__ == "__main__":
    seed()
