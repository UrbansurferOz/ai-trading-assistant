#!/bin/bash
# Project 2: AI Trading Assistant - Master Control (GitHub + Cloud Build)
# Usage: ./safe_stable_deploy.sh "Your commit message"

COMMIT_MSG=$1
PROJECT_ID="ai-trading-assistant-488403"
REGION="australia-southeast1"
IMAGE_NAME="gcr.io/$PROJECT_ID/tbd-assistant:latest"

if [ -z "$COMMIT_MSG" ]; then
    echo "❌ Error: Commit message required."
    exit 1
fi

echo "--------------------------------------------------------"
echo "🚀 Phase 1: GitHub Version Control (Main)"
echo "--------------------------------------------------------"
# Cleanup system junk before push
git rm -r --cached .gemini/ > /dev/null 2>&1
git rm -r --cached ai-trading-assistant/ > /dev/null 2>&1

git add .
git commit -m "$COMMIT_MSG"
git push origin main

if [ $? -ne 0 ]; then
    echo "❌ Error: GitHub Push failed. Resolve authentication/conflicts first."
    exit 1
fi

echo "--------------------------------------------------------"
echo "🏗️ Phase 2: Building Image in the Cloud (Google Cloud Build)"
echo "--------------------------------------------------------"
gcloud builds submit --tag $IMAGE_NAME .

echo "--------------------------------------------------------"
echo "🏁 Phase 3: Deploying Verified Image to Sydney"
echo "--------------------------------------------------------"
gcloud run deploy tbd-assistant-dashboard \
    --image $IMAGE_NAME \
    --region $REGION \
    --allow-unauthenticated \
    --min-instances 0 \
    --max-instances 1 \
    --memory 1Gi \
    --set-env-vars ENGINE_ID=tbd-trading-engine

echo "--------------------------------------------------------"
echo "✅ Success: Versioned at GitHub & Deployed to Sydney"
echo "URL: https://tbd-assistant-dashboard-521864748129.australia-southeast1.run.app/"
echo "--------------------------------------------------------"
