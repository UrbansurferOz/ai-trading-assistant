#!/bin/bash

# Configuration
PROJECT_ID="ai-trading-assistant-488403"
LOCATION="global"
DATA_STORE_ID="tbd-methodology-store"
BUCKET_NAME="gs://tbd-docs-sydney-ai-trading-assistant-488403"
ACCOUNT="stevewwhite@gmail.com"

echo "--------------------------------------------------------"
echo "Initializing Credit-Eligible GenAI App Builder for Steve"
echo "--------------------------------------------------------"

# 1. Ensure we are using the correct account and project
gcloud config set account $ACCOUNT
gcloud config set project $PROJECT_ID

# 2. Enable the Discovery Engine API (This is what uses your $1,500 credit)
echo "Enabling Discovery Engine API..."
gcloud services enable discoveryengine.googleapis.com

# 3. Create the Data Store (The brain for your 51 PDFs)
echo "Creating Data Store: $DATA_STORE_ID..."
curl -X POST \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
-H "Content-Type: application/json" \
"https://discoveryengine.googleapis.com/v1alpha/projects/$PROJECT_ID/locations/$LOCATION/dataStores?dataStoreId=$DATA_STORE_ID" \
-d '{
  "displayName": "TBD Methodology Docs",
  "industryVertical": "GENERIC",
  "contentConfig": "CONTENT_REQUIRED",
  "solutionTypes": ["SOLUTION_TYPE_SEARCH"]
}'

# 4. Import the PDFs from your Sydney Bucket
echo "Importing PDFs from $BUCKET_NAME..."
curl -X POST \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
-H "Content-Type: application/json" \
"https://discoveryengine.googleapis.com/v1alpha/projects/$PROJECT_ID/locations/$LOCATION/dataStores/$DATA_STORE_ID/branches/0/documents:import" \
-d "{
  \"gcsSource\": {
    \"inputUris\": [\"$BUCKET_NAME/*.pdf\"]
  }
}"

echo ""
echo "--------------------------------------------------------"
echo "SETUP INITIATED"
echo "1. Go to: https://console.cloud.google.com/gen-app-builder"
echo "2. Wait ~15 mins for the documents to finish importing."
echo "3. Once done, any queries to this store will use your CREDITS."
echo "--------------------------------------------------------"
