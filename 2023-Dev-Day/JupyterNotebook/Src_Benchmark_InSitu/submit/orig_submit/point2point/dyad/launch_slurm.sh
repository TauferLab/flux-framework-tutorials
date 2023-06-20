#!/bin/bash
#SBATCH -N 2
#SBATCH -J dyad_benchmark_test_pipeline1
#SBATCH -o %x_%u.out
#SBATCH -e %x_%u.err
# Slurm args here

FLUX_STARTUP_ARGS="-o,-S,log_filename=flux.log"

srun --pty --mpi=pmi2 -N 2 flux start $FLUX_STARTUP_ARGS ./dyad.sh
