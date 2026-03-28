from google.cloud import discoveryengine
import os

os.environ["GOOGLE_CLOUD_PROJECT"] = "ai-trading-assistant-488403"
client = discoveryengine.DocumentServiceClient()

# Target the NEW Enterprise store
parent = "projects/ai-trading-assistant-488403/locations/global/collections/default_collection/dataStores/tbd_enterprise_store/branches/0"

request = discoveryengine.ImportDocumentsRequest(
    parent=parent,
    gcs_source=discoveryengine.GcsSource(
        input_uris=["gs://tbd-docs-sydney-ai-trading-assistant-488403/*.pdf"],
        data_schema="content"
    ),
    reconciliation_mode=discoveryengine.ImportDocumentsRequest.ReconciliationMode.INCREMENTAL,
)

print("--------------------------------------------------------")
print("Triggering Ingestion into Enterprise Store (Sydney)...")
print("--------------------------------------------------------")
operation = client.import_documents(request=request)
print(f"Operation started: {operation.operation.name}")
print("Wait ~5-10 minutes for vectorization to complete.")
