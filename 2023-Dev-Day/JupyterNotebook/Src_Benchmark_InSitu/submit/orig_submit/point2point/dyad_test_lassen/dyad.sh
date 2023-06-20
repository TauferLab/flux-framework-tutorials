#!/bin/bash

# If an error occurs in any command,
# crash the job
set -e

######################
# GENERAL PARAMETERS #
######################

## Install prefix for the benchmark
INSTALL_PREFIX="/g/g90/lumsden1/ws/insitu_benchmark/Src_Benchmark_InSitu/_lassen_install"
## Output directory for the benchmark
OUT_DIR="/g/g90/lumsden1/ws/insitu_benchmark/Src_Benchmark_InSitu/submit/point2point/dyad_test_lassen/out"
## Name of the CSV file to store timing results
TIMING_OUT_CSV="nsteps_scaling_timings.csv"
## Number of steps
NSTEPS=10
## Number of atoms
#NATOMS=37448 # Roughly 1MB
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

start_time=$(date +%s%N)
source ./run_cons.sh

if [ -z ${consumer_pid+x} ]; then
    echo "consumer_pid not set! Aborting!"
    exit -1
fi

source ./run_prod.sh

if [ -z ${producer_pid+x} ]; then
    echo "producer_pid not set! Aborting!"
    exit -1
fi

echo "-- Wait until all applications exit."
#wait

wait $producer_pid
echo "---- Producer exit."

wait $consumer_pid
echo "---- Consumer exit."
stop_time=$(date +%s%N)

source ./dtl_shutdown.sh

echo "-- All applications exit."

if [ ! -f $TIMING_OUT_CSV ]; then
    touch $TIMING_OUT_CSV
    echo "nsteps,natoms,delay,time" >> $TIMING_OUT_CSV
fi
echo "$NSTEPS,$NATOMS,$DELAY,$(($stop_time-$start_time))" >> $TIMING_OUT_CSV
