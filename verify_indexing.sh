#!/bin/bash

PROJECT_ID="ai-trading-assistant-488403"
LOCATION="global"
DATA_STORE_ID="tbd-methodology-store"

echo "--------------------------------------------------------"
echo "Verifying Document Ingestion for Steve"
echo "--------------------------------------------------------"

# Check document count in the data store
DOC_COUNT=$(curl -X GET \
-H "Authorization: Bearer $(gcloud auth print-access-token)" \
"https://discoveryengine.googleapis.com/v1alpha/projects/$PROJECT_ID/locations/$LOCATION/dataStores/$DATA_STORE_ID/branches/0/documents" \
| grep -c "name")

echo "Total Documents Indexed: $DOC_COUNT"

if [ "$DOC_COUNT" -gt 0 ]; then
    echo "SUCCESS: Your documents are ready."
    echo "Any queries made through the Search Console or API now use your credits."
else
    echo "STILL PROCESSING: No documents found yet. Check the console for errors."
fi
echo "--------------------------------------------------------"
