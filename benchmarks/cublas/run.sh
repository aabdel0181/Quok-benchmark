#!/bin/bash
set -e

# Create results directory
mkdir -p ../../results

# Run benchmark and save raw output
nvcc -o cublas_benchmark cublas_benchmark.cu -lcublas -lcudart
./cublas_benchmark > ../../results/cublas_raw.txt

# Create JSON output
cat > ../../results/cublas_results.json << EOF
{
  "benchmark": "cublas",
  "results": $(awk '
    BEGIN { printf "{\n" }
    /Matrix Size:/ { printf "    \"matrix_size\": \"%s\",\n", $3 }
    /Execution Time:/ { printf "    \"execution_time_ms\": %s,\n", $3 }
    /Performance:/ { printf "    \"gflops\": %s\n", $2 }
    END { printf "  }" }' ../../results/cublas_raw.txt)
}
EOF

# Display results
cat ../../results/cublas_results.json