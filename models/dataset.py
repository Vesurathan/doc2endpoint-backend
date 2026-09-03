from datetime import datetime, timezone
from sqlalchemy import String, DateTime, Integer, Boolean, ForeignKey, Enum as SAEnum, JSON, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship
from db.database import Base
import enum


class DocType(str, enum.Enum):
    excel = "excel"
    csv = "csv"
    pdf = "pdf"
    docx = "docx"
    image = "image"


class DatasetStatus(str, enum.Enum):
    uploading = "uploading"
    extracting = "extracting"
    reviewing = "reviewing"   # agent conversation in progress
    active = "active"         # confirmed, table created, API live
    failed = "failed"


class Dataset(Base):
    __tablename__ = "datasets"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(Integer, ForeignKey("users.id"), index=True)
    name: Mapped[str] = mapped_column(String(255))
    doc_type: Mapped[DocType] = mapped_column(SAEnum(DocType))
    original_filename: Mapped[str] = mapped_column(String(500))
    file_path: Mapped[str] = mapped_column(String(1000))
    status: Mapped[DatasetStatus] = mapped_column(SAEnum(DatasetStatus), default=DatasetStatus.uploading)
    extracted_schema: Mapped[dict | None] = mapped_column(JSON, nullable=True)
    confirmed_schema: Mapped[dict | None] = mapped_column(JSON, nullable=True)
    table_name: Mapped[str | None] = mapped_column(String(255), nullable=True, unique=True)
    custom_endpoint: Mapped[str | None] = mapped_column(String(255), nullable=True, unique=True)
    row_count: Mapped[int] = mapped_column(Integer, default=0)

    # ── Public gallery ──────────────────────────────────────────────────────
    is_public: Mapped[bool] = mapped_column(Boolean, default=False)
    public_description: Mapped[str | None] = mapped_column(Text, nullable=True)

    # ── Webhooks ────────────────────────────────────────────────────────────
    webhook_url: Mapped[str | None] = mapped_column(String(1000), nullable=True)
    webhook_secret: Mapped[str | None] = mapped_column(String(100), nullable=True)

    # ── Scheduled sync ──────────────────────────────────────────────────────
    sync_url: Mapped[str | None] = mapped_column(String(2000), nullable=True)  # Google Sheets CSV export / Dropbox / direct URL
    sync_interval_hours: Mapped[int | None] = mapped_column(Integer, nullable=True)
    last_synced_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))

    messages: Mapped[list["ConversationMessage"]] = relationship("ConversationMessage", back_populates="dataset", order_by="ConversationMessage.id")


class ConversationMessage(Base):
    __tablename__ = "conversation_messages"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    dataset_id: Mapped[int] = mapped_column(Integer, ForeignKey("datasets.id"), index=True)
    role: Mapped[str] = mapped_column(String(20))   # "user" | "assistant"
    content: Mapped[str] = mapped_column(Text)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))

    dataset: Mapped["Dataset"] = relationship("Dataset", back_populates="messages")
