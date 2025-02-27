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

# Capture `nvidia-smi` output
GPU_INFO=$(nvidia-smi --query-gpu=gpu_uuid,name,temperature.gpu,fan.speed,memory.total,memory.used,utilization.gpu,utilization.memory,power.draw,power.limit,driver_version --format=csv,noheader,nounits)

# Extract key details
GPU_UUID=$(echo "$GPU_INFO" | cut -d ',' -f1)
GPU_NAME=$(echo "$GPU_INFO" | cut -d ',' -f2)
GPU_TEMP=$(echo "$GPU_INFO" | cut -d ',' -f3)
FAN_SPEED=$(echo "$GPU_INFO" | cut -d ',' -f4)
MEMORY_TOTAL=$(echo "$GPU_INFO" | cut -d ',' -f5)
MEMORY_USED=$(echo "$GPU_INFO" | cut -d ',' -f6)
GPU_UTILIZATION=$(echo "$GPU_INFO" | cut -d ',' -f7)
MEMORY_UTILIZATION=$(echo "$GPU_INFO" | cut -d ',' -f8)
POWER_DRAW=$(echo "$GPU_INFO" | cut -d ',' -f9)
POWER_LIMIT=$(echo "$GPU_INFO" | cut -d ',' -f10)
DRIVER_VERSION=$(echo "$GPU_INFO" | cut -d ',' -f11)

echo ""
echo "GPU UUID: $GPU_UUID"
echo "GPU Name: $GPU_NAME"
echo "Driver Version: $DRIVER_VERSION"
echo "Temperature: ${GPU_TEMP}C"
echo "Fan Speed: ${FAN_SPEED}%"
echo "Memory Usage: ${MEMORY_USED}MB / ${MEMORY_TOTAL}MB"
echo "GPU Utilization: ${GPU_UTILIZATION}%"
echo "Memory Utilization: ${MEMORY_UTILIZATION}%"
echo "Power Draw: ${POWER_DRAW}W"
echo "Power Limit: ${POWER_LIMIT}W"
echo ""

# Define safe thresholds
TEMP_WARN=40
TEMP_CRITICAL=70
MEMORY_UTIL_WARN=40
MEMORY_UTIL_CRITICAL=80
GPU_UTIL_WARN=50
GPU_UTIL_CRITICAL=95
POWER_WARN=40  # Percentage of power limit
POWER_CRITICAL=100

# Initialize status messages
concerns=()
fine=()

# Check GPU temperature
if (( $(echo "$GPU_TEMP >= $TEMP_CRITICAL" | bc -l) )); then
    concerns+=("CRITICAL: GPU temperature is very high ($GPU_TEMP C). Immediate action recommended.")
elif (( $(echo "$GPU_TEMP >= $TEMP_WARN" | bc -l) )); then
    concerns+=("Warning: GPU temperature is elevated ($GPU_TEMP C). Consider improving cooling.")
else
    fine+=("GPU temperature is within normal range ($GPU_TEMP C).")
fi

# Check memory utilization
MEMORY_PERCENT=$(echo "scale=2; $MEMORY_USED / $MEMORY_TOTAL * 100" | bc -l)
if (( $(echo "$MEMORY_PERCENT >= $MEMORY_UTIL_CRITICAL" | bc -l) )); then
    concerns+=("CRITICAL: GPU memory usage is extremely high (${MEMORY_PERCENT}%).")
elif (( $(echo "$MEMORY_PERCENT >= $MEMORY_UTIL_WARN" | bc -l) )); then
    concerns+=("Warning: GPU memory usage is high (${MEMORY_PERCENT}%).")
else
    fine+=("GPU memory usage is within normal range (${MEMORY_PERCENT}%).")
fi

# Check GPU utilization
if (( $(echo "$GPU_UTILIZATION >= $GPU_UTIL_CRITICAL" | bc -l) )); then
    concerns+=("CRITICAL: GPU utilization is at ${GPU_UTILIZATION}%.")
elif (( $(echo "$GPU_UTILIZATION >= $GPU_UTIL_WARN" | bc -l) )); then
    concerns+=("Warning: GPU utilization is high (${GPU_UTILIZATION}%).")
else
    fine+=("GPU utilization is normal (${GPU_UTILIZATION}%).")
fi

# Check power usage
POWER_PERCENT=$(echo "scale=2; $POWER_DRAW / $POWER_LIMIT * 100" | bc -l)
if (( $(echo "$POWER_PERCENT >= $POWER_CRITICAL" | bc -l) )); then
    concerns+=("CRITICAL: GPU power draw is at ${POWER_PERCENT}% of its limit.")
elif (( $(echo "$POWER_PERCENT >= $POWER_WARN" | bc -l) )); then
    concerns+=("Warning: GPU power draw is high at ${POWER_PERCENT}% of its limit.")
else
    fine+=("GPU power draw is within safe limits (${POWER_PERCENT}% of limit).")
fi

# Check fan speed
if (( $(echo "$FAN_SPEED == 0" | bc -l) )); then
    concerns+=("Warning: GPU fan is not running. Check cooling system.")
else
    fine+=("GPU fan is operational (${FAN_SPEED}%).")
fi

# Print results
echo "--------------------------"
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
