#!/bin/bash
# ============================================================
# Example: Webhook Setup with GHL API
# ============================================================
# Prerequisites:
#   export GHL_API_KEY="your-api-key"
#   export GHL_LOCATION_ID="your-location-id"
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "${SCRIPT_DIR}/scripts/ghl_api.sh"

echo "=== GHL Webhook Setup Examples ==="

# 1. List existing webhooks
echo -e "\n--- Current webhooks ---"
ghl_list_webhooks | python3 -m json.tool 2>/dev/null

# 2. Create a webhook for contact events
echo -e "\n--- Creating contact event webhook ---"
ghl_create_webhook \
  "https://your-server.com/webhooks/ghl/contacts" \
  '["ContactCreate","ContactUpdate","ContactDelete","ContactTagUpdate"]' \
  | python3 -m json.tool 2>/dev/null

# 3. Create a webhook for appointment events
echo -e "\n--- Creating appointment event webhook ---"
ghl_create_webhook \
  "https://your-server.com/webhooks/ghl/appointments" \
  '["AppointmentCreate","AppointmentUpdate","AppointmentDelete"]' \
  | python3 -m json.tool 2>/dev/null

# 4. Create a webhook for opportunity events
echo -e "\n--- Creating opportunity event webhook ---"
ghl_create_webhook \
  "https://your-server.com/webhooks/ghl/opportunities" \
  '["OpportunityCreate","OpportunityStatusUpdate","OpportunityStageUpdate"]' \
  | python3 -m json.tool 2>/dev/null

# 5. Create a webhook for payment/invoice events
echo -e "\n--- Creating payment event webhook ---"
ghl_create_webhook \
  "https://your-server.com/webhooks/ghl/payments" \
  '["PaymentReceived","InvoicePaid","InvoiceSent"]' \
  | python3 -m json.tool 2>/dev/null

echo -e "\n=== Done ==="
