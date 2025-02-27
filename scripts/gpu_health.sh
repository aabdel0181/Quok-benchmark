#!/bin/bash

# Ensure required packages are installed
if ! command -v bc &> /dev/null; then
    echo "bc command not found. Installing bc..."
    sudo apt update && sudo apt install -y bc
fi

# Ensure nvidia-smi is available
if ! command -v nvidia-smi &> /dev/null; then
    echo "NVIDIA-SMI not found. Ensure you have NVIDIA drivers installed."
    exit 1
fi

echo "Running NVIDIA GPU Health Check..."
echo ""

# Get GPU information
GPU_UUID=$(nvidia-smi --query-gpu=uuid --format=csv,noheader)
GPU_NAME=$(nvidia-smi --query-gpu=name --format=csv,noheader)
DRIVER_VERSION=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader)
TEMPERATURE=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)
FAN_SPEED=$(nvidia-smi --query-gpu=fan.speed --format=csv,noheader)
MEMORY_USED=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader | cut -d' ' -f1)
MEMORY_TOTAL=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader | cut -d' ' -f1)
GPU_UTIL=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader | cut -d' ' -f1)
MEMORY_UTIL=$(nvidia-smi --query-gpu=utilization.memory --format=csv,noheader | cut -d' ' -f1)
POWER_DRAW=$(nvidia-smi --query-gpu=power.draw --format=csv,noheader | cut -d' ' -f1)
POWER_LIMIT=$(nvidia-smi --query-gpu=power.limit --format=csv,noheader | cut -d' ' -f1)

# Print basic information
echo "GPU UUID: $GPU_UUID"
echo "GPU Name:  $GPU_NAME"
echo "Driver Version:  $DRIVER_VERSION"
echo "Temperature:  ${TEMPERATURE}C"
echo "Fan Speed:  ${FAN_SPEED}%"
echo "Memory Usage:  ${MEMORY_USED}MB / ${MEMORY_TOTAL}MB"
echo "GPU Utilization:  ${GPU_UTIL}%"
echo "Memory Utilization:  ${MEMORY_UTIL}%"
echo "Power Draw:  ${POWER_DRAW}W"
echo "Power Limit:  ${POWER_LIMIT}W"
echo ""

# Initialize arrays for concerns and fine status
declare -a concerns
declare -a fine

# Check temperature
if [ "$TEMPERATURE" -gt 70 ]; then
    concerns+=("WARNING: GPU temperature is critically high (${TEMPERATURE}C)")
elif [ "$TEMPERATURE" -gt 40 ]; then
    concerns+=("Warning: GPU temperature is elevated (${TEMPERATURE}C)")
else
    fine+=("GPU temperature is within normal range (${TEMPERATURE}C).")
fi

# Check memory utilization
MEMORY_PERCENT=$(echo "scale=2; ($MEMORY_USED / $MEMORY_TOTAL) * 100" | bc)
if (( $(echo "$MEMORY_PERCENT > 80" | bc -l) )); then
    concerns+=("WARNING: High memory utilization (${MEMORY_PERCENT}%)")
elif (( $(echo "$MEMORY_PERCENT > 40" | bc -l) )); then
    concerns+=("Warning: Elevated memory utilization (${MEMORY_PERCENT}%)")
else
    fine+=("GPU memory usage is within normal range (${MEMORY_PERCENT}%).")
fi

# Check GPU utilization
if [ "$GPU_UTIL" -gt 95 ]; then
    concerns+=("WARNING: GPU utilization is very high (${GPU_UTIL}%)")
elif [ "$GPU_UTIL" -gt 50 ]; then
    concerns+=("Warning: GPU utilization is elevated (${GPU_UTIL}%)")
else
    fine+=("GPU utilization is normal (${GPU_UTIL}%).")
fi

# Check power usage
POWER_PERCENT=$(echo "scale=2; ($POWER_DRAW / $POWER_LIMIT) * 100" | bc)
if (( $(echo "$POWER_PERCENT > 100" | bc -l) )); then
    concerns+=("WARNING: GPU power usage exceeds limit!")
elif (( $(echo "$POWER_PERCENT > 40" | bc -l) )); then
    concerns+=("Warning: High power usage (${POWER_PERCENT}% of limit)")
else
    fine+=("GPU power draw is within safe limits (${POWER_PERCENT}% of limit).")
fi

# Check fan speed
if [[ "$FAN_SPEED" == "[N/A]" ]]; then
    # Data center GPU with alternative cooling
    if [ "$TEMPERATURE" -lt 85 ]; then
        fine+=("Cooling system is functioning properly (Temperature: ${TEMPERATURE}C)")
    else
        concerns+=("WARNING: High temperature detected (${TEMPERATURE}C) despite cooling system")
    fi
else
    # Traditional GPU with fan
    if [ "$FAN_SPEED" -gt 90 ]; then
        concerns+=("WARNING: Fan speed is very high (${FAN_SPEED}%)")
    elif [ "$FAN_SPEED" -gt 70 ]; then
        concerns+=("Warning: Fan speed is elevated (${FAN_SPEED}%)")
    else
        fine+=("GPU fan is operational (${FAN_SPEED}%).")
    fi
fi

echo "--------------------------"
# Print concerns if any exist
if [ ${#concerns[@]} -gt 0 ]; then
    echo "Concerns detected"
    for issue in "${concerns[@]}"; do
        echo "$issue"
    done
else
    echo "No major issues detected"
fi

echo ""
echo "Fine status"
for okay in "${fine[@]}"; do
    echo "$okay"
done
echo "--------------------------"