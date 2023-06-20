#!/bin/bash
#BSUB -nnodes 3
# Other BSUB args here

FLUX_STARTUP_ARGS="-o,-S,log_filename=flux.log"

jsrun -a 1 -c ALL_CPUS -g ALL_GPUS -n 3 --smpiargs"-disable_gpu_hooks" flux start $FLUX_STARTUP_ARGS ./dspaces.sh
