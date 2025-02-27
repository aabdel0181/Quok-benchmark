# Quok GPU Benchmark Suite

A comprehensive GPU benchmarking suite for testing and validating GPU performance across multiple computational domains.

## Table of Contents

- [Installation](#installation)
- [Running Benchmarks](#running-benchmarks)
- [Sanity Checks](#sanity-checks)
- [Directory Structure](#directory-structure)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Installation

### Prerequisites

- **Hardware:** NVIDIA GPU  
- **Operating System:** Ubuntu 20.04 or later  
- **Software:** Python 3.8+, NVIDIA drivers installed  

### Installing Dependencies

#### 1. Install All Dependencies

sudo ./scripts/install/install.sh --all

#### 2. Install Specific Dependencies

# CUBLAS Only
sudo ./scripts/install/install.sh --cublas

# cuDNN Only
sudo ./scripts/install/install.sh --cudnn

# AI Benchmark Only
sudo ./scripts/install/install.sh --ai

## Running Benchmarks

### GPU Health Check

Run a basic GPU health check:
sudo ./scripts/gpu_health.sh

### Individual Benchmarks

1. **CUBLAS Benchmark**

   - Tests basic linear algebra operations and memory transfer speeds.

sudo ./benchmarks/cublas/run.sh

2. **cuDNN Benchmark**

- Tests deep learning primitives like convolutions and pooling operations.

sudo ./benchmarks/cudnn/run.sh

3. **AI Benchmark**

- Tests various deep learning models and architectures.

sudo ./benchmarks/ai/run.sh

### Combined Benchmarks

1. **Run All Benchmarks**

sudo ./scripts/run_benchmarks.sh --all

2. **Custom Combinations**

# Run CUBLAS and AI benchmarks
sudo ./scripts/run_benchmarks.sh --cublas --ai

# Run cuDNN and AI benchmarks
sudo ./scripts/run_benchmarks.sh --cudnn --ai

## Sanity Checks

### Running Sanity Checks

# Run with all benchmarks
sudo ./scripts/run_benchmarks.sh --all --sanity

# Run with specific benchmarks
sudo ./scripts/run_benchmarks.sh --cublas --ai --sanity

## CUBLAS Benchmark 

### Overview 
CUBLAS (CUDA Basic Linear Algebra Subroutines) benchmark tests fundamental matrix operations that are crucial for machine learning and scientific computing.

- Matrix multiplication (GEMM) operations
- Memory transfer speeds between CPU and GPU
- Raw computational throughput
- Matrix sizes of 2048x2048
- Measures execution time and GFLOPS

### What it tells us 
- Peak floating-point performance
- Memory bandwidth efficiency
- Data transfer overhead
- Basic CUDA core utilization
- Memory subsystem performance

### Why it's important 
- Provides baseline GPU performance metrics
- Essential for machine learning workloads
- Indicates hardware-level optimization
- Validates basic CUDA functionality
- Benchmarks memory hierarchy efficiency

## cuDNN Benchmark 

### Overview 
Tests deep learning primitives using NVIDIA's Deep Neural Network library (cuDNN).

- Convolution operations (3x3 kernel)
- Activation functions (ReLU)
- Pooling operations
- Input size 256x256
- Measures millisecond-level timing

### What It Tells Us
- Neural network operation efficiency
- Hardware acceleration capabilities
- Layer-wise processing speed
- Memory access patterns
- Tensor operation performance

### Why It's Important
- Critical for deep learning workloads
- Indicates real-world DL performance
- Validates hardware-accelerated operations
- Essential for training optimization
- Benchmarks framework compatibility

## AI Benchmark 

### Overview 
Comprehensive deep learning model benchmark suite testing various neural network architectures.

- Tests multiple architectures:
- Mobile networks (MobileNet)
- Classification networks (Inception, ResNet)
- Image processing (VGG)
- Specialized networks (SPADE, ICNet)

### What it Tells Us 

- Model-specific performance
- Training capabilities
- Inference speed
- Framework optimization
- Architecture-specific bottlenecks

### Why It's Important

- Validates production workload performance
- Guides model selection
- Identifies optimization opportunities
- Ensures deployment readiness
- Benchmarks end-to-end capabilities

## GPU Sanity Check 

### Overview 
Validates GPU performance against known-good benchmarks and manufacturer specifications.

- Compares inference times
- Validates training performance
- Checks against reference data
- Implements tolerance thresholds
- Tracks test failures

### What it Tells us 

- Hardware reliability
- Performance consistency
- Driver optimization
- System integration quality
- Potential hardware issues

### Why It's Important
- Ensures hardware integrity
- Validates system configuration
- Identifies performance regression
- Maintains quality standards
- Supports troubleshooting efforts
### Understanding Sanity Check Results

The sanity check compares your GPU's performance against known-good benchmarks:

-  **PASS:** Performance within expected ranges  
- **FAIL:** Performance outside expected ranges  

Results are stored in:

- `results/benchmark_results.json`
- `results/sanity_check_report.json`

## Directory Structure

quok-benchmark/
├── scripts/
│ ├── gpu_health.sh
│ ├── run_benchmarks.sh
│ └── install/
│ ├── install_base.sh
│ ├── install_cublas.sh
│ ├── install_cudnn.sh
│ ├── install_ai.sh
│ └── install.sh
├── benchmarks/
│ ├── cublas/
│ ├── cudnn/
│ └── ai/
├── utils/
│ ├── parse.py
│ └── gpu_sanity_check.py
└── results/

## Troubleshooting
### Common Issues

1. **Installation Failures:**

   - Verify CUDA installation:

     ```
     nvcc --version
     ```

   - Verify cuDNN installation:

     ```
     ldconfig -p | grep cudnn
     ```

2. **Benchmark Failures:**

   - Check GPU health:

     ```
     python3 main.py --health
     ```

   - Verify GPU temperature:

     ```
     nvidia-smi
     ```

   - Check system resources:

     ```
     top
     # or
     htop
     ```

3. **Performance Issues:**

   - Update NVIDIA drivers.
   - Check power management settings.
   - Ensure thermal throttling is not occurring.

### Error Messages

1. **CUDA Not Found:**

sudo apt install nvidia-cuda-toolkit
2. **cuDNN Missing:**

sudo apt-get install libcudnn8 libcudnn8-dev

3. **Python Dependencies Issues:**

pip3 install -r requirements.txt

### Getting Help

- Review logs in the `results/` directory.
- Run with verbose output:

python3 main.py --all --verbose

- When submitting an issue, include:
- Full error message
- GPU model
- Driver version
- Benchmark results

## Contributing

1. Fork the repository.
2. Create a feature branch.
3. Submit a pull request with your changes.

## License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.