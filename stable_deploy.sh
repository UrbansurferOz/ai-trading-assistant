#!/bin/bash
PROJECT_ID="ai-trading-assistant-488403"
REGION="australia-southeast1"
IMAGE_NAME="gcr.io/$PROJECT_ID/tbd-assistant:latest"

echo "--------------------------------------------------------"
echo "Phase 1: Building Image in the Cloud (No local crash)"
echo "--------------------------------------------------------"

# 1. Manually submit the build to Google's backend
gcloud builds submit --tag $IMAGE_NAME .

echo "--------------------------------------------------------"
echo "Phase 2: Deploying the Verified Image to Sydney"
echo "--------------------------------------------------------"

# 2. Deploy the existing image (bypassing the --source bug)
gcloud run deploy tbd-assistant-dashboard \
    --image $IMAGE_NAME \
    --region $REGION \
    --allow-unauthenticated \
    --min-instances 0 \
    --max-instances 1 \
    --memory 1Gi
