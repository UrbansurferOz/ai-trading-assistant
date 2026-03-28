from google.cloud import discoveryengine_v1
from google.api_core import operations_v1

# The client for long-running operations
client = operations_v1.OperationsClient(discoveryengine_v1.DocumentServiceClient().transport.operations_client)

name = "projects/521864748129/locations/global/collections/default_collection/dataStores/tbd_methodology_store/branches/0/operations/import-documents-17468908363541705002"

op = client.get_operation(name)
print(f"Done: {op.done}")

if op.done:
    if hasattr(op, 'error') and op.error.message:
        print(f"Error: {op.error.message}")
    else:
        print("✅ Success: Indexing is complete.")
else:
    print("⏳ In Progress: Google is still vectorizing your methodology PDFs...")
