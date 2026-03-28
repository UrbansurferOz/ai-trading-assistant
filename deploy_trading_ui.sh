#!/bin/bash
PROJECT_ID="ai-trading-assistant-488403"
REGION="australia-southeast1"
IMAGE_NAME="gcr.io/$PROJECT_ID/tbd-trading-assistant:v1"
SA_EMAIL="steve-service-account@ai-trading-assistant-488403.iam.gserviceaccount.com"

echo "--------------------------------------------------------"
echo "PHASE 1: Building Container Image (Remote Build)"
echo "--------------------------------------------------------"

# Use Cloud Build to avoid local CLI Python errors
gcloud builds submit --tag $IMAGE_NAME .

echo "--------------------------------------------------------"
echo "PHASE 2: Deploying to Cloud Run (Sydney)"
echo "--------------------------------------------------------"

gcloud run deploy tbd-assistant-dashboard \
    --image $IMAGE_NAME \
    --region $REGION \
    --allow-unauthenticated \
    --service-account $SA_EMAIL \
    --memory 1Gi \
    --cpu 1

echo "--------------------------------------------------------"
echo "DEPLOYMENT COMPLETE"
echo "Check the URL provided above to verify your Trading Assistant."
echo "--------------------------------------------------------"
