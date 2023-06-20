#!/bin/bash
#SBATCH -N 2
#SBATCH -A guests
#SBATCH -J dyad_benchmark_test_p1
#SBATCH -o %x_%u.out
#SBATCH -e %x_%u.err
#SBATCH -t 120

FLUX_STARTUP_ARGS="-o,-S,log-filename=$(pwd)/flux.log"

srun --pty --mpi=pmi2 -N 2 flux start $FLUX_STARTUP_ARGS ./dyad.sh
