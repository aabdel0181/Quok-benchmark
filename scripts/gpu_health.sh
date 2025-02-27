#!/bin/bash

# Ensure required packages are installed
if ! command -v bc &> /dev/null; then
    echo "bc command not found. Installing bc..."
    sudo apt update && sudo apt install -y bc
fi

# Ensure nvidia-smi is available
if ! command -v nvidia-smi &> /dev/null; then
    echo "{\"error\": \"NVIDIA-SMI not found. Ensure you have NVIDIA drivers installed.\"}"
    exit 1
fi

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

# Initialize arrays for concerns and status
declare -a concerns
declare -a status_messages

# Check temperature
if [ "$TEMPERATURE" -gt 70 ]; then
    concerns+=("GPU temperature is critically high (${TEMPERATURE}C)")
    TEMP_STATUS="critical"
elif [ "$TEMPERATURE" -gt 40 ]; then
    concerns+=("GPU temperature is elevated (${TEMPERATURE}C)")
    TEMP_STATUS="warning"
else
    status_messages+=("GPU temperature is within normal range")
    TEMP_STATUS="normal"
fi

# Check memory utilization
MEMORY_PERCENT=$(echo "scale=2; ($MEMORY_USED / $MEMORY_TOTAL) * 100" | bc)
if (( $(echo "$MEMORY_PERCENT > 80" | bc -l) )); then
    concerns+=("High memory utilization (${MEMORY_PERCENT}%)")
    MEM_STATUS="critical"
elif (( $(echo "$MEMORY_PERCENT > 40" | bc -l) )); then
    concerns+=("Elevated memory utilization (${MEMORY_PERCENT}%)")
    MEM_STATUS="warning"
else
    status_messages+=("GPU memory usage is within normal range")
    MEM_STATUS="normal"
fi

# Check GPU utilization
if [ "$GPU_UTIL" -gt 95 ]; then
    concerns+=("GPU utilization is very high (${GPU_UTIL}%)")
    UTIL_STATUS="critical"
elif [ "$GPU_UTIL" -gt 50 ]; then
    concerns+=("GPU utilization is elevated (${GPU_UTIL}%)")
    UTIL_STATUS="warning"
else
    status_messages+=("GPU utilization is normal")
    UTIL_STATUS="normal"
fi

# Check power usage
POWER_PERCENT=$(echo "scale=2; ($POWER_DRAW / $POWER_LIMIT) * 100" | bc)
if (( $(echo "$POWER_PERCENT > 100" | bc -l) )); then
    concerns+=("GPU power usage exceeds limit")
    POWER_STATUS="critical"
elif (( $(echo "$POWER_PERCENT > 40" | bc -l) )); then
    concerns+=("High power usage (${POWER_PERCENT}% of limit)")
    POWER_STATUS="warning"
else
    status_messages+=("GPU power draw is within safe limits")
    POWER_STATUS="normal"
fi

# Create JSON output
cat << EOF
{
    "gpu_info": {
        "uuid": "$GPU_UUID",
        "name": "$GPU_NAME",
        "driver_version": "$DRIVER_VERSION"
    },
    "metrics": {
        "temperature": {
            "value": $TEMPERATURE,
            "unit": "C",
            "status": "$TEMP_STATUS"
        },
        "fan_speed": {
            "value": "$FAN_SPEED",
            "unit": "%"
        },
        "memory": {
            "used": $MEMORY_USED,
            "total": $MEMORY_TOTAL,
            "unit": "MB",
            "utilization": $MEMORY_PERCENT,
            "status": "$MEM_STATUS"
        },
        "gpu_utilization": {
            "value": $GPU_UTIL,
            "unit": "%",
            "status": "$UTIL_STATUS"
        },
        "power": {
            "draw": $POWER_DRAW,
            "limit": $POWER_LIMIT,
            "unit": "W",
            "utilization": $POWER_PERCENT,
            "status": "$POWER_STATUS"
        }
    },
    "concerns": $(printf '%s\n' "${concerns[@]}" | jq -R . | jq -s .),
    "status_messages": $(printf '%s\n' "${status_messages[@]}" | jq -R . | jq -s .),
    "overall_status": "$([ ${#concerns[@]} -eq 0 ] && echo 'healthy' || echo 'warning')"
}
EOF