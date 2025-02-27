#!/bin/bash
set -e

echo "Installing CUBLAS dependencies..."

# Check if CUDA is installed
if ! command -v nvcc &> /dev/null; then
    echo "Installing CUDA Toolkit..."
    apt install -y nvidia-cuda-toolkit
fi

# Configure CUDA paths
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

echo "CUDA PATH configured: $(which nvcc)"