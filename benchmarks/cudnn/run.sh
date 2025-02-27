#!/bin/bash
set -e

# Create results directory
mkdir -p ../../results

# Run benchmark and save raw output
nvcc cudnn_benchmark.cu -o cudnn_benchmark -lcudnn -lcuda -std=c++11
./cudnn_benchmark > ../../results/cudnn_raw.txt

# Create JSON output
cat > ../../results/cudnn_results.json << EOF
{
  "benchmark": "cudnn",
  "results": $(awk '
    BEGIN { printf "{\n" }
    /Matrix Size:/ { printf "    \"matrix_size\": \"%s\",\n", $3 }
    /Conv Time:/ { printf "    \"conv_time_ms\": %s,\n", $3 }
    /Activation Time:/ { printf "    \"activation_time_ms\": %s,\n", $3 }
    /Pooling Time:/ { printf "    \"pooling_time_ms\": %s\n", $3 }
    END { printf "  }" }' ../../results/cudnn_raw.txt)
}
EOF

# Display results
cat ../../results/cudnn_results.json