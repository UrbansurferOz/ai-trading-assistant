import os
from google.cloud import storage
from google.cloud import aiplatform
from vertexai.generative_models import GenerativeModel, Part
import vertexai

# Initialize
PROJECT_ID = "ai-trading-assistant-488403"
REGION = "us-central1"
BUCKET_NAME = "tbd-docs-sydney-ai-trading-assistant-488403"

vertexai.init(project=PROJECT_ID, location=REGION)

def create_cache():
    storage_client = storage.Client()
    bucket = storage_client.bucket(BUCKET_NAME)
    
    # Explicitly list all blobs to avoid wildcard 404
    blobs = bucket.list_blobs(prefix="")
    pdf_parts = []
    
    for blob in blobs:
        if blob.name.endswith(".pdf"):
            print(f"Adding to cache: {blob.name}")
            pdf_parts.append(Part.from_uri(f"gs://{BUCKET_NAME}/{blob.name}", mime_type="application/pdf"))

    if not pdf_parts:
        print("❌ No PDFs found in bucket.")
        return

    # Create the cache
    # Note: Using Gemini 1.5 Pro for massive context support
    model = GenerativeModel("gemini-1.5-pro-002")
    
    try:
        # Building the 24-hour context
        cache = model.create_cached_content(
            contents=pdf_parts,
            display_name="tbd_methodology_cache",
            ttl_seconds=86400  # 24 hours
        )
        print(f"✅ Cache Created Successfully: {cache.name}")
    except Exception as e:
        print(f"❌ Cache creation failed: {e}")

if __name__ == "__main__":
    create_cache()
