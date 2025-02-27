#!/bin/bash
set -e

echo "Installing base system dependencies..."
apt update && apt install -y \
    python3 \
    python3-pip \
    wget \
    cmake \
    g++ \
    curl \
    sudo \
    git

# Install basic Python packages
pip3 install --no-cache-dir pandas openpyxl