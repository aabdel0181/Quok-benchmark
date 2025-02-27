#!/bin/bash
nvcc -o cublas_benchmark cublas_benchmark.cu -lcublas -lcudart
./cublas_benchmark > ../../results/cublas_results.txt