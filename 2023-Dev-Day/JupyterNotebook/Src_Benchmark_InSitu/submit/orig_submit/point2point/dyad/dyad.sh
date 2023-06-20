#!/bin/bash

# If an error occurs in any command,
# crash the job
set -e

######################
# GENERAL PARAMETERS #
######################

## Install prefix for the benchmark
INSTALL_PREFIX="/g/g90/lumsden1/ws/insitu_benchmark/Src_Benchmark_InSitu/_test_install"
## Output directory for the benchmark
OUT_DIR=""
## Number of steps
NSTEPS=10
## Number of atoms
NATOMS=200
## Delay time
DELAY=0

##########################
# END GENERAL PARAMETERS #
##########################

SCRIPT_DIR="$INSTALL_PREFIX/libexec"

## Number of ingesters and comsumers in total
## Hardcoded to 2 because this workflow only consists of
## a single producer and a single consumer
NCLIENTS=2

## Clean up
rm -rf __pycache__ log.*

if [ ! -d ${OUT_DIR} ]; then
    mkdir -p ${OUT_DIR}
fi

source ./dtl_startup.sh

source ./run_prod.sh

if [ -z ${producer_pid+x} ]; then
    echo "producer_pid not set! Aborting!"
    exit -1
fi

source ./run_cons.sh

if [ -z ${consumer_pid+x} ]; then
    echo "consumer_pid not set! Aborting!"
    exit -1
fi

echo "-- Wait until all applications exit."
#wait

wait $producer_pid
echo "---- Producer exit."

wait $consumer_pid
echo "---- Consumer exit."

source ./dtl_shutdown.sh

echo "-- All applications exit."
