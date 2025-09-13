#!/bin/bash
echo "🚀 Starting FastAPI Server on http://localhost:8000"
echo "📚 API Documentation: http://localhost:8000/docs"
export PYTHONPATH=$(pwd)
uvicorn src.api_server:app --host 0.0.0.0 --port 8000 --reload
