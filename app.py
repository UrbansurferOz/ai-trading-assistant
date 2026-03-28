import streamlit as st
from google.cloud import discoveryengine_v1beta as discoveryengine
import vertexai
from vertexai.generative_models import GenerativeModel, Part
import io

# Config - Using the confirmed Project ID
PROJECT_ID = "ai-trading-assistant-488403"
LOCATION = "us-central1"

try:
    vertexai.init(project=PROJECT_ID, location=LOCATION)
except Exception as e:
    st.error(f"Vertex AI Init Failed: {e}")

st.set_page_config(page_title="TBD Command Center v3.6", layout="wide")

with st.sidebar:
    st.title("📁 TBD Analysis Tools")
    st.markdown("---")
    uploaded_file = st.file_uploader("Upload Chart (BTC/SOL/ETH)", type=['png', 'jpg', 'jpeg']) 
    if uploaded_file:
        st.image(uploaded_file, use_container_width=True)
    st.divider()
    st.info("System: Sydney Search + Vertex Vision")
    st.caption("Status: v3.6 Baseline")

st.title("📈 TBD Methodology Assistant")

def get_tbd_rules(query):
    """Hits the Discovery Engine for PDF methodology."""
    try:
        client = discoveryengine.SearchServiceClient()
        serving_config = f"projects/{PROJECT_ID}/locations/global/collections/default_collection/engines/tbd-trading-engine/servingConfigs/default_search"
        
        content_search_spec = discoveryengine.SearchRequest.ContentSearchSpec(
            summary_spec=discoveryengine.SearchRequest.ContentSearchSpec.SummarySpec(summary_result_count=5)
        )
        request = discoveryengine.SearchRequest(serving_config=serving_config, query=query, content_search_spec=content_search_spec)
        response = client.search(request)
        return response.summary.summary_text if response.summary.summary_text else ""
    except:
        return ""

def analyze_with_vision(query, file, rules):
    """Gemini looks at the screenshot and applies the TBD rules."""
    try:
        # Using a specific model version to avoid the 404
        model = GenerativeModel("gemini-1.5-flash-002")
        img_part = Part.from_data(data=file.getvalue(), mime_type=file.type)
        
        full_prompt = f"""
        Context from TBD Methodology Manuals:
        {rules}
        
        User Question: {query}
        
        As Steve (Expert Crypto Trader), analyze this chart. 
        Focus on W/M patterns, 200 EMA, and TBD rules. 
        If the data store found no rules, use your knowledge of 'Trade by Design'.
        """
        response = model.generate_content([full_prompt, img_part])
        return response.text
    except Exception as e:
        return f"🚨 Vision API Error: {str(e)}"

query = st.text_input("Ask about the chart or TBD rules:")

if query:
    with st.spinner("Analyzing Sydney Data Store & Image..."):
        rules_context = get_tbd_rules(query)
        
        if uploaded_file:
            analysis = analyze_with_vision(query, uploaded_file, rules_context)
            st.markdown("### 👁️ Chart Analysis")
            st.write(analysis)
        else:
            st.markdown("### 📝 Methodology Insight")
            st.write(rules_context if rules_context else "No specific rules found. Try 'W Pattern'.")

st.divider()
st.caption("Credit: GenAI App Builder ($1,500 Trial)")
