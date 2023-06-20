#!/bin/bash

export INSTALL_PREFIX="/g/g90/lumsden1/ws/insitu_benchmark/Src_Benchmark_InSitu/_catalyst_install"
export SCRIPT_DIR="$INSTALL_PREFIX/libexec"
export DYAD_WRAPPER_LIB="$INSTALL_PREFIX/lib64/dyad_wrapper.so"
export DYAD_MODULE="$INSTALL_PREFIX/lib64/dyad.so"
export NSTEPS=20
export NATOMS=200
export DELAY=0
export DYAD_KVS_NAMESPACE="dyad_pipeline1"
export DYAD_PATH_PRODUCER="/tmp/dyad_pipeline1"
export DYAD_PATH_CONSUMER="/tmp/dyad_pipeline1"
export DYAD_DTL_MODE="FLUX_RPC"
