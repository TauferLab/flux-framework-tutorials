#!/bin/bash
#BSUB -nnodes 2
#BSUB -G guests
#BSUB -J dyad_benchmark_test_p1
#BSUB -o dyad_benchmark_test_p1.out
#BSUB -e dyad_benchmark_test_p1.err
#BSUB -W 1

FLUX_STARTUP_ARGS="-o,-S,log-filename=$(pwd)/flux.log"

module use /usr/tce/modulefiles/Core
module use /usr/global/tools/flux/blueos_3_ppc64le_ib/modulefiles
module load pmi-shim

# PMIX_MCA_gds="^ds12,ds21" jsrun -a 1 -c ALL_CPUS -g ALL_GPUS -n 2 --smpiargs="-disable_gpu_hooks" flux start $FLUX_STARTUP_ARGS ./dyad.sh
jsrun -a 1 -c ALL_CPUS -g ALL_GPUS -n 2 flux start $FLUX_STARTUP_ARGS ./dyad.sh
