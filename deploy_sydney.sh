#!/bin/bash
PROJECT_ID="ai-trading-assistant-488403"
REGION="australia-southeast1" # Sydney Region
SERVICE_NAME="tbd-assistant-dashboard"
DOMAIN="yourdomain.com" # <--- REPLACE WITH YOUR ACTUAL DOMAIN

echo "--------------------------------------------------------"
echo "Deploying to Sydney (australia-southeast1)"
echo "--------------------------------------------------------"

gcloud config set project $PROJECT_ID

# 1. Deploy the Streamlit App to Cloud Run (Sydney)
gcloud run deploy $SERVICE_NAME \
    --source . \
    --region $REGION \
    --allow-unauthenticated \
    --min-instances 0 \
    --max-instances 1 \
    --memory 1Gi \
    --cpu 1

# 2. Set up the Custom Domain Mapping
echo "Setting up domain mapping for $DOMAIN..."
gcloud beta run domain-mappings create \
    --service $SERVICE_NAME \
    --domain $DOMAIN \
    --region $REGION

echo "--------------------------------------------------------"
echo "DEPLOYMENT COMPLETE"
echo "1. Check the output above for DNS Resource Records (A/AAAA/CNAME)."
echo "2. Add those records to your domain provider's DNS settings."
echo "3. It may take up to 24 hours for SSL to activate."
echo "--------------------------------------------------------"
