"""
Webhook delivery service.
Signs payloads with HMAC-SHA256 when a secret is configured.
"""
import hashlib
import hmac
import json
import logging
import time
from typing import Any

import httpx

logger = logging.getLogger(__name__)

MAX_RETRIES = 3
TIMEOUT = 10.0


def _sign(payload: str, secret: str) -> str:
    return "sha256=" + hmac.new(
        secret.encode(), payload.encode(), hashlib.sha256
    ).hexdigest()


def fire_webhook(url: str, secret: str | None, payload: dict[str, Any]) -> bool:
    """
    POST payload to url. Returns True on success.
    Retries up to MAX_RETRIES times with exponential back-off.
    """
    body = json.dumps({**payload, "timestamp": int(time.time())})
    headers = {
        "Content-Type": "application/json",
        "User-Agent": "Doc2Endpoint-Webhook/1.0",
        "X-Doc2Endpoint-Event": payload.get("event", ""),
    }
    if secret:
        headers["X-Doc2Endpoint-Signature"] = _sign(body, secret)

    for attempt in range(1, MAX_RETRIES + 1):
        try:
            with httpx.Client(timeout=TIMEOUT) as client:
                resp = client.post(url, content=body, headers=headers)
            if resp.status_code < 300:
                return True
            logger.warning("Webhook attempt %d/%d → %d %s", attempt, MAX_RETRIES, resp.status_code, url)
        except Exception as exc:
            logger.warning("Webhook attempt %d/%d failed: %s", attempt, MAX_RETRIES, exc)
        if attempt < MAX_RETRIES:
            time.sleep(2 ** attempt)

    logger.error("Webhook delivery failed after %d attempts: %s", MAX_RETRIES, url)
    return False
