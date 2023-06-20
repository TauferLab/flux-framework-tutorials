#!/bin/bash

## Run producer application
echo "-- Start producer application"
producer_cmd="flux mini run --exclusive -N 1 -n 1 \
    $BINDIR/producer 1 ./load.py extract_frame $NSTEPS $NATOMS $DELAY"
echo ${producer_cmd}
eval ${producer_cmd} &> log.producer &
producer_pid=$!
