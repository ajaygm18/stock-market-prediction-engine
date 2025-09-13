#!/bin/bash
echo "🔧 Starting Development Mode..."
export PYTHONPATH=$(pwd)

# Function to cleanup background processes
cleanup() {
    echo "🛑 Stopping development services..."
    kill $(jobs -p) 2>/dev/null
    exit 0
}

trap cleanup SIGINT SIGTERM

# Start API with hot reload
uvicorn src.api_server:app --host 0.0.0.0 --port 8000 --reload &

# Start Streamlit with watching
streamlit run src/streamlit_dashboard.py --server.port 8501 --server.address 0.0.0.0 &

echo ""
echo "🔥 Development servers running with hot reload!"
echo "📱 API: http://localhost:8000/docs"
echo "📊 Dashboard: http://localhost:8501"
echo ""
echo "Press Ctrl+C to stop all services"

wait
