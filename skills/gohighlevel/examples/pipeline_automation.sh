#!/bin/bash
# ============================================================
# Example: Pipeline & Opportunity Automation with GHL API
# ============================================================
# Prerequisites:
#   export GHL_API_KEY="your-api-key"
#   export GHL_LOCATION_ID="your-location-id"
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "${SCRIPT_DIR}/scripts/ghl_api.sh"

echo "=== GHL Pipeline & Opportunity Examples ==="

# 1. List all pipelines
echo -e "\n--- Listing pipelines ---"
PIPELINES=$(ghl_list_pipelines)
echo "$PIPELINES" | python3 -m json.tool 2>/dev/null || echo "$PIPELINES"

# Extract first pipeline ID and first stage ID
PIPELINE_ID=$(echo "$PIPELINES" | python3 -c "
import sys,json
data = json.load(sys.stdin)
pipes = data.get('pipelines', [])
if pipes:
    print(pipes[0]['id'])
else:
    print('')
" 2>/dev/null)

STAGE_ID=$(echo "$PIPELINES" | python3 -c "
import sys,json
data = json.load(sys.stdin)
pipes = data.get('pipelines', [])
if pipes and pipes[0].get('stages'):
    print(pipes[0]['stages'][0]['id'])
else:
    print('')
" 2>/dev/null)

if [ -n "$PIPELINE_ID" ] && [ "$PIPELINE_ID" != "" ]; then
  # 2. Create a new opportunity
  echo -e "\n--- Creating opportunity ---"
  ghl_create_opportunity '{
    "pipelineId": "'$PIPELINE_ID'",
    "locationId": "'$GHL_LOCATION_ID'",
    "name": "New Deal - API Test",
    "pipelineStageId": "'$STAGE_ID'",
    "status": "open",
    "contactId": "YOUR_CONTACT_ID",
    "monetaryValue": 10000,
    "source": "API Automation"
  }' | python3 -m json.tool 2>/dev/null

  # 3. Search opportunities
  echo -e "\n--- Searching opportunities ---"
  ghl_search_opportunities "$PIPELINE_ID" 10 | python3 -m json.tool 2>/dev/null
else
  echo "No pipelines found. Create one in GHL first."
fi

echo -e "\n=== Done ==="
