import streamlit as st
from google.cloud import discoveryengine_v1beta as discoveryengine
import vertexai
from vertexai.generative_models import GenerativeModel, Part
import io

# Config
PROJECT_ID = "ai-trading-assistant-488403"
LOCATION = "us-central1"
vertexai.init(project=PROJECT_ID, location=LOCATION)

st.set_page_config(page_title="TBD Command Center v3.5", layout="wide")

with st.sidebar:
    st.title("📁 TBD Analysis Tools")
    st.markdown("---")
    uploaded_file = st.file_uploader("Upload Chart (BTC/SOL/ETH)", type=['png', 'jpg', 'jpeg']) 
    if uploaded_file:
        st.image(uploaded_file, use_container_width=True)
    st.divider()
    st.info("System: Sydney Search + Vertex Vision")
    st.caption("Credit: GenAI App Builder ($1,500)")

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
    model = GenerativeModel("gemini-1.5-flash")
    img_part = Part.from_data(data=file.getvalue(), mime_type=file.type)
    
    full_prompt = f"""
    Context from TBD Methodology Manuals:
    {rules}
    
    User Question: {query}
    
    As Steve (Crypto Trader), analyze the attached chart. 
    Identify if there are W/M patterns, 200 EMA alignments, or 3-hits to high/low 
    based on the provided context rules. Be direct and concise.
    """
    response = model.generate_content([full_prompt, img_part])
    return response.text

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
st.caption("v3.5 - Vision Integrated - Sydney/US-Central")
