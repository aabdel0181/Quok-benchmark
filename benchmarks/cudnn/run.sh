#!/bin/bash
nvcc cudnn_benchmark.cu -o cudnn_benchmark -lcudnn -lcuda -std=c++11
./cudnn_benchmark > ../../results/cudnn_results.txt