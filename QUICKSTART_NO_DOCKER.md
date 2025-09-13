# 🚀 Quick Start Guide - Running Without Docker

This guide will help you run the Stock Market Prediction Engine natively on your system without Docker.

## 📋 Prerequisites

- **Python 3.11+** (Python 3.12 recommended)
- **4GB+ RAM** for ML model loading
- **Available ports**: 8000 (API), 8501 (Dashboard), 8888 (Jupyter)
- **Internet connection** for downloading stock data

## ⚡ One-Command Setup

```bash
# Clone the repository
git clone https://github.com/ajaygm18/stock-market-prediction-engine.git
cd stock-market-prediction-engine

# Run automated setup (installs dependencies, creates directories, run scripts)
./setup.sh

# Initialize demonstration models
python init_models.py
```

## 🎯 Usage Options

### 1. Full Experience (Recommended)
```bash
./run_all.sh
```
This starts both the API server and dashboard simultaneously:
- **API Server**: http://localhost:8000/docs
- **Dashboard**: http://localhost:8501

### 2. Individual Components

#### API Server Only
```bash
./run_api.sh
```
- **URL**: http://localhost:8000
- **Documentation**: http://localhost:8000/docs
- **Features**: REST API with ML predictions, portfolio optimization, risk analysis

#### Dashboard Only
```bash
./run_dashboard.sh
```
- **URL**: http://localhost:8501
- **Features**: Interactive web interface, real-time predictions, visualizations

#### Main Prediction Engine
```bash
./run_main.sh
```
- **Purpose**: Runs the core ML pipeline, integration tests, system analysis
- **Output**: Terminal-based reports and analysis

### 3. Development Mode
```bash
./run_dev.sh
```
- **Features**: Hot reload for both API and dashboard
- **Use case**: Active development and debugging

### 4. Jupyter Notebooks
```bash
./run_jupyter.sh
```
- **URL**: http://localhost:8888
- **Purpose**: Interactive development, data analysis, model experimentation

## 📁 Project Structure

```
stock-market-prediction-engine/
├── src/                    # Source code
│   ├── api_server.py      # FastAPI REST API
│   ├── streamlit_dashboard.py  # Web dashboard
│   ├── realtime_prediction.py # ML prediction engine
│   └── ...                # Other components
├── data/                  # Data files
├── models/                # ML models
├── requirements.txt       # Python dependencies
├── setup.sh              # Setup script
├── init_models.py         # Model initialization
├── run_*.sh              # Run scripts
└── README.md             # This file
```

## 🔧 Manual Setup (Alternative)

If the automated setup doesn't work, follow these manual steps:

```bash
# 1. Install Python dependencies
pip install -r requirements.txt

# 2. Create necessary directories
mkdir -p data/processed data/features models/ensemble models/advanced logs plots

# 3. Set environment variable
export PYTHONPATH=$(pwd)

# 4. Initialize models
python init_models.py

# 5. Run components manually
# API Server:
uvicorn src.api_server:app --host 0.0.0.0 --port 8000 --reload

# Dashboard:
streamlit run src/streamlit_dashboard.py --server.port 8501 --server.address 0.0.0.0
```

## 🐛 Troubleshooting

### Common Issues and Solutions

#### 1. "Module not found" errors
```bash
export PYTHONPATH=$(pwd)
# Or add to your shell profile (.bashrc, .zshrc)
```

#### 2. Permission denied on scripts
```bash
chmod +x *.sh
```

#### 3. Port already in use
```bash
# Check what's using the port
lsof -i :8000
lsof -i :8501

# Kill the process
kill -9 <PID>
```

#### 4. Missing models error
```bash
# Reinitialize models
python init_models.py
```

#### 5. Python version issues
- Ensure Python 3.11+ is installed
- Consider using a virtual environment:
```bash
python3 -m venv venv
source venv/bin/activate  # Linux/Mac
# or venv\Scripts\activate  # Windows
```

## 🎯 Feature Overview

### API Server Features (`./run_api.sh`)
- **Stock Predictions**: `/predict` endpoint for multi-stock predictions
- **Portfolio Optimization**: `/portfolio/optimize` for portfolio construction
- **Risk Management**: `/risk/analysis` for risk metrics
- **Model Performance**: `/models/performance` for model statistics
- **Health Monitoring**: `/health` for system status

### Dashboard Features (`./run_dashboard.sh`)
- **Live Predictions**: Real-time stock analysis with confidence scoring
- **Portfolio Optimizer**: Interactive portfolio construction tools
- **Performance Analytics**: Historical model performance tracking
- **Risk Center**: Comprehensive risk management dashboard
- **Model Insights**: Feature importance and model explanations

### Main Engine Features (`./run_main.sh`)
- **System Integration Testing**: Comprehensive system validation
- **Performance Benchmarking**: Model performance analysis
- **Data Pipeline Testing**: Data integrity and feature engineering validation
- **Health Monitoring**: System status and recommendations

## 🔗 URLs and Endpoints

| Service | URL | Description |
|---------|-----|-------------|
| API Server | http://localhost:8000 | Main API endpoint |
| API Docs | http://localhost:8000/docs | Interactive API documentation |
| Dashboard | http://localhost:8501 | Web-based dashboard |
| Jupyter | http://localhost:8888 | Development notebooks |

## 📊 Sample API Usage

```python
import requests

# Get stock predictions
response = requests.post(
    "http://localhost:8000/predict",
    json={"symbols": ["AAPL", "AMZN", "NVDA"]}
)
predictions = response.json()

# Get system health
health = requests.get("http://localhost:8000/health")
print(health.json())
```

## 🔄 Stopping Services

- **Individual components**: Press `Ctrl+C` in the terminal
- **Background services**: Use the stop scripts or kill processes:
```bash
# Find processes
ps aux | grep uvicorn
ps aux | grep streamlit

# Kill specific processes
pkill -f uvicorn
pkill -f streamlit
```

## 📈 Next Steps

1. **Explore the API**: Visit http://localhost:8000/docs
2. **Use the Dashboard**: Open http://localhost:8501
3. **Customize Models**: Edit `init_models.py` for your specific needs
4. **Add Real Data**: Replace sample data with actual market data
5. **Deploy to Production**: Use the Docker setup for production deployment

## 🤝 Support

If you encounter issues:
1. Check the troubleshooting section above
2. Ensure all prerequisites are met
3. Try the manual setup process
4. Check the logs for detailed error messages

## 📝 Notes

- **Sample Models**: The `init_models.py` script creates demonstration models with synthetic data
- **Real Data**: For production use, replace with models trained on real historical market data
- **Performance**: First startup may take longer due to model loading
- **Resources**: Monitor system resources; ML models can be memory-intensive