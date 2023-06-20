#!/bin/bash

## Run consumer application
echo "-- Start consumer application"
consumer_cmd="flux mini run --exclusive -N 1 -n 1 \
    $BINDIR/consumer 2 ./compute.py analyze $NSTEPS"
echo ${consumer_cmd}
eval ${consumer_cmd} &> log.consumer &
consumer_pid=$!
