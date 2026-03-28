#!/bin/bash
PROJECT_ID="ai-trading-assistant-488403"
SA_EMAIL="steve-service-account@$PROJECT_ID.iam.gserviceaccount.com"
export GOOGLE_APPLICATION_CREDENTIALS="/home/stevewwhite/ai-trading-assistant-488403-d06cf9935743.json"

echo "🛫 Resuming TBD Trading Environment..."

# 1. Identity Enforcement
gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS --quiet
gcloud config set project $PROJECT_ID --quiet

# 2. Data Verification (This confirms Storage Access is working)
echo "📊 Verifying TBD methodology files in Sydney bucket..."
FILE_COUNT=$(gsutil ls gs://tbd-docs-sydney-ai-trading-assistant-488403/*.pdf 2>/dev/null | wc -l)

if [ "$FILE_COUNT" -gt 0 ]; then
    echo "✅ Success: Found $FILE_COUNT methodology files. Storage access verified."
else
    echo "❌ Error: Could not access bucket. Check permissions in Console."
    exit 1
fi

# 3. Launch
echo "🚀 Launching Dashboard on Port 8080..."
streamlit run ~/ai-trading-assistant/dashboard.py --server.port 8080 --server.headless true
