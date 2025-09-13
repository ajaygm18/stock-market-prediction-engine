#!/usr/bin/env python3
"""
Stock Market Prediction Engine - Model Initialization Script
Creates basic/placeholder models for demonstration purposes when real models are not available.
"""

import os
import sys
import joblib
import numpy as np
import pandas as pd
from pathlib import Path
from sklearn.ensemble import RandomForestRegressor
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
import warnings
warnings.filterwarnings('ignore')

# Add project root to path
project_root = Path(__file__).parent
sys.path.append(str(project_root))

from src.config import Config

def create_sample_data():
    """Create sample stock data for training"""
    print("📊 Creating sample stock data...")
    
    # Create sample features (basic technical indicators)
    np.random.seed(42)
    n_samples = 1000
    
    # Price-based features
    prices = 100 + np.cumsum(np.random.randn(n_samples) * 0.02)
    
    data = {
        'close': prices,
        'sma_10': np.convolve(prices, np.ones(10)/10, mode='valid'),
        'sma_20': np.convolve(prices, np.ones(20)/20, mode='valid'),
        'rsi_14': 50 + np.random.randn(n_samples-19) * 10,  # RSI between 30-70 roughly
        'macd': np.random.randn(n_samples-19) * 0.5,
        'volume_sma_ratio': 1 + np.random.randn(n_samples-19) * 0.2,
        'price_change_1d': np.diff(prices, prepend=prices[0]),
        'bollinger_upper': None,
        'bollinger_lower': None,
        'ema_12': None,
        'momentum_10': np.random.randn(n_samples-19) * 2,
    }
    
    # Trim to consistent length
    min_length = min(len(v) for v in data.values() if v is not None)
    for key in data:
        if data[key] is not None:
            data[key] = data[key][:min_length]
        else:
            data[key] = np.random.randn(min_length)
    
    # Create DataFrame
    df = pd.DataFrame(data)
    
    # Create target variable (next day return)
    df['target'] = df['close'].pct_change().shift(-1).fillna(0)
    
    return df.dropna()

def create_basic_models():
    """Create basic models for demonstration"""
    print("🤖 Creating basic ML models...")
    
    config = Config()
    
    # Ensure model directories exist
    models_dir = config.PROJECT_ROOT / "models"
    ensemble_dir = models_dir / "ensemble"
    advanced_dir = models_dir / "advanced"
    
    models_dir.mkdir(exist_ok=True)
    ensemble_dir.mkdir(exist_ok=True)
    advanced_dir.mkdir(exist_ok=True)
    
    # Create sample data
    df = create_sample_data()
    
    # Prepare features and target
    feature_columns = [col for col in df.columns if col != 'target']
    X = df[feature_columns]
    y = df['target']
    
    # Split data
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    
    # Create and train scaler
    print("📏 Creating feature scaler...")
    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)
    
    # Save scaler
    joblib.dump(scaler, models_dir / "feature_scaler.joblib")
    print(f"✅ Saved feature scaler")
    
    # Create basic random forest model
    print("🌲 Training Random Forest model...")
    rf_model = RandomForestRegressor(n_estimators=50, random_state=42)
    rf_model.fit(X_train, y_train)
    
    # Save random forest
    joblib.dump(rf_model, models_dir / "regression_random_forest.joblib")
    print(f"✅ Saved Random Forest model")
    
    # Create ensemble models (simplified versions)
    print("🎭 Creating ensemble models...")
    
    # Model 1: Another Random Forest with different params
    rf_1 = RandomForestRegressor(n_estimators=30, max_depth=10, random_state=42)
    rf_1.fit(X_train_scaled, y_train)
    joblib.dump(rf_1, ensemble_dir / "model_random_forest.joblib")
    
    # Model 2: Random Forest with different params (simulating XGBoost)
    rf_2 = RandomForestRegressor(n_estimators=40, max_depth=8, random_state=123)
    rf_2.fit(X_train_scaled, y_train)
    joblib.dump(rf_2, ensemble_dir / "model_xgboost.joblib")
    
    # Model 3: Another Random Forest (simulating LightGBM)
    rf_3 = RandomForestRegressor(n_estimators=35, max_depth=12, random_state=456)
    rf_3.fit(X_train_scaled, y_train)
    joblib.dump(rf_3, ensemble_dir / "model_lightgbm.joblib")
    
    print(f"✅ Saved 3 ensemble models")
    
    # Create advanced models
    print("🧠 Creating advanced models...")
    
    # Advanced model 1
    advanced_1 = RandomForestRegressor(n_estimators=60, max_features='sqrt', random_state=789)
    advanced_1.fit(X_train_scaled, y_train)
    joblib.dump(advanced_1, advanced_dir / "advanced_ensemble.joblib")
    
    # Advanced model 2
    advanced_2 = RandomForestRegressor(n_estimators=45, max_depth=15, random_state=101)
    advanced_2.fit(X_train_scaled, y_train)
    joblib.dump(advanced_2, advanced_dir / "neural_network.joblib")
    
    print(f"✅ Saved 2 advanced models")
    
    # Save feature names for later use
    feature_names_file = config.DATA_PATH / "features" / "model_ready_features.txt"
    with open(feature_names_file, 'w') as f:
        for feature in feature_columns:
            f.write(f"{feature}\n")
    
    print(f"✅ Saved feature names to {feature_names_file}")
    
    # Create a simple validation summary
    validation_summary = {
        'model_count': 5,
        'feature_count': len(feature_columns),
        'training_samples': len(X_train),
        'test_samples': len(X_test),
        'models': [
            'regression_random_forest.joblib',
            'model_random_forest.joblib',
            'model_xgboost.joblib', 
            'model_lightgbm.joblib',
            'advanced_ensemble.joblib',
            'neural_network.joblib'
        ]
    }
    
    validation_file = config.PROCESSED_DATA_PATH / "day10_validation_summary.csv"
    validation_df = pd.DataFrame([validation_summary])
    validation_df.to_csv(validation_file, index=False)
    
    print(f"✅ Created validation summary")
    
    return feature_columns, len(X_train)

def create_risk_summary():
    """Create a basic risk analysis summary"""
    print("📊 Creating risk analysis summary...")
    
    config = Config()
    
    # Create sample risk data
    risk_data = {
        'metric': ['VaR_95', 'VaR_99', 'CVaR_95', 'max_drawdown', 'sharpe_ratio'],
        'value': [0.05, 0.08, 0.07, 0.15, 2.1],
        'status': ['ACCEPTABLE', 'ACCEPTABLE', 'ACCEPTABLE', 'GOOD', 'EXCELLENT']
    }
    
    risk_df = pd.DataFrame(risk_data)
    risk_file = config.PROCESSED_DATA_PATH / "day11_risk_summary.csv"
    risk_df.to_csv(risk_file, index=False)
    
    # Create risk analysis JSON
    risk_analysis = {
        'portfolio_risk': {
            'var_95': 0.05,
            'var_99': 0.08,
            'expected_return': 0.12,
            'volatility': 0.20
        },
        'performance_metrics': {
            'sharpe_ratio': 2.1,
            'max_drawdown': 0.15,
            'win_rate': 0.62
        }
    }
    
    import json
    risk_json_file = config.PROCESSED_DATA_PATH / "day11_risk_analysis.json"
    with open(risk_json_file, 'w') as f:
        json.dump(risk_analysis, f, indent=2)
    
    print(f"✅ Created risk analysis files")

def main():
    """Main model initialization function"""
    print("🚀 Stock Market Prediction Engine - Model Initialization")
    print("=" * 60)
    print()
    print("This script creates placeholder models for demonstration purposes.")
    print("In production, you would train models on real historical data.")
    print()
    
    try:
        # Create models
        feature_columns, training_samples = create_basic_models()
        
        # Create risk analysis
        create_risk_summary()
        
        print()
        print("🎉 Model Initialization Complete!")
        print("=" * 40)
        print(f"✅ Created 6 ML models")
        print(f"✅ Used {len(feature_columns)} features")
        print(f"✅ Trained on {training_samples} samples")
        print(f"✅ Created feature scaler")
        print(f"✅ Generated risk analysis")
        print()
        print("📝 Note: These are demonstration models using synthetic data.")
        print("    For production use, train on real historical market data.")
        print()
        print("🚀 Ready to run the applications:")
        print("   • ./run_api.sh         - Start API server")
        print("   • ./run_dashboard.sh   - Start dashboard")
        print("   • ./run_all.sh         - Start both services")
        
    except Exception as e:
        print(f"❌ Error during model initialization: {e}")
        return 1
    
    return 0

if __name__ == "__main__":
    exit(main())