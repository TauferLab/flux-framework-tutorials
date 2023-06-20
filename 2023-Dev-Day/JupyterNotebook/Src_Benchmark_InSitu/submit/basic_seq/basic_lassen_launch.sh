#!/bin/bash
#BSUB -nnodes 2
#BSUB -G guests
#BSUB -J insitu_benchmark_basic_sequential
#BSUB -o insitu_benchmark_basic_sequential.out
#BSUB -e insitu_benchmark_basic_sequential.err
#BSUB -W 120

FLUX_STARTUP_ARGS="-o,-S,log-filename=$(pwd)/flux.log"

module use /usr/tce/modulefiles/Core
module use /usr/global/tools/flux/blueos_3_ppc64le_ib/modulefiles
module load pmi-shim
# 
# spack env activate -d /g/g90/lumsden1/ws/insitu_benchmark/_lassen_spack_env

# export LD_LIBRARY_PATH="/usr/tce/packages/spectrum-mpi/spectrum-mpi-2020.08.19-gcc-8.3.1/lib/spectrum_mpi:$LD_LIBRARY_PATH"

# export LD_LIBRARY_PATH="/usr/tce/packages/python/python-3.7.2/lib:/usr/global/tools/flux/blueos_3_ppc64le_ib/spectrum-mpi-2019.06.24/lib/spectrum_mpi:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="/usr/tce/packages/python/python-3.7.2/lib:$LD_LIBRARY_PATH"
export PMIX_MCA_gds="^ds12,ds21"
export UCX_LOG_LEVEL="data"

jsrun -a 1 -c ALL_CPUS -g ALL_GPUS -n 2 --bind=none --smpiargs="-disable_gpu_hooks" flux start $FLUX_STARTUP_ARGS /usr/tce/packages/python/python-3.8.2/bin/python3 $(pwd)/driver.py dyad $(pwd)/lassen.toml -m spectrum
