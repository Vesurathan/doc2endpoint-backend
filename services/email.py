"""Email sending service via SMTP.

Required environment variables:
    SMTP_HOST     – e.g. smtp.gmail.com
    SMTP_PORT     – 587 (TLS) or 465 (SSL)
    SMTP_USER     – sender address / login
    SMTP_PASSWORD – app password or SMTP key
    FROM_EMAIL    – display sender (defaults to SMTP_USER)
"""

import smtplib
import ssl
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

from core.config import settings


def _send(to: str, subject: str, html: str, text: str) -> bool:
    if not (settings.SMTP_HOST and settings.SMTP_USER and settings.SMTP_PASSWORD):
        # Dev fallback — just print so tests don't fail silently
        print(f"[EMAIL - not configured] To: {to} | Subject: {subject}\n{text}")
        return True

    from_addr = settings.FROM_EMAIL or settings.SMTP_USER
    msg = MIMEMultipart("alternative")
    msg["Subject"] = subject
    msg["From"] = f"Doc2Endpoint <{from_addr}>"
    msg["To"] = to
    msg.attach(MIMEText(text, "plain"))
    msg.attach(MIMEText(html, "html"))

    port = int(settings.SMTP_PORT or 587)
    try:
        if port == 465:
            ctx = ssl.create_default_context()
            with smtplib.SMTP_SSL(settings.SMTP_HOST, port, context=ctx) as s:
                s.login(settings.SMTP_USER, settings.SMTP_PASSWORD)
                s.sendmail(from_addr, to, msg.as_string())
        else:
            with smtplib.SMTP(settings.SMTP_HOST, port) as s:
                s.ehlo()
                s.starttls(context=ssl.create_default_context())
                s.login(settings.SMTP_USER, settings.SMTP_PASSWORD)
                s.sendmail(from_addr, to, msg.as_string())
        return True
    except Exception as e:
        print(f"[EMAIL ERROR] {e}")
        return False


def send_verification_email(to: str, name: str, code: str) -> bool:
    subject = f"{code} is your Doc2Endpoint verification code"
    html = f"""
    <div style="font-family:Arial,sans-serif;max-width:480px;margin:0 auto;padding:32px 24px;background:#fff">
      <h2 style="color:#6366f1;margin:0 0 8px">Doc2Endpoint</h2>
      <p style="color:#374151;font-size:15px">Hi {name},</p>
      <p style="color:#374151;font-size:15px">Use this code to verify your email address:</p>
      <div style="background:#f3f4f6;border-radius:12px;padding:24px;text-align:center;margin:24px 0">
        <span style="font-size:40px;font-weight:700;letter-spacing:10px;color:#111827">{code}</span>
      </div>
      <p style="color:#6b7280;font-size:13px">This code expires in <strong>24 hours</strong>. If you didn't create an account, you can safely ignore this email.</p>
      <hr style="border:none;border-top:1px solid #e5e7eb;margin:24px 0">
      <p style="color:#9ca3af;font-size:12px">Doc2Endpoint — Turn documents into live REST APIs</p>
    </div>
    """
    text = f"Hi {name},\n\nYour Doc2Endpoint verification code is: {code}\n\nThis code expires in 24 hours."
    return _send(to, subject, html, text)
