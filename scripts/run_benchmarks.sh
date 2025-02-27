#!/bin/bash
set -e

# Initialize flags
RUN_CUBLAS=false
RUN_CUDNN=false
RUN_AI=false
RUN_SANITY=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --cublas) RUN_CUBLAS=true ;;
        --cudnn) RUN_CUDNN=true ;;
        --ai) RUN_AI=true ;;
        --sanity) RUN_SANITY=true ;;
        --all) 
            RUN_CUBLAS=true
            RUN_CUDNN=true
            RUN_AI=true
            RUN_SANITY=true
            ;;
    esac
    shift
done

# Create results directory
mkdir -p results

# Run selected benchmarks
if [ "$RUN_CUBLAS" = true ]; then
    echo "Running CUBLAS Benchmark..."
    ./benchmarks/cublas/run.sh
fi

if [ "$RUN_CUDNN" = true ]; then
    echo "Running cuDNN Benchmark..."
    ./benchmarks/cudnn/run.sh
fi

if [ "$RUN_AI" = true ]; then
    echo "Running AI Benchmark..."
    ./benchmarks/ai/run.sh
fi

# Parse results
python3 utils/parse.py

# Run sanity check if requested
if [ "$RUN_SANITY" = true ]; then
    python3 utils/gpu_sanity_check.py
fi

# Display results
echo "==== RESULTS ===="
cat results/benchmark_results.json