from datetime import datetime, timezone
from sqlalchemy import String, DateTime, Boolean, Integer, ForeignKey, JSON
from sqlalchemy.orm import Mapped, mapped_column
from db.database import Base


class APIKey(Base):
    __tablename__ = "api_keys"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(Integer, ForeignKey("users.id"), index=True)
    dataset_id: Mapped[int | None] = mapped_column(Integer, ForeignKey("datasets.id"), nullable=True)
    name: Mapped[str] = mapped_column(String(255))
    key_prefix: Mapped[str] = mapped_column(String(20))   # first chars, shown in UI
    key_hash: Mapped[str] = mapped_column(String(255))    # hashed full key
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    # Row-level access control: {"region": "US", "status": "active"}
    # Applied as mandatory WHERE clauses on every query using this key
    row_filters: Mapped[dict | None] = mapped_column(JSON, nullable=True)
    last_used_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
