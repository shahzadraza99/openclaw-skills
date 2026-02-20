"""
Example: Webhook Server using GHL Python SDK
=============================================
A FastAPI webhook server that handles GHL webhook events
with automatic signature validation via the SDK middleware.

Prerequisites:
    pip install gohighlevel-api-client fastapi uvicorn

    Set environment variables:
      export GHL_CLIENT_ID="your-client-id"
      export GHL_CLIENT_SECRET="your-client-secret"
"""

import os
from fastapi import FastAPI, Request
from highlevel import HighLevel

app = FastAPI(title="GHL Webhook Handler")

# Initialize the GHL client
client = HighLevel(
    client_id=os.getenv("GHL_CLIENT_ID", "your_client_id"),
    client_secret=os.getenv("GHL_CLIENT_SECRET", "your_client_secret"),
)

# Create webhook middleware (handles signature validation + INSTALL/UNINSTALL)
webhook_middleware = client.webhooks.subscribe()


@app.post("/api/webhooks/ghl")
async def handle_ghl_webhook(request: Request):
    """
    Main webhook endpoint.
    The SDK middleware automatically:
    - Validates webhook signatures
    - Handles INSTALL events (stores tokens)
    - Handles UNINSTALL events (removes tokens)
    """
    result = await webhook_middleware(request)

    # Parse the webhook body for custom handling
    body = await request.json()
    event_type = body.get("type", "unknown")

    print(f"Received webhook event: {event_type}")

    # Route events to custom handlers
    if event_type == "ContactCreate":
        await handle_contact_created(body)
    elif event_type == "ContactUpdate":
        await handle_contact_updated(body)
    elif event_type == "AppointmentCreate":
        await handle_appointment_created(body)
    elif event_type == "OpportunityStatusUpdate":
        await handle_opportunity_status_changed(body)
    elif event_type == "InboundMessage":
        await handle_inbound_message(body)
    elif event_type == "PaymentReceived":
        await handle_payment_received(body)
    elif event_type == "FormSubmission":
        await handle_form_submission(body)

    return {"status": "success"}


# --- Event Handlers ---

async def handle_contact_created(data: dict):
    """Handle new contact creation."""
    contact = data.get("data", {})
    print(f"New contact: {contact.get('firstName')} {contact.get('lastName')}")
    print(f"  Email: {contact.get('email')}")
    print(f"  Phone: {contact.get('phone')}")
    # Add your business logic here (e.g., sync to external CRM, send welcome email)


async def handle_contact_updated(data: dict):
    """Handle contact updates."""
    contact = data.get("data", {})
    print(f"Contact updated: {contact.get('id')}")
    # Add your sync logic here


async def handle_appointment_created(data: dict):
    """Handle new appointment bookings."""
    appointment = data.get("data", {})
    print(f"New appointment: {appointment.get('title')}")
    print(f"  Start: {appointment.get('startTime')}")
    print(f"  Contact: {appointment.get('contactId')}")
    # Add your notification/sync logic here


async def handle_opportunity_status_changed(data: dict):
    """Handle opportunity status changes (won/lost/etc)."""
    opp = data.get("data", {})
    print(f"Opportunity '{opp.get('name')}' status: {opp.get('status')}")
    # Add alerts, reporting, etc.


async def handle_inbound_message(data: dict):
    """Handle incoming messages (SMS, email, etc)."""
    message = data.get("data", {})
    print(f"Inbound message from: {message.get('contactId')}")
    print(f"  Type: {message.get('type')}")
    print(f"  Content: {message.get('body', '')[:100]}")
    # Add auto-reply logic, AI response, etc.


async def handle_payment_received(data: dict):
    """Handle payment notifications."""
    payment = data.get("data", {})
    print(f"Payment received: ${payment.get('amount', 0) / 100:.2f}")
    # Add fulfillment, receipt logic, etc.


async def handle_form_submission(data: dict):
    """Handle form submissions."""
    submission = data.get("data", {})
    print(f"Form submitted: {submission.get('formId')}")
    # Add lead processing logic


@app.get("/health")
async def health_check():
    """Health check endpoint."""
    return {"status": "healthy", "service": "ghl-webhook-handler"}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
