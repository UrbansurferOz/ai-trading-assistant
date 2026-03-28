#!/bin/bash

PROJECT_ID="ai-trading-assistant-488403"
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")
SERVICE_AGENT="service-$PROJECT_NUMBER@gcp-sa-discoveryengine.iam.gserviceaccount.com"

echo "--------------------------------------------------------"
echo "Fixing Permissions for Steve"
echo "--------------------------------------------------------"

# 1. Grant the Service Agent permission to read your Sydney bucket
echo "Granting Storage Object Viewer to: $SERVICE_AGENT"
gcloud storage buckets add-iam-policy-binding gs://tbd-docs-sydney-ai-trading-assistant-488403 \
    --member="serviceAccount:$SERVICE_AGENT" \
    --role="roles/storage.objectViewer"

# 2. Re-trigger the import (now that permissions are fixed)
echo "Re-triggering import from Sydney bucket..."
curl -X POST \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
-H "Content-Type: application/json" \
"https://discoveryengine.googleapis.com/v1alpha/projects/$PROJECT_ID/locations/global/collections/default_collection/dataStores/tbd-methodology-store/branches/0/documents:import" \
-d "{
  \"gcsSource\": {
    \"inputUris\": [\"gs://tbd-docs-sydney-ai-trading-assistant-488403/*.pdf\"]
  }
}"
echo ""
echo "--------------------------------------------------------"
