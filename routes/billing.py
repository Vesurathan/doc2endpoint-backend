"""
Stripe billing — Checkout, Customer Portal, Webhooks.

Environment variables required:
  STRIPE_SECRET_KEY          sk_live_... or sk_test_...
  STRIPE_WEBHOOK_SECRET      whsec_...  (from Stripe dashboard or `stripe listen`)
  STRIPE_PREMIUM_PRICE_ID    price_...  (monthly recurring, $29)
  STRIPE_PRO_PRICE_ID        price_...  (monthly recurring, $79)
  FRONTEND_URL               http://localhost:5173  (no trailing slash)
"""

import stripe
from fastapi import APIRouter, Depends, HTTPException, Request
from sqlalchemy.orm import Session

from core.config import settings
from db.database import get_db
from models.user import User, Plan
from routes.auth import get_current_user

router = APIRouter(prefix="/billing", tags=["billing"])

stripe.api_key      = settings.STRIPE_SECRET_KEY

WEBHOOK_SECRET      = settings.STRIPE_WEBHOOK_SECRET
PREMIUM_PRICE_ID    = settings.STRIPE_PREMIUM_PRICE_ID
PRO_PRICE_ID        = settings.STRIPE_PRO_PRICE_ID
FRONTEND_URL        = settings.FRONTEND_URL

PLAN_PRICE_MAP = {
    "premium": PREMIUM_PRICE_ID,
    "pro":     PRO_PRICE_ID,
}

# ── Helpers ───────────────────────────────────────────────────────────────────

def _get_or_create_customer(user: User) -> str:
    """Return existing Stripe customer ID or create one and persist it."""
    if user.stripe_customer_id:
        return user.stripe_customer_id
    customer = stripe.Customer.create(
        email=user.email,
        name=user.full_name,
        metadata={"user_id": str(user.id)},
    )
    user.stripe_customer_id = customer.id
    return customer.id


def _plan_from_price(price_id: str) -> Plan | None:
    if price_id == PREMIUM_PRICE_ID:
        return Plan.premium
    if price_id == PRO_PRICE_ID:
        return Plan.pro
    return None


# ── Routes ────────────────────────────────────────────────────────────────────

@router.post("/create-checkout-session")
def create_checkout_session(
    body: dict,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    plan_name = body.get("plan", "").lower()
    price_id = PLAN_PRICE_MAP.get(plan_name)

    if not price_id:
        raise HTTPException(400, f"Unknown plan: {plan_name!r}. Use 'premium' or 'pro'.")

    if not stripe.api_key:
        raise HTTPException(503, "Stripe is not configured on this server.")

    customer_id = _get_or_create_customer(current_user)
    db.add(current_user)
    db.commit()

    try:
        session = stripe.checkout.Session.create(
            customer=customer_id,
            payment_method_types=["card"],
            line_items=[{"price": price_id, "quantity": 1}],
            mode="subscription",
            subscription_data={
                "trial_period_days": 7,
                "metadata": {"user_id": str(current_user.id), "plan": plan_name},
            },
            metadata={"user_id": str(current_user.id), "plan": plan_name},
            success_url=f"{FRONTEND_URL}/dashboard/settings?upgraded=true&plan={plan_name}",
            cancel_url=f"{FRONTEND_URL}/dashboard/settings?upgraded=false",
            allow_promotion_codes=True,
        )
    except stripe.StripeError as e:
        raise HTTPException(502, str(e))

    return {"url": session.url}


@router.post("/portal-session")
def create_portal_session(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Let paying users open the Stripe Customer Portal to manage / cancel."""
    if not current_user.stripe_customer_id:
        raise HTTPException(400, "No billing account found. Please subscribe first.")

    if not stripe.api_key:
        raise HTTPException(503, "Stripe is not configured on this server.")

    try:
        session = stripe.billing_portal.Session.create(
            customer=current_user.stripe_customer_id,
            return_url=f"{FRONTEND_URL}/dashboard/settings",
        )
    except stripe.StripeError as e:
        raise HTTPException(502, str(e))

    return {"url": session.url}


@router.get("/status")
def billing_status(
    current_user: User = Depends(get_current_user),
):
    """Return current plan + whether a Stripe subscription exists."""
    return {
        "plan": current_user.plan,
        "has_subscription": bool(current_user.stripe_subscription_id),
        "stripe_customer_id": current_user.stripe_customer_id,
    }


@router.get("/subscription-details")
def subscription_details(
    current_user: User = Depends(get_current_user),
):
    """
    Return rich subscription info for the Billing page.
    If no Stripe subscription exists, returns a free-plan summary.
    """
    base = {
        "plan": current_user.plan.value if hasattr(current_user.plan, "value") else current_user.plan,
        "status": "free",
        "current_period_end": None,
        "trial_end": None,
        "cancel_at_period_end": False,
        "amount": 0,
        "currency": "usd",
        "interval": None,
    }

    if not current_user.stripe_subscription_id or not stripe.api_key:
        return base

    try:
        sub = stripe.Subscription.retrieve(
            current_user.stripe_subscription_id,
            expand=["items.data.price"],
        )
        price = sub["items"]["data"][0]["price"] if sub.get("items") else {}
        amount = (price.get("unit_amount") or 0) / 100

        base.update({
            "status": sub["status"],                       # active | trialing | past_due | canceled
            "current_period_end": sub["current_period_end"],
            "trial_end": sub.get("trial_end"),
            "cancel_at_period_end": sub.get("cancel_at_period_end", False),
            "amount": amount,
            "currency": price.get("currency", "usd"),
            "interval": price.get("recurring", {}).get("interval"),
        })
    except stripe.StripeError:
        pass  # return base without crashing

    return base


# ── Stripe Webhook ────────────────────────────────────────────────────────────

@router.post("/webhook", include_in_schema=False)
async def stripe_webhook(request: Request, db: Session = Depends(get_db)):
    payload = await request.body()
    sig_header = request.headers.get("stripe-signature", "")

    if not WEBHOOK_SECRET:
        # Dev mode — no signature verification
        import json
        event = stripe.Event.construct_from(json.loads(payload), stripe.api_key)
    else:
        try:
            event = stripe.Webhook.construct_event(payload, sig_header, WEBHOOK_SECRET)
        except stripe.SignatureVerificationError:
            raise HTTPException(400, "Invalid webhook signature")

    _handle_event(event, db)
    return {"received": True}


def _handle_event(event, db: Session):
    etype = event["type"]

    # ── Checkout completed → grant plan immediately ──────────────────────────
    if etype == "checkout.session.completed":
        sess = event["data"]["object"]
        user_id = int(sess.get("metadata", {}).get("user_id", 0))
        plan_name = sess.get("metadata", {}).get("plan", "")
        subscription_id = sess.get("subscription")
        _upgrade_user(db, user_id, plan_name, subscription_id)

    # ── Subscription updated (plan change / renewal) ─────────────────────────
    elif etype == "customer.subscription.updated":
        sub = event["data"]["object"]
        user_id = int(sub.get("metadata", {}).get("user_id", 0))
        plan_name = sub.get("metadata", {}).get("plan", "")
        # If plan changed via Customer Portal, re-derive from price
        if not plan_name and sub.get("items"):
            price_id = sub["items"]["data"][0]["price"]["id"]
            plan_obj = _plan_from_price(price_id)
            plan_name = plan_obj.value if plan_obj else ""
        if user_id and plan_name:
            _upgrade_user(db, user_id, plan_name, sub["id"])

    # ── Subscription cancelled / payment failed → downgrade to free ──────────
    elif etype in ("customer.subscription.deleted", "invoice.payment_failed"):
        sub = event["data"]["object"]
        customer_id = sub.get("customer")
        if customer_id:
            user = db.query(User).filter(User.stripe_customer_id == customer_id).first()
            if user:
                user.plan = Plan.free
                user.stripe_subscription_id = None
                db.commit()

    # ── Trial will end reminder (optional — just log) ────────────────────────
    elif etype == "customer.subscription.trial_will_end":
        pass  # Could send an email here


def _upgrade_user(db: Session, user_id: int, plan_name: str, subscription_id: str | None):
    if not user_id or not plan_name:
        return
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        return
    try:
        user.plan = Plan(plan_name)
    except ValueError:
        return
    if subscription_id:
        user.stripe_subscription_id = subscription_id
    db.commit()
