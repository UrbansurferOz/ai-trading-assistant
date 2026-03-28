import os
from google.cloud import discoveryengine

os.environ["GOOGLE_CLOUD_PROJECT"] = "ai-trading-assistant-488403"
client = discoveryengine.DocumentServiceClient()

# Use the 'default_branch' alias which is more robust
parent = "projects/ai-trading-assistant-488403/locations/global/collections/default_collection/dataStores/tbd_methodology_store/branches/default_branch"

gcs_source = discoveryengine.GcsSource(
    input_uris=["gs://tbd-docs-sydney-ai-trading-assistant-488403/*.pdf"],
    data_schema="content"  # Corrected from 'unstructured'
)

request = discoveryengine.ImportDocumentsRequest(
    parent=parent,
    gcs_source=gcs_source,
    reconciliation_mode=discoveryengine.ImportDocumentsRequest.ReconciliationMode.INCREMENTAL,
)

print("--------------------------------------------------------")
print("Re-triggering ingestion using 'content' schema for PDFs...")
print("--------------------------------------------------------")

try:
    operation = client.import_documents(request=request)
    print(f"✅ Success! New Operation: {operation.operation.name}")
    print("The system is now vectorizing your 51 PDFs.")
except Exception as e:
    print(f"❌ Error: {str(e)}")
