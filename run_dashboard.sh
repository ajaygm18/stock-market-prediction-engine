#!/bin/bash
echo "📊 Starting Streamlit Dashboard on http://localhost:8501"
export PYTHONPATH=$(pwd)
streamlit run src/streamlit_dashboard.py --server.port 8501 --server.address 0.0.0.0
