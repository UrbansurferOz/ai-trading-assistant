import streamlit as st
from google.cloud import discoveryengine_v1beta as discoveryengine
from PIL import Image

st.set_page_config(page_title="TBD Command Center v3.4", layout="wide")

with st.sidebar:
    st.title("📁 TBD Analysis Tools")
    uploaded_file = st.file_uploader("Upload Chart", type=['png', 'jpg', 'jpeg']) 
    if uploaded_file:
        st.image(Image.open(uploaded_file), use_container_width=True)
    st.divider()
    st.info("System: Sydney Enterprise Engine")
    st.caption("Credit: GenAI App Builder ($1,500)")

st.title("📈 TBD Methodology Assistant")

def search_methodology(query):
    try:
        client = discoveryengine.SearchServiceClient()
        serving_config = f"projects/ai-trading-assistant-488403/locations/global/collections/default_collection/engines/tbd-trading-engine/servingConfigs/default_search"
        
        content_search_spec = discoveryengine.SearchRequest.ContentSearchSpec(
            summary_spec=discoveryengine.SearchRequest.ContentSearchSpec.SummarySpec(
                summary_result_count=5,
                include_citations=True
            ),
            extractive_content_spec=discoveryengine.SearchRequest.ContentSearchSpec.ExtractiveContentSpec(
                max_extractive_answer_count=3
            )
        )

        request = discoveryengine.SearchRequest(
            serving_config=serving_config,
            query=query,
            content_search_spec=content_search_spec,
            page_size=3
        )
        
        response = client.search(request)
        
        # Priority 1: High-level Summary
        if response.summary and response.summary.summary_text:
            return response.summary.summary_text
            
        # Priority 2: Extractive Snippets (Fallback)
        snippets = []
        for result in response.results:
            derived = result.document.derived_struct_data
            if "extractive_answers" in derived:
                for ans in derived["extractive_answers"]:
                    snippets.append(ans.get("content", ""))
        
        if snippets:
            return "### Key Snippets Found\n\n" + "\n\n---\n\n".join(snippets)

        return "🔍 The engine is active but found no matches for that specific phrase. Try 'M Formation' or 'Vector'."

    except Exception as e:
        return f"📡 Connection Error: {str(e)}"

query = st.text_input("Ask about your TBD Methodology:")
if query:
    with st.spinner("Querying Sydney Data Store..."):
        st.markdown(search_methodology(query))

st.caption("v3.4 - Recovery Branch - Identity Verified")
