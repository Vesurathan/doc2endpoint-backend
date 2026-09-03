"""Cloudflare R2 storage service (S3-compatible).

All file I/O goes through this module so swapping providers only requires
changes here, not throughout the rest of the codebase.

Environment variables required:
    R2_ACCOUNT_ID       – Cloudflare account ID
    R2_ACCESS_KEY_ID    – R2 API token Access Key ID
    R2_SECRET_ACCESS_KEY– R2 API token Secret Access Key
    R2_BUCKET_NAME      – Bucket name (e.g. "doc2endpoint-uploads")

If R2_ACCOUNT_ID is not set the module falls back to local disk storage
so development works without Cloudflare credentials.
"""

import os
import tempfile
import threading
from functools import lru_cache
from core.config import settings


# ── Client ─────────────────────────────────────────────────────────────────────

@lru_cache(maxsize=1)
def _client():
    import boto3
    return boto3.client(
        "s3",
        endpoint_url=f"https://{settings.R2_ACCOUNT_ID}.r2.cloudflarestorage.com",
        aws_access_key_id=settings.R2_ACCESS_KEY_ID,
        aws_secret_access_key=settings.R2_SECRET_ACCESS_KEY,
        region_name="auto",
    )


def _use_r2() -> bool:
    return bool(settings.R2_ACCOUNT_ID and settings.R2_ACCESS_KEY_ID and settings.R2_SECRET_ACCESS_KEY)


# ── Public API ─────────────────────────────────────────────────────────────────

def upload_file(local_path: str, key: str, content_type: str = "application/octet-stream") -> str:
    """Upload a local file to R2. Returns the storage key (use as file_path in DB)."""
    if not _use_r2():
        return local_path  # local fallback — key IS the local path

    _client().upload_file(
        local_path,
        settings.R2_BUCKET_NAME,
        key,
        ExtraArgs={"ContentType": content_type},
    )
    return key  # store the R2 key in the database


def upload_fileobj(fileobj, key: str, content_type: str = "application/octet-stream") -> str:
    """Upload a file-like object to R2."""
    if not _use_r2():
        raise RuntimeError("Cannot upload fileobj without R2 configured.")

    _client().upload_fileobj(
        fileobj,
        settings.R2_BUCKET_NAME,
        key,
        ExtraArgs={"ContentType": content_type},
    )
    return key


def download_to_temp(key: str, suffix: str = "") -> str:
    """Download a file from R2 to a temporary local path. Caller must delete it."""
    if not _use_r2():
        # Local fallback — key is already a local path
        return key

    tmp = tempfile.NamedTemporaryFile(delete=False, suffix=suffix)
    tmp.close()
    _client().download_file(settings.R2_BUCKET_NAME, key, tmp.name)
    return tmp.name


def delete_file(key: str) -> None:
    """Delete a file from R2 (or local disk in fallback mode)."""
    if not _use_r2():
        try:
            os.remove(key)
        except FileNotFoundError:
            pass
        return

    _client().delete_object(Bucket=settings.R2_BUCKET_NAME, Key=key)


def get_public_url(key: str) -> str | None:
    """Return a public URL if the bucket has public access, otherwise None."""
    if not _use_r2() or not settings.R2_PUBLIC_URL:
        return None
    return f"{settings.R2_PUBLIC_URL.rstrip('/')}/{key}"
