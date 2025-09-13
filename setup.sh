#!/bin/bash

# Stock Market Prediction Engine - Setup Script
# This script sets up the environment to run without Docker

set -e

echo "🚀 Stock Market Prediction Engine - Setup Script"
echo "================================================="

# Check Python version
python_version=$(python3 --version 2>&1 | grep -oP '\d+\.\d+' || echo "")
required_version="3.11"

if [ -z "$python_version" ]; then
    echo "❌ Python 3 not found. Please install Python 3.11 or higher."
    exit 1
fi

# Compare versions (basic comparison for major.minor)
if [[ "$python_version" < "$required_version" ]]; then
    echo "⚠️  Python $python_version detected. Python $required_version+ recommended."
    echo "   Continuing anyway, but some features may not work optimally."
else
    echo "✅ Python $python_version detected"
fi

# Check if we're in a virtual environment
if [[ "$VIRTUAL_ENV" != "" ]]; then
    echo "✅ Virtual environment detected: $VIRTUAL_ENV"
else
    echo "⚠️  No virtual environment detected."
    echo "   It's recommended to use a virtual environment:"
    echo "   python3 -m venv venv"
    echo "   source venv/bin/activate  # Linux/Mac"
    echo "   # or venv\\Scripts\\activate on Windows"
    echo ""
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Setup cancelled."
        exit 1
    fi
fi

# Install requirements
echo ""
echo "📦 Installing Python dependencies..."
pip install -r requirements.txt

# Create necessary directories
echo ""
echo "📁 Creating necessary directories..."
mkdir -p data/processed data/features models/ensemble models/advanced logs plots

# Check for essential files and create placeholders if needed
echo ""
echo "🔧 Setting up configuration..."

# Create target stocks file if it doesn't exist
if [ ! -f "data/processed/target_stocks.txt" ]; then
    echo "Creating target_stocks.txt with default stocks..."
    cat > data/processed/target_stocks.txt << EOF
AAPL
AMZN
GOOGL
MSFT
TSLA
NVDA
META
NFLX
ADBE
CRM
EOF
fi

# Create sample features file if it doesn't exist
if [ ! -f "data/features/selected_features.csv" ]; then
    echo "Creating placeholder selected_features.csv..."
    cat > data/features/selected_features.csv << EOF
feature,importance
sma_10,0.85
sma_20,0.82
rsi_14,0.78
macd,0.75
volume_sma_ratio,0.72
price_change_1d,0.70
bollinger_upper,0.68
bollinger_lower,0.67
ema_12,0.65
momentum_10,0.63
EOF
fi

# Create basic feature list
if [ ! -f "data/features/selected_features_list.txt" ]; then
    echo "Creating feature list..."
    cat > data/features/selected_features_list.txt << EOF
sma_10
sma_20
rsi_14
macd
volume_sma_ratio
price_change_1d
bollinger_upper
bollinger_lower
ema_12
momentum_10
EOF
fi

# Set up environment variables
echo ""
echo "🌍 Setting up environment..."
if [ ! -f ".env" ]; then
    cat > .env << EOF
# Stock Market Prediction Engine Environment
PYTHONPATH=$(pwd)
KAGGLE_USERNAME=your_kaggle_username
KAGGLE_KEY=your_kaggle_key
LOG_LEVEL=INFO
API_PORT=8000
DASHBOARD_PORT=8501
EOF
    echo "Created .env file - please update with your Kaggle credentials if needed"
fi

# Create run scripts
echo ""
echo "🏃 Creating run scripts..."

# Main application runner
cat > run_main.sh << 'EOF'
#!/bin/bash
echo "🤖 Starting Stock Market Prediction Engine - Main Application"
export PYTHONPATH=$(pwd)
python main.py
EOF
chmod +x run_main.sh

# API server runner
cat > run_api.sh << 'EOF'
#!/bin/bash
echo "🚀 Starting FastAPI Server on http://localhost:8000"
echo "📚 API Documentation: http://localhost:8000/docs"
export PYTHONPATH=$(pwd)
uvicorn src.api_server:app --host 0.0.0.0 --port 8000 --reload
EOF
chmod +x run_api.sh

# Dashboard runner
cat > run_dashboard.sh << 'EOF'
#!/bin/bash
echo "📊 Starting Streamlit Dashboard on http://localhost:8501"
export PYTHONPATH=$(pwd)
streamlit run src/streamlit_dashboard.py --server.port 8501 --server.address 0.0.0.0
EOF
chmod +x run_dashboard.sh

# Combined runner (API + Dashboard)
cat > run_all.sh << 'EOF'
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
EOF
chmod +x run_all.sh

# Development mode runner (with auto-reload)
cat > run_dev.sh << 'EOF'
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
EOF
chmod +x run_dev.sh

# Jupyter notebook runner
cat > run_jupyter.sh << 'EOF'
#!/bin/bash
echo "📓 Starting Jupyter Notebook for development"
export PYTHONPATH=$(pwd)
jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root
EOF
chmod +x run_jupyter.sh

echo ""
echo "🎉 Setup Complete!"
echo "====================="
echo ""
echo "Available commands:"
echo "• ./run_main.sh        - Run main prediction engine"
echo "• ./run_api.sh         - Run FastAPI server only"
echo "• ./run_dashboard.sh   - Run Streamlit dashboard only"
echo "• ./run_all.sh         - Run both API and dashboard"
echo "• ./run_dev.sh         - Development mode with hot reload"
echo "• ./run_jupyter.sh     - Start Jupyter notebook"
echo ""
echo "Quick Start:"
echo "1. For full experience: ./run_all.sh"
echo "2. For API only: ./run_api.sh"
echo "3. For dashboard only: ./run_dashboard.sh"
echo ""
echo "📝 Note: Some features may require model files to be generated."
echo "   Run './run_main.sh' first to initialize the system."
echo ""
echo "🔗 Documentation:"
echo "   • API Docs: http://localhost:8000/docs (after running API)"
echo "   • Dashboard: http://localhost:8501 (after running dashboard)"