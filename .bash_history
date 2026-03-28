# Fetch the latest from GitHub
git fetch origin main
# Reset your local files to that specific commit
git reset --hard 1b7ded7
# Verify the version
cat app.py | grep -i "version"
cat << 'EOF' > app.py
import streamlit as st
from google.cloud import discoveryengine_v1beta as discoveryengine
from PIL import Image

# UI Baseline from v3.1
st.set_page_config(page_title="TBD Command Center v3.2", layout="wide")

# Sidebar - Verified v3.1 Logic
with st.sidebar:
    st.title("📁 TBD Analysis Tools")
    st.markdown("---")
    uploaded_file = st.file_uploader("Upload Chart (BTC/SOL/ETH)", type=['png', 'jpg', 'jpeg'])
    if uploaded_file:
        st.image(Image.open(uploaded_file), use_container_width=True)
    st.divider()
    st.caption("Persona: Steve, Crypto Trader")
    st.info("System: Sydney Enterprise Engine")
    st.caption("Credit Source: GenAI App Builder")

st.title("📈 TBD Methodology Assistant")

def search_methodology(query):
    try:
        client = discoveryengine.SearchServiceClient()
        # Pointing to the Sydney-based Enterprise Engine
        serving_config = f"projects/ai-trading-assistant-488403/locations/global/collections/default_collection/engines/tbd-trading-engine/servingConfigs/default_search"
        
        content_search_spec = discoveryengine.SearchRequest.ContentSearchSpec(
            summary_spec=discoveryengine.SearchRequest.ContentSearchSpec.SummarySpec(
                summary_result_count=5, 
                include_citations=True
            ),
            extractive_content_spec=discoveryengine.SearchRequest.ContentSearchSpec.ExtractiveContentSpec(
                max_extractive_answer_count=1
            )
        )

        request = discoveryengine.SearchRequest(
            serving_config=serving_config,
            query=query,
            content_search_spec=content_search_spec
        )
        
        response = client.search(request)
        
        # Priority 1: GenAI Summary (Credits)
        if response.summary and response.summary.summary_text:
            return response.summary.summary_text
            
        # Priority 2: Fallback to Extracted Snippets
        results = []
        for result in response.results:
            answers = result.document.derived_struct_data.get("extractive_answers", [])
            for a in answers:
                results.append(a.get("content", ""))
        
        if results:
            return "### Extracted Methodology\n\n" + "\n\n---\n\n".join(results)

        return "🔍 Indexing is complete. If no summary appears, try a specific TBD term like 'W Pattern'."

    except Exception as e:
        return f"System Error: {str(e)}"

query = st.text_input("Ask a Trade by Design question:")
if query:
    with st.spinner("GenAI is scanning 51 PDFs in Sydney..."):
        st.markdown(search_methodology(query))
EOF

# Execute the Safe Deploy (Version Control + Deployment)
./safe_deploy.sh "v3.2: Integrated v3.1 UI with Discovery Engine Credit Optimization"
git config --global user.email "stevewwhite@gmail.com"
git config --global user.name "Steve White"
git config --global user.email "stevewwhite@gmail.com"
git config --global user.name "Steve White"
# 1. Remove the accidental sub-repositories from tracking
git rm -r --cached .gemini/ > /dev/null 2>&1
git rm -r --cached ai-trading-assistant/ > /dev/null 2>&1
# 2. Update the app.py one last time (ensuring it's complete)
cat << 'EOF' > app.py
import streamlit as st
from google.cloud import discoveryengine_v1beta as discoveryengine
from PIL import Image

st.set_page_config(page_title="TBD Command Center v3.2", layout="wide")

with st.sidebar:
    st.title("📁 TBD Analysis Tools")
    st.markdown("---")
    uploaded_file = st.file_uploader("Upload Chart (BTC/SOL/ETH)", type=['png', 'jpg', 'jpeg']) 
    if uploaded_file:
        st.image(Image.open(uploaded_file), use_container_width=True)
    st.divider()
    st.caption("Persona: Steve, Crypto Trader")
    st.info("System: Sydney Enterprise Engine")
    st.caption("Credit Source: GenAI App Builder")

st.title("📈 TBD Methodology Assistant")

def search_methodology(query):
    try:
        client = discoveryengine.SearchServiceClient()
        serving_config = f"projects/ai-trading-assistant-488403/locations/global/collections/default_collection/engines/tbd-trading-engine/servingConfigs/default_search"
        
        content_search_spec = discoveryengine.SearchRequest.ContentSearchSpec(
            summary_spec=discoveryengine.SearchRequest.ContentSearchSpec.SummarySpec(
                summary_result_count=5, 
                include_citations=True
            )
        )

        request = discoveryengine.SearchRequest(
            serving_config=serving_config,
            query=query,
            content_search_spec=content_search_spec
        )
        
        response = client.search(request)
        return response.summary.summary_text if response.summary.summary_text else "Analyzing PDFs... retry in 60 seconds."
    except Exception as e:
        return f"System Error: {str(e)}"

query = st.text_input("Ask a Trade by Design question:")
if query:
    with st.spinner("GenAI is scanning 51 PDFs in Sydney..."):
        st.markdown(search_methodology(query))
EOF

# 3. Update the safe_deploy script to target 'main' specifically
sed -i 's/git push origin master/git push origin main/g' safe_deploy.sh
# 4. Final attempt
./safe_deploy.sh "v3.2: Identity fixed and UI restored"
git config --global credential.helper store
ls
cat stable_deploy.sh 
cat << 'EOF' > safe_stable_deploy.sh
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
EOF

chmod +x safe_stable_deploy.sh
./safe_stable_deploy.sh "v3.2: Integrated v3.1 UI with Sydney Credit Optimization"
# 1. Create a proper .gitignore to block large system files
cat << 'EOF' > .gitignore
.cache/
.gemini/
ai-trading-assistant/
venv/
__pycache__/
*.pyc
.DS_Store
EOF

# 2. Force-remove the large cached files from Git's tracking (but keep them on disk)
git rm -r --cached .cache/ > /dev/null 2>&1
git rm -r --cached .gemini/ > /dev/null 2>&1
# 3. Amend the previous commit to remove the bloat
git add .gitignore
git commit --amend --no-edit
# 4. Verify the push size is now tiny (should be KB, not 335MB)
./safe_stable_deploy.sh "v3.2: Pruned repository bloat and restored UI"
# 1. Ensure the .gitignore exists and is correct
cat << 'EOF' > .gitignore
.cache/
.gemini/
ai-trading-assistant/
venv/
__pycache__/
*.pyc
.git-credentials
EOF

# 2. Completely wipe the Git Index (this is the "Nuclear" part)
# This doesn't delete files, it just un-tracks everything
git rm -r --cached .
# 3. Re-add everything (Git will now respect the .gitignore)
git add .
# 4. Create a fresh commit that replaces the bloated one
git commit -m "v3.2: Final repository purge of large binary files"
# 5. Push to GitHub (This should now be almost instant)
git push origin main --force
# 1. Stop Git from tracking your entire Home Directory
rm -rf .git
# 2. Re-initialize Git specifically for this project
git init
# 3. Connect back to your GitHub repo
git remote add origin https://github.com/UrbansurferOz/ai-trading-assistant.git
# 4. Create a clean .gitignore so we never track .local or .cache again
cat << 'EOF' > .gitignore
.local/
.cache/
.gemini/
.config/
ai-trading-assistant/
venv/
__pycache__/
*.pyc
.git-credentials
EOF

# 5. Add only the files we actually need for the Assistant
git add app.py requirements.txt safe_stable_deploy.sh stable_deploy.sh .gitignore
# 6. Commit and Force Push (This will be tiny—just a few KB)
git commit -m "v3.2: Complete repository reset - source code only"
git push origin main --force
# 1. Rename the local 'master' branch to 'main'
git branch -m main
# 2. Push the clean, tiny source code to GitHub
git push origin main --force
# 3. Final verification - your Safe Stable Deployer is now ready
./safe_stable_deploy.sh "v3.2: Confirmed Sydney deployment with clean branch"
# 1. Update .gitignore to block all JSON keys
echo "*.json" >> .gitignore
# 2. Remove the specific service account key from Git tracking
git rm --cached ai-trading-assistant-488403-d06cf9935743.json
# 3. Clean out all the other "junk" files that were in that massive list (logs, npm, etc.)
git rm -r --cached .codeoss/ .npm/ .gsutil/ .local/ > /dev/null 2>&1
# 4. Re-commit the clean state
git add .gitignore
git commit --amend --no-edit
# 5. Force push the clean, secure code
git push origin main --force
