#!/bin/bash
echo "📓 Starting Jupyter Notebook for development"
export PYTHONPATH=$(pwd)
jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root
