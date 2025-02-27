import argparse
import subprocess
import json
import sys
import os

def install_dependencies(args):
    modify_permissions = ['sudo','chmod', '+x', 'scripts/install/install.sh']
    subprocess.run(modify_permissions, check=True)

    cmd = ['sudo', 'scripts/install/install.sh']
    
    if args.all:
        cmd.append('--all')
    else:
        if args.cublas:
            cmd.append('--cublas')
        if args.cudnn:
            cmd.append('--cudnn')
        if args.ai:
            cmd.append('--ai')
    
    subprocess.run(cmd, check=True)

def load_config():
    with open('config/benchmark_config.json', 'r') as f:
        return json.load(f)

def run_health_check():
    subprocess.run(['scripts/gpu_health.sh'], check=True)

def run_benchmarks(args):
    cmd = ['scripts/run_benchmarks.sh']
    
    if args.all:
        cmd.append('--all')
    else:
        if args.cublas:
            cmd.append('--cublas')
        if args.cudnn:
            cmd.append('--cudnn')
        if args.ai:
            cmd.append('--ai')
    
    if args.sanity:
        cmd.append('--sanity')
    
    subprocess.run(cmd, check=True)

def main():
    parser = argparse.ArgumentParser(description='GPU Benchmark Suite')
    
    # Add install argument group
    install_group = parser.add_argument_group('Installation options')
    install_group.add_argument('--install', action='store_true', help='Install dependencies')
    
    # Add benchmark argument group
    benchmark_group = parser.add_argument_group('Benchmark options')
    benchmark_group.add_argument('--health', action='store_true', help='Run GPU health check')
    benchmark_group.add_argument('--cublas', action='store_true', help='Run CUBLAS benchmark')
    benchmark_group.add_argument('--cudnn', action='store_true', help='Run cuDNN benchmark')
    benchmark_group.add_argument('--ai', action='store_true', help='Run AI benchmark')
    benchmark_group.add_argument('--all', action='store_true', help='Run all benchmarks')
    benchmark_group.add_argument('--sanity', action='store_true', help='Run sanity check')
    
    args = parser.parse_args()
    
    # Handle installation
    if args.install:
        install_dependencies(args)
        return
    
    # Handle benchmarks
    if args.health:
        run_health_check()
    
    if any([args.cublas, args.cudnn, args.ai, args.all]):
        run_benchmarks(args)

if __name__ == "__main__":
    main()