#!/bin/bash
# Project 2: AI Trading Assistant - Master Control Script
# Usage: ./safe_deploy.sh "Your commit message here"

COMMIT_MSG=$1

if [ -z "$COMMIT_MSG" ]; then
    echo "❌ Error: You must provide a commit message."
    echo "Usage: ./safe_deploy.sh \"restored sidebar uploader\""
    exit 1
fi

echo "--------------------------------------------------------"
echo "🚀 Step 1: Versioning Changes in GitHub"
echo "--------------------------------------------------------"
git add .
git commit -m "$COMMIT_MSG"
git push origin main

if [ $? -eq 0 ]; then
    echo "✅ Success: Code versioned at https://github.com/UrbansurferOz/ai-trading-assistant"
else
    echo "❌ Error: Git push failed. Fix conflicts before deploying."
    exit 1
fi

echo "--------------------------------------------------------"
echo "🏗️ Step 2: Deploying to Cloud Run (Sydney)"
echo "--------------------------------------------------------"
./deploy_trading_ui.sh

echo "--------------------------------------------------------"
echo "🏁 Final Status: Versioned & Deployed"
echo "URL: https://tbd-assistant-dashboard-521864748129.australia-southeast1.run.app/"
echo "--------------------------------------------------------"
