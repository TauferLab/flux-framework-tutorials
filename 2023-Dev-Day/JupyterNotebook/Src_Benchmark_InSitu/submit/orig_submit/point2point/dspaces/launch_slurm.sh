#!/bin/bash
#SBATCH -N 3
# Slurm args here

FLUX_STARTUP_ARGS="-o,-S,log_filename=flux.log"

srun --pty --mpi=pmi2 -N 3 flux start $FLUX_STARTUP_ARGS ./dspaces.sh
