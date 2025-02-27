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

python3 main.py --install --all

#### 2. Install Specific Dependencies

- **CUBLAS Only:**

python3 main.py --install --cublas

- **cuDNN Only:**

python3 main.py --install --cudnn

- **AI Benchmark Only:**

python3 main.py --install --ai

- **Multiple Specific Components (e.g., CUBLAS and AI):**

python3 main.py --install --cublas --ai


#### 3. Install Base Dependencies Only

python3 main.py --install


## Running Benchmarks

### GPU Health Check

Run a basic GPU health check:

python3 main.py --health

### Individual Benchmarks

1. **CUBLAS Benchmark**

   - Tests basic linear algebra operations and memory transfer speeds.

python3 main.py --cublas

2. **cuDNN Benchmark**

- Tests deep learning primitives like convolutions and pooling operations.

python3 main.py --cudnn

3. **AI Benchmark**

- Tests various deep learning models and architectures.

python3 main.py --ai

### Combined Benchmarks

1. **Run All Benchmarks**

python3 main.py --all

2. **Custom Combinations**

- Run CUBLAS and AI benchmarks:

  ```
  python3 main.py --cublas --ai
  ```

- Run cuDNN and AI benchmarks:

  ```
  python3 main.py --cudnn --ai
  ```

## Sanity Checks

### Running Sanity Checks

- **After All Benchmarks:**

python3 main.py --all --sanity



- **After Specific Benchmarks (e.g., CUBLAS and AI):**

python3 main.py --cublas --ai --sanity



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