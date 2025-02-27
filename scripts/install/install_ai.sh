#!/bin/bash
set -e

echo "Installing AI Benchmark dependencies..."

# Install TensorFlow with CUDA support
pip3 install --no-cache-dir tensorflow[and-cuda]

# Install AI Benchmark
pip3 install ai_benchmark

# Fix potential numpy warnings
sed -i '/np.warnings.filterwarnings/d' /usr/local/lib/python3.10/dist-packages/ai_benchmark/__init__.py