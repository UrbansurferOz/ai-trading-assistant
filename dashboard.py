import streamlit as st
from google import genai
from google.genai import types
import PIL.Image
import sys

# 1. Initialize Client
PROJECT_ID = "ai-trading-assistant-488403"
client = genai.Client(vertexai=True, project=PROJECT_ID, location="us-central1")

st.set_page_config(page_title="TBD AI Trading Assistant", layout="wide")
st.write("# 📈 TBD AI Trading Assistant (v3.1 Stable)")

with st.sidebar:
    st.header("⚙️ Project Config")
    st.write(f"**Project:** {PROJECT_ID}")
    st.divider()
    st.header("📁 Upload Trade Data")
    uploaded_file = st.file_uploader("Upload Chart Screenshot:", type=["png", "jpg", "jpeg"])
    if uploaded_file:
        st.image(PIL.Image.open(uploaded_file), width="stretch")

st.divider()

with st.form("tbd_analysis_form"):
    user_input = st.text_input("Analysis Request:", placeholder="Predict BTC movement for next 12h...")
    submit_button = st.form_submit_button("🚀 Run TBD Analysis")

if submit_button and user_input:
    print(f"\n>>> [SIGNAL RECEIVED] User requested analysis: {user_input}", file=sys.stderr)
    
    with st.status("🤖 AI Engine Engaging...", expanded=True) as status:
        try:
            # 2. Prepare Multimodal Content
            contents = [user_input]
            if uploaded_file:
                st.write("📸 Processing chart screenshot...")
                img = PIL.Image.open(uploaded_file)
                contents.append(img)

            st.write("🧠 Generating TBD Prediction (Stable 2.5 Pro)...")
            print(">>> [SENDING TO VERTEX STABLE]", file=sys.stderr)
            
            # --- STABLE 2026 PRODUCTION MODEL ---
            response_stream = client.models.generate_content_stream(
                model='gemini-2.5-pro',
                contents=contents,
                config=types.GenerateContentConfig(
                    system_instruction="You are an expert TBD trader. Reference the 51 PDF methodology files in the Sydney bucket context."
                )
            )
            
            st.subheader("📊 Agent Recommendation")
            def stream_output():
                for chunk in response_stream:
                    if chunk.text:
                        print(".", end="", file=sys.stderr, flush=True)
                        yield chunk.text

            st.write_stream(stream_output())
            status.update(label="✅ Analysis Complete!", state="complete")
            
        except Exception as e:
            # Automatic Fallback to Flash if Pro is restricted
            if "404" in str(e):
                st.warning("⚠️ High-tier model restricted. Falling back to 2.5 Flash...")
                try:
                    response_stream = client.models.generate_content_stream(
                        model='gemini-2.5-flash',
                        contents=contents
                    )
                    st.write_stream(chunk.text for chunk in response_stream if chunk.text)
                    status.update(label="✅ Analysis Complete (via Flash)", state="complete")
                except Exception as flash_e:
                    st.error(f"❌ Connection Error: {str(flash_e)}")
            else:
                st.error(f"❌ Connection Error: {str(e)}")
                status.update(label="❌ Failed", state="error")
