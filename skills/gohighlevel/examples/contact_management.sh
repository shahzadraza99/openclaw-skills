#!/bin/bash
# ============================================================
# Example: Contact Management with GHL API
# ============================================================
# Prerequisites:
#   export GHL_API_KEY="your-api-key"
#   export GHL_LOCATION_ID="your-location-id"
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "${SCRIPT_DIR}/scripts/ghl_api.sh"

echo "=== GHL Contact Management Examples ==="

# 1. Create a new contact
echo -e "\n--- Creating a new contact ---"
NEW_CONTACT=$(ghl_create_contact '{
  "firstName": "Jane",
  "lastName": "Smith",
  "email": "jane.smith@example.com",
  "phone": "+15551234567",
  "locationId": "'$GHL_LOCATION_ID'",
  "tags": ["new-lead", "website-signup"],
  "source": "API Example",
  "address1": "456 Oak Avenue",
  "city": "Los Angeles",
  "state": "CA",
  "postalCode": "90001",
  "country": "US"
}')
echo "$NEW_CONTACT" | python3 -m json.tool 2>/dev/null || echo "$NEW_CONTACT"

# Extract contact ID (requires jq)
CONTACT_ID=$(echo "$NEW_CONTACT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('contact',{}).get('id',''))" 2>/dev/null)

if [ -n "$CONTACT_ID" ] && [ "$CONTACT_ID" != "" ]; then
  # 2. Get the contact
  echo -e "\n--- Getting contact $CONTACT_ID ---"
  ghl_get_contact "$CONTACT_ID" | python3 -m json.tool 2>/dev/null

  # 3. Update the contact
  echo -e "\n--- Updating contact ---"
  ghl_update_contact "$CONTACT_ID" '{
    "tags": ["new-lead", "website-signup", "vip"],
    "companyName": "Example Corp"
  }' | python3 -m json.tool 2>/dev/null

  # 4. Upsert a contact (create or update by email)
  echo -e "\n--- Upserting contact by email ---"
  ghl_upsert_contact '{
    "email": "jane.smith@example.com",
    "locationId": "'$GHL_LOCATION_ID'",
    "firstName": "Jane",
    "lastName": "Smith-Updated",
    "tags": ["updated-via-upsert"]
  }' | python3 -m json.tool 2>/dev/null
fi

# 5. Search contacts
echo -e "\n--- Searching contacts ---"
ghl_list_contacts "jane" 5 | python3 -m json.tool 2>/dev/null

echo -e "\n=== Done ==="
