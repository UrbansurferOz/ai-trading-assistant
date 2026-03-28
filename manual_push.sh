#!/bin/bash
PROJECT_ID="ai-trading-assistant-488403"
REGION="australia-southeast1"
IMAGE_NAME="gcr.io/$PROJECT_ID/tbd-dashboard:v1"

echo "--------------------------------------------------------"
echo "Step 1: Building Container Image via Cloud Build"
echo "--------------------------------------------------------"

# Re-create the app files to ensure they are clean
cat << 'APP_EOF' > app.py
import streamlit as st
from google.cloud import discoveryengine_v1beta as discoveryengine

st.set_page_config(page_title="Steve's TBD Assistant", layout="wide")
st.title("📈 TBD Methodology Assistant")

def search_methodology(query):
    try:
        client = discoveryengine.SearchServiceClient()
        serving_config = f"projects/ai-trading-assistant-488403/locations/global/collections/default_collection/dataStores/tbd_methodology_store/servingConfigs/default_search"
        request = discoveryengine.SearchRequest(serving_config=serving_config, query=query, page_size=3)
        response = client.search(request)
        return response.results[0].document.derived_struct_data['snippets'][0]['snippet'] if response.results else "No matches found in methodology docs."
    except Exception as e:
        return f"Error connecting to Data Store: {str(e)}"

query = st.text_input("Ask a methodology question (e.g., 'What is Fibonacci strategy?'):")
if query:
    with st.spinner("Analyzing..."):
        st.info(search_methodology(query))
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

# Submit the build to Cloud Build (removes local gcloud dependency errors)
gcloud builds submit --tag $IMAGE_NAME .

echo "--------------------------------------------------------"
echo "Step 2: Deploying to Cloud Run"
echo "--------------------------------------------------------"

gcloud run deploy tbd-assistant-dashboard \
    --image $IMAGE_NAME \
    --region $REGION \
    --allow-unauthenticated \
    --memory 1Gi
