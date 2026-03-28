# TBD AI Trading Assistant (v3.1 Stable)

**Lead:** Steve White, Engagement Lead (Cognizant)  
**Methodology:** Trade by Design (TBD) - 51 PDF Core Library  
**Engine:** Vertex AI Gemini 2.5 Pro (2026 Stable)

## 🏗️ Architecture
- **UI:** Streamlit on Port 8080.
- **Backend:** Google Gen AI SDK (v3.0+).
- **Storage:** Google Cloud Storage (Sydney Region) `gs://tbd-docs-sydney-ai-trading-assistant-488403`.
- **Identity:** `steve-service-account` with Object Admin & Vertex User roles.

## 🚀 Operations
- **Start:** `~/ai-trading-assistant/start_trading_agent.sh`
- **Stop:** `~/ai-trading-assistant/stop_trading_agent.sh`
- **Identity Check:** Script includes IAM Pre-Flight to prevent 403/404 errors.

## 📊 Features
- **Multimodal Analysis:** Upload chart screenshots for TBD rule correlation.
- **Fibonacci Exhaustion:** Gemini 2.5 Pro reasons across the 51-file methodology.
- **Streaming UI:** Real-time token generation for low-latency trade signals.

---
*Maintained by Steve White. Confidential - Proprietary Trading Methodology.*
