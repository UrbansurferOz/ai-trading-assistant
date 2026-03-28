#!/bin/bash

PROJECT_ID="ai-trading-assistant-488403"
LOCATION="global"
DATA_STORE_ID="tbd_methodology_store"
BUCKET_NAME="gs://tbd-docs-sydney-ai-trading-assistant-488403"

echo "--------------------------------------------------------"
echo "Rebuilding Steve's Credit-Eligible Store with Quota Header"
echo "--------------------------------------------------------"

# 1. Create the Data Store with the Quota Header
echo "Initializing Data Store..."
curl -X POST \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
-H "x-goog-user-project: $PROJECT_ID" \
-H "Content-Type: application/json" \
"https://discoveryengine.googleapis.com/v1alpha/projects/$PROJECT_ID/locations/$LOCATION/collections/default_collection/dataStores?dataStoreId=$DATA_STORE_ID" \
-d '{
  "displayName": "TBD Methodology Docs",
  "industryVertical": "GENERIC",
  "contentConfig": "CONTENT_REQUIRED",
  "solutionTypes": ["SOLUTION_TYPE_SEARCH"]
}'

# 2. Re-trigger the PDF Import with the Quota Header
echo "Importing 51 PDFs from Sydney Bucket..."
curl -X POST \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
-H "x-goog-user-project: $PROJECT_ID" \
-H "Content-Type: application/json" \
"https://discoveryengine.googleapis.com/v1alpha/projects/$PROJECT_ID/locations/$LOCATION/collections/default_collection/dataStores/$DATA_STORE_ID/branches/0/documents:import" \
-d "{
  \"gcsSource\": {
    \"inputUris\": [\"$BUCKET_NAME/*.pdf\"]
  }
}"

echo ""
echo "--------------------------------------------------------"
echo "SUCCESS: The import has been re-triggered with Quota Project."
echo "--------------------------------------------------------"
