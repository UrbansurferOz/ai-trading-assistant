import os
import time
from google.cloud import discoveryengine

# Configuration
PROJECT_ID = "ai-trading-assistant-488403"
DATA_STORE_ID = "tbd_methodology_store"
GCS_URI = "gs://tbd-docs-sydney-ai-trading-assistant-488403/**"

client = discoveryengine.DocumentServiceClient()

# Resource path for the 'default' branch
parent = f"projects/{PROJECT_ID}/locations/global/collections/default_collection/dataStores/{DATA_STORE_ID}/branches/0"

request = discoveryengine.ImportDocumentsRequest(
    parent=parent,
    gcs_source=discoveryengine.GcsSource(
        input_uris=[GCS_URI]
    ),
    reconciliation_mode=discoveryengine.ImportDocumentsRequest.ReconciliationMode.INCREMENTAL,
)

print("--------------------------------------------------------")
print(f"Target: {GCS_URI}")
print("Status: Triggering Indexing...")
print("--------------------------------------------------------")

try:
    operation = client.import_documents(request=request)
    print(f"✅ Success! Operation Name: {operation.operation.name}")
    print("\nGoogle's AI is now reading and 'vectorizing' your 51 PDFs.")
    print("Estimated time to complete: 10-15 minutes.")
    print("You can refresh your Cloud Run URL shortly to test the 'W Pattern' query.")
except Exception as e:
    print(f"❌ Error: {str(e)}")
