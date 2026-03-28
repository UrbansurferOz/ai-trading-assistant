import streamlit as st
from google.cloud import discoveryengine_v1beta as discoveryengine
import vertexai
from vertexai.generative_models import GenerativeModel, Part, Image as VertexImage
import io

# Initialize Vertex AI
PROJECT_ID = "ai-trading-assistant-488403"
vertexai.init(project=PROJECT_ID, location="us-central1")

st.set_page_config(page_title="TBD Command Center v3.5", layout="wide")

with st.sidebar:
    st.title("📁 TBD Analysis Tools")
    uploaded_file = st.file_uploader("Upload Chart (BTC/SOL/ETH)", type=['png', 'jpg', 'jpeg']) 
    if uploaded_file:
        st.image(uploaded_file, caption="Target Chart", use_container_width=True)
    st.divider()
    st.info("System: Sydney Search + Vertex Vision")
    st.caption("Credit: GenAI App Builder ($1,500)")

st.title("📈 TBD Methodology Assistant")

def get_tbd_context(query):
    """Fetches the rules from your 51 PDFs."""
    client = discoveryengine.SearchServiceClient()
    serving_config = f"projects/{PROJECT_ID}/locations/global/collections/default_collection/engines/tbd-trading-engine/servingConfigs/default_search"
    
    content_search_spec = discoveryengine.SearchRequest.ContentSearchSpec(
        summary_spec=discoveryengine.SearchRequest.ContentSearchSpec.SummarySpec(summary_result_count=5)
    )
    request = discoveryengine.SearchRequest(serving_config=serving_config, query=query, content_search_spec=content_search_spec)
    response = client.search(request)
    return response.summary.summary_text if response.summary.summary_text else ""

def analyze_with_vision(query, uploaded_file, tbd_context):
    """Uses Gemini to look at the chart and apply TBD rules."""
    model = GenerativeModel("gemini-1.5-pro")
    
    # Convert Streamlit file to Vertex Part
    img_bytes = uploaded_file.getvalue()
    image_part = Part.from_data(data=img_bytes, mime_type=uploaded_file.type)
    
    prompt = f"""
    You are Steve, an expert Crypto Trader using the 'Trade by Design' methodology.
    
    CONTEXT FROM TBD MANUALS:
    {tbd_context}
    
    USER QUESTION: {query}
    
    INSTRUCTION: Look at the uploaded chart and answer the user's question specifically 
    using the TBD methodology provided in the context. If the chart shows an M or W 
    formation or 200 EMA alignment, point it out.
    """
    
    response = model.generate_content([prompt, image_part])
    return response.text

query = st.text_input("Ask about the chart or TBD rules:")

if query:
    with st.spinner("Analyzing with TBD Intelligence..."):
        # Step 1: Get the rules from the PDFs
        tbd_rules = get_tbd_context(query)
        
        if uploaded_file:
            # Step 2: Use Vision if a file is uploaded
            analysis = analyze_with_vision(query, uploaded_file, tbd_rules)
            st.markdown("### 👁️ Chart Analysis")
            st.write(analysis)
        else:
            # Step 3: Text-only fallback
            st.markdown("### 📝 Methodology Insight")
            st.write(tbd_rules if tbd_rules else "No specific rules found. Try 'W Pattern'.")

st.caption("v3.5 - Vision Integrated - Sydney/US-Central")
