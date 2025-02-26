#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -o pipefail  # Fail pipeline if any command fails

# Define working directory
INSTALL_DIR="/benchmark"

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "❌ This script must be run as root. Try: sudo bash install_benchmark.sh"
    exit 1
fi

echo "Updating system packages..."
apt update && apt install -y \
    python3 \
    python3-pip \
    wget \
    cmake \
    g++ \
    curl \
    sudo \
    git

echo "Installing Python dependencies..."
pip3 install --no-cache-dir pandas openpyxl

echo "Installing CUDA & cuDNN dependencies..."
apt-get install -y --no-install-recommends \
    libcudnn8 libcudnn8-dev

echo "Installing AI Benchmark..."
pip3 install ai_benchmark
sed -i '/np.warnings.filterwarnings/d' /usr/local/lib/python3.10/dist-packages/ai_benchmark/__init__.py

echo "Installing TensorFlow optimized for CUDA..."
pip3 install --no-cache-dir tensorflow[and-cuda]

# Create installation directory
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

echo "Compiling CUBLAS benchmark..."
nvcc -o "cublas_benchmark" "$cublas_benchmark.cu" -lcublas -lcudart

echo "Compiling CUDNN benchmark..."
nvcc "cudnn_benchmark.cu" -o "/cudnn_benchmark" -lcudnn -lcuda -std=c++11

echo "Setting up entrypoint script..."
chmod +x "entrypoint.sh"

echo "Installation complete! To run the benchmark, execute:"
echo "   "entrypoint.sh"
