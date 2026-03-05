#!/bin/bash
echo "🛑 Shutting down TBD Trading Agent..."

# 1. Kill process on port 8080
fuser -k 8080/tcp 2>/dev/null

# 2. Kill any remaining streamlit processes
pkill -9 streamlit 2>/dev/null

# 3. Verification
STILL_RUNNING=$(ps aux | grep streamlit | grep -v grep)

if [ -z "$STILL_RUNNING" ]; then
    echo "✅ Agent stopped successfully. Port 8080 is now free."
else
    echo "⚠️ Warning: Some processes are still visible."
    echo "$STILL_RUNNING"
fi
