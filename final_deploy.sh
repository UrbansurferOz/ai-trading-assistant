#!/bin/bash
PROJECT_ID="ai-trading-assistant-488403"
REGION="australia-southeast1"
SERVICE_NAME="tbd-assistant-dashboard"

echo "--------------------------------------------------------"
echo "Re-building and Deploying Steve's Sydney Dashboard"
echo "--------------------------------------------------------"

# 1. Ensure the files exist in the current directory
cat << 'APP_EOF' > app.py
import streamlit as st
from google.cloud import discoveryengine_v1beta as discoveryengine

st.set_page_config(page_title="Steve's TBD Assistant", layout="wide")
st.title("📈 TBD Methodology Assistant")

def search_methodology(query):
    client = discoveryengine.SearchServiceClient()
    serving_config = f"projects/ai-trading-assistant-488403/locations/global/collections/default_collection/dataStores/tbd_methodology_store/servingConfigs/default_search"
    request = discoveryengine.SearchRequest(serving_config=serving_config, query=query, page_size=3)
    response = client.search(request)
    return response.results[0].document.derived_struct_data['snippets'][0]['snippet'] if response.results else "No results."

query = st.text_input("Ask a methodology question:")
if query:
    st.write(search_methodology(query))
APP_EOF

cat << 'REQ_EOF' > requirements.txt
streamlit
google-cloud-discoveryengine
REQ_EOF

cat << 'DOCKER_EOF' > Dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
EXPOSE 8080
ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=8080", "--server.address=0.0.0.0"]
DOCKER_EOF

# 2. Deploy to Cloud Run
gcloud run deploy $SERVICE_NAME \
    --source . \
    --region $REGION \
    --allow-unauthenticated \
    --min-instances 0 \
    --max-instances 1
