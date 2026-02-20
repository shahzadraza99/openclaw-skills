#!/bin/bash
# ============================================================
# Example: Appointment Booking Flow with GHL API
# ============================================================
# Prerequisites:
#   export GHL_API_KEY="your-api-key"
#   export GHL_LOCATION_ID="your-location-id"
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "${SCRIPT_DIR}/scripts/ghl_api.sh"

echo "=== GHL Appointment Booking Examples ==="

# 1. List all calendars
echo -e "\n--- Listing calendars ---"
CALENDARS=$(ghl_list_calendars)
echo "$CALENDARS" | python3 -m json.tool 2>/dev/null || echo "$CALENDARS"

# Extract first calendar ID
CALENDAR_ID=$(echo "$CALENDARS" | python3 -c "import sys,json; cals=json.load(sys.stdin).get('calendars',[]); print(cals[0]['id'] if cals else '')" 2>/dev/null)

if [ -n "$CALENDAR_ID" ] && [ "$CALENDAR_ID" != "" ]; then
  # 2. Get free slots for the next 7 days
  START_DATE=$(date +%Y-%m-%d)
  END_DATE=$(date -v+7d +%Y-%m-%d 2>/dev/null || date -d "+7 days" +%Y-%m-%d)

  echo -e "\n--- Free slots from $START_DATE to $END_DATE ---"
  ghl_get_free_slots "$CALENDAR_ID" "$START_DATE" "$END_DATE" "America/New_York" | python3 -m json.tool 2>/dev/null

  # 3. Create an appointment
  echo -e "\n--- Creating appointment ---"
  ghl_create_appointment '{
    "calendarId": "'$CALENDAR_ID'",
    "locationId": "'$GHL_LOCATION_ID'",
    "contactId": "YOUR_CONTACT_ID",
    "startTime": "'$(date -v+2d +%Y-%m-%dT10:00:00Z 2>/dev/null || date -d "+2 days" +%Y-%m-%dT10:00:00Z)'",
    "endTime": "'$(date -v+2d +%Y-%m-%dT11:00:00Z 2>/dev/null || date -d "+2 days" +%Y-%m-%dT11:00:00Z)'",
    "title": "Discovery Call",
    "appointmentStatus": "confirmed",
    "notes": "Booked via API"
  }' | python3 -m json.tool 2>/dev/null
else
  echo "No calendars found. Create one in GHL first."
fi

echo -e "\n=== Done ==="
