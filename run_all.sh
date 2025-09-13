#!/bin/bash
echo "🚀 Starting All Services..."
echo "API Server: http://localhost:8000"
echo "Dashboard: http://localhost:8501"
echo ""

# Function to cleanup background processes
cleanup() {
    echo "🛑 Stopping services..."
    kill $API_PID $DASHBOARD_PID 2>/dev/null
    exit 0
}

# Set trap to cleanup on script exit
trap cleanup SIGINT SIGTERM

export PYTHONPATH=$(pwd)

# Start API server in background
echo "Starting API server..."
uvicorn src.api_server:app --host 0.0.0.0 --port 8000 &
API_PID=$!

# Wait a moment for API to start
sleep 3

# Start dashboard in background
echo "Starting dashboard..."
streamlit run src/streamlit_dashboard.py --server.port 8501 --server.address 0.0.0.0 &
DASHBOARD_PID=$!

echo ""
echo "✅ Services started successfully!"
echo "📱 API Documentation: http://localhost:8000/docs"
echo "📊 Dashboard: http://localhost:8501"
echo ""
echo "Press Ctrl+C to stop all services"

# Wait for background processes
wait
