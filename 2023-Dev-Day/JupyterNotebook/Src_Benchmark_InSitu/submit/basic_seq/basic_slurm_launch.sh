#!/bin/bash
#SBATCH -N 2
#SBATCH -A guests
#SBATCH -J insitu_benchmark_basic_sequential
#SBATCH -o insitu_benchmark_basic_sequential.out
#SBATCH -e insitu_benchmark_basic_sequential.err
#SBATCH -t 120

FLUX_STARTUP_ARGS="-o,-S,log-filename=$(pwd)/flux.log"

srun --pty --mpi=pmi2 -N 2 flux start $FLUX_STARTUP_ARGS /collab/usr/gapps/python/build/spack-toss3.4/opt/spack/linux-rhel7-ivybridge/gcc-4.9.3/python-3.8.2-6me27g5yfvrxpcsemax25kovzjbf22vt/bin/python3 $(pwd)/driver.py dyad $(pwd)/test.toml
