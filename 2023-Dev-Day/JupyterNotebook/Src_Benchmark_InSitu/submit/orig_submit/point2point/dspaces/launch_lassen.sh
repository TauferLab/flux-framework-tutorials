#!/bin/bash
#BSUB -nnodes 3
# Other BSUB args here

FLUX_STARTUP_ARGS="-o,-S,log_filename=flux.log"

module use /usr/tce/modulefiles/Core
module use /usr/global/tools/flux/blueos_3_ppc64le_ib/modulefiles
module load pmi-shim

PMIX_MCA_gds="^ds12,ds21" jsrun -a 1 -c ALL_CPUS -g ALL_GPUS -n 3 --smpiargs"-disable_gpu_hooks" flux start $FLUX_STARTUP_ARGS ./dspaces.sh
