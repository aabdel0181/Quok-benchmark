#!/bin/bash
set -e

# Parse command line arguments
INSTALL_ALL=false
INSTALL_BASE=false
INSTALL_CUBLAS=false
INSTALL_CUDNN=false
INSTALL_AI=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --all)
            INSTALL_ALL=true
            ;;
        --base)
            INSTALL_BASE=true
            ;;
        --cublas)
            INSTALL_CUBLAS=true
            ;;
        --cudnn)
            INSTALL_CUDNN=true
            ;;
        --ai)
            INSTALL_AI=true
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
    shift
done

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "❌ This script must be run as root. Try: sudo bash install.sh"
    exit 1
fi

# Function to install component if selected or if installing all
install_if_selected() {
    local component=$1
    local flag=$2
    if [[ "$INSTALL_ALL" = true ]] || [[ "$flag" = true ]]; then
        echo "Installing $component..."
        bash "$(dirname "$0")/install_$component.sh"
    fi
}

# Always install base if nothing specific is selected
if [[ "$INSTALL_ALL" = false ]] && \
   [[ "$INSTALL_BASE" = false ]] && \
   [[ "$INSTALL_CUBLAS" = false ]] && \
   [[ "$INSTALL_CUDNN" = false ]] && \
   [[ "$INSTALL_AI" = false ]]; then
    INSTALL_BASE=true
fi

# Install components
install_if_selected "base" "$INSTALL_BASE"
install_if_selected "cublas" "$INSTALL_CUBLAS"
install_if_selected "cudnn" "$INSTALL_CUDNN"
install_if_selected "ai" "$INSTALL_AI"

echo "Installation complete!"