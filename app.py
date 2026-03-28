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
