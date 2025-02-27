#!/bin/bash
set -e

echo "Installing cuDNN dependencies..."

# Install cuDNN
apt-get install -y --no-install-recommends \
    libcudnn8 \
    libcudnn8-dev

# Verify cuDNN installation
if ! ldconfig -p | grep -q libcudnn; then
    echo "ERROR: cuDNN installation failed!"
    exit 1
fi