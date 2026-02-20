#!/bin/bash
# ============================================================
# GHL API Helper Script
# Usage: source this file then call functions directly
# Requires: GHL_API_KEY and GHL_LOCATION_ID env variables
# ============================================================

GHL_BASE_URL="https://services.leadconnectorhq.com"
GHL_API_VERSION="2021-07-28"

# ---- Validation ----
ghl_check_env() {
  if [ -z "$GHL_API_KEY" ]; then
    echo "ERROR: GHL_API_KEY environment variable is not set."
    return 1
  fi
  if [ -z "$GHL_LOCATION_ID" ]; then
    echo "WARNING: GHL_LOCATION_ID is not set. Some endpoints require it."
  fi
  return 0
}

# ---- Generic API call ----
ghl_api() {
  local method="$1"
  local endpoint="$2"
  local data="$3"

  ghl_check_env || return 1

  local args=(
    -s -X "$method"
    "${GHL_BASE_URL}${endpoint}"
    -H "Authorization: Bearer ${GHL_API_KEY}"
    -H "Content-Type: application/json"
    -H "Version: ${GHL_API_VERSION}"
  )

  if [ -n "$data" ]; then
    args+=(-d "$data")
  fi

  curl "${args[@]}"
}

# ---- Contacts ----
ghl_list_contacts() {
  local query="${1:-}"
  local limit="${2:-20}"
  ghl_api GET "/contacts/?locationId=${GHL_LOCATION_ID}&query=${query}&limit=${limit}"
}

ghl_get_contact() {
  local contact_id="$1"
  ghl_api GET "/contacts/${contact_id}"
}

ghl_create_contact() {
  local json_data="$1"
  ghl_api POST "/contacts/" "$json_data"
}

ghl_update_contact() {
  local contact_id="$1"
  local json_data="$2"
  ghl_api PUT "/contacts/${contact_id}" "$json_data"
}

ghl_delete_contact() {
  local contact_id="$1"
  ghl_api DELETE "/contacts/${contact_id}"
}

ghl_upsert_contact() {
  local json_data="$1"
  ghl_api POST "/contacts/upsert" "$json_data"
}

# ---- Conversations ----
ghl_send_message() {
  local json_data="$1"
  ghl_api POST "/conversations/messages" "$json_data"
}

ghl_send_sms() {
  local contact_id="$1"
  local message="$2"
  ghl_send_message "{\"type\":\"SMS\",\"contactId\":\"${contact_id}\",\"message\":\"${message}\"}"
}

ghl_send_email() {
  local contact_id="$1"
  local subject="$2"
  local body="$3"
  local from_name="$4"
  local from_email="$5"
  ghl_send_message "{\"type\":\"Email\",\"contactId\":\"${contact_id}\",\"subject\":\"${subject}\",\"html\":\"${body}\",\"emailFrom\":\"${from_name} <${from_email}>\"}"
}

# ---- Calendars ----
ghl_list_calendars() {
  ghl_api GET "/calendars/?locationId=${GHL_LOCATION_ID}"
}

ghl_get_free_slots() {
  local calendar_id="$1"
  local start_date="$2"
  local end_date="$3"
  local timezone="${4:-America/New_York}"
  ghl_api GET "/calendars/${calendar_id}/free-slots?startDate=${start_date}&endDate=${end_date}&timezone=${timezone}"
}

ghl_create_appointment() {
  local json_data="$1"
  ghl_api POST "/calendars/events" "$json_data"
}

# ---- Opportunities ----
ghl_list_pipelines() {
  ghl_api GET "/opportunities/pipelines?locationId=${GHL_LOCATION_ID}"
}

ghl_search_opportunities() {
  local pipeline_id="$1"
  local limit="${2:-20}"
  ghl_api GET "/opportunities/search?locationId=${GHL_LOCATION_ID}&pipelineId=${pipeline_id}&limit=${limit}"
}

ghl_create_opportunity() {
  local json_data="$1"
  ghl_api POST "/opportunities/" "$json_data"
}

# ---- Invoices ----
ghl_list_invoices() {
  local limit="${1:-20}"
  ghl_api GET "/invoices/?altId=${GHL_LOCATION_ID}&altType=location&limit=${limit}"
}

ghl_create_invoice() {
  local json_data="$1"
  ghl_api POST "/invoices/" "$json_data"
}

ghl_send_invoice() {
  local invoice_id="$1"
  ghl_api POST "/invoices/${invoice_id}/send"
}

# ---- Workflows ----
ghl_list_workflows() {
  ghl_api GET "/workflows/?locationId=${GHL_LOCATION_ID}"
}

# ---- Funnels ----
ghl_list_funnels() {
  ghl_api GET "/funnels/?locationId=${GHL_LOCATION_ID}"
}

# ---- Forms ----
ghl_list_forms() {
  ghl_api GET "/forms/?locationId=${GHL_LOCATION_ID}"
}

ghl_get_form_submissions() {
  local form_id="${1:-}"
  local limit="${2:-20}"
  ghl_api GET "/forms/submissions?locationId=${GHL_LOCATION_ID}&formId=${form_id}&limit=${limit}"
}

# ---- Surveys ----
ghl_list_surveys() {
  ghl_api GET "/surveys/?locationId=${GHL_LOCATION_ID}"
}

# ---- Social Planner ----
ghl_list_social_posts() {
  ghl_api GET "/social-media-posting/posts?locationId=${GHL_LOCATION_ID}"
}

ghl_create_social_post() {
  local json_data="$1"
  ghl_api POST "/social-media-posting/posts" "$json_data"
}

# ---- Media ----
ghl_list_media() {
  ghl_api GET "/medias/?locationId=${GHL_LOCATION_ID}"
}

ghl_upload_media() {
  local file_path="$1"
  local name="$2"
  ghl_check_env || return 1
  curl -s -X POST "${GHL_BASE_URL}/medias/upload-file" \
    -H "Authorization: Bearer ${GHL_API_KEY}" \
    -H "Version: ${GHL_API_VERSION}" \
    -F "file=@${file_path}" \
    -F "locationId=${GHL_LOCATION_ID}" \
    -F "name=${name}"
}

# ---- Webhooks ----
ghl_list_webhooks() {
  ghl_api GET "/webhooks/?locationId=${GHL_LOCATION_ID}"
}

ghl_create_webhook() {
  local url="$1"
  local events="$2"  # JSON array string, e.g. '["ContactCreate","ContactUpdate"]'
  ghl_api POST "/webhooks/" "{\"locationId\":\"${GHL_LOCATION_ID}\",\"url\":\"${url}\",\"events\":${events}}"
}

# ---- Products ----
ghl_list_products() {
  ghl_api GET "/products/?locationId=${GHL_LOCATION_ID}"
}

ghl_create_product() {
  local json_data="$1"
  ghl_api POST "/products/" "$json_data"
}

# ---- Companies ----
ghl_list_companies() {
  ghl_api GET "/companies/?locationId=${GHL_LOCATION_ID}"
}

ghl_create_company() {
  local json_data="$1"
  ghl_api POST "/companies/" "$json_data"
}

# ---- Tags ----
ghl_list_tags() {
  ghl_api GET "/locations/${GHL_LOCATION_ID}/tags"
}

ghl_create_tag() {
  local name="$1"
  ghl_api POST "/locations/${GHL_LOCATION_ID}/tags" "{\"name\":\"${name}\"}"
}

# ---- Custom Fields ----
ghl_list_custom_fields() {
  ghl_api GET "/custom-fields/?locationId=${GHL_LOCATION_ID}"
}

# ---- Custom Values ----
ghl_list_custom_values() {
  ghl_api GET "/custom-values/?locationId=${GHL_LOCATION_ID}"
}

# ---- Users ----
ghl_list_users() {
  ghl_api GET "/users/?locationId=${GHL_LOCATION_ID}"
}

# ---- Courses ----
ghl_list_courses() {
  ghl_api GET "/courses/?locationId=${GHL_LOCATION_ID}"
}

# ---- Businesses ----
ghl_list_businesses() {
  ghl_api GET "/businesses/?locationId=${GHL_LOCATION_ID}"
}

# ---- Snapshots ----
ghl_list_snapshots() {
  local company_id="$1"
  ghl_api GET "/snapshots/?companyId=${company_id}"
}

# ---- OAuth Token Refresh ----
ghl_refresh_token() {
  local client_id="$1"
  local client_secret="$2"
  local refresh_token="$3"
  curl -s -X POST "${GHL_BASE_URL}/oauth/token" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "client_id=${client_id}" \
    -d "client_secret=${client_secret}" \
    -d "grant_type=refresh_token" \
    -d "refresh_token=${refresh_token}"
}

echo "GHL API Helper loaded. Set GHL_API_KEY and GHL_LOCATION_ID to begin."
