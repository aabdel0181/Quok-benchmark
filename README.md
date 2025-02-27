# Quok-benchmark
benchmarking repo for quok.it's reliability agent

## Output Format
The system generates three main output files:
- `results.txt`: Raw benchmark results
- `gpu_benchmark_results.json`: Structured performance metrics
- `ai_benchmark_results.json`: Deep learning benchmark results

## Warning System
The health monitoring system uses a two-tier warning system:
- Warning: Indicates potential issues requiring attention
- Critical: Indicates immediate action required

## Dependencies
- NVIDIA GPU drivers
- CUDA Toolkit
- cuDNN
- Python 3.x
- TensorFlow
- AI Benchmark suite

## Installation
Run the installation script to set up all dependencies:
bash 
sudo bash install_deps.sh 


## Code References
- GPU Health Monitoring: `gpu_health.sh`
- CUBLAS Benchmark: `cublas_benchmark.cu`
- cuDNN Benchmark: `cudnn_benchmark.cu`
- AI Benchmark: `ai_benchmark.py`
- Results Parser: `parse.py`

## Best Practices
1. Run health checks regularly during intensive GPU operations
2. Monitor temperature and memory usage during long training sessions
3. Compare benchmark results against baseline measurements
4. Keep drivers and CUDA toolkit updated
5. Ensure adequate cooling and power supply

## Troubleshooting
- If benchmarks fail, check GPU driver compatibility
- For memory errors, reduce batch sizes or model complexity
- For thermal issues, check cooling system and ambient temperature
- For power-related issues, verify PSU capacity and power delivery

## Notes
- Benchmark results may vary based on system configuration
- Temperature thresholds may need adjustment for different GPU models
- Power limits should be adjusted according to GPU specifications

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