#!/bin/bash

PROJECT_ID="ai-trading-assistant-488403"
LOCATION="global"

echo "--------------------------------------------------------"
echo "Checking Import Operations for Steve..."
echo "--------------------------------------------------------"

# List the most recent operations for Discovery Engine
curl -X GET \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
"https://discoveryengine.googleapis.com/v1alpha/projects/$PROJECT_ID/locations/$LOCATION/operations" \
| grep -E "done|metadata|error" -A 5 | head -n 20

echo ""
echo "--------------------------------------------------------"
