#!/bin/bash

CONSUMER_EXEC=$BINDIR/pipeline1_consumer

echo "-- Start consumer application"
consumer_cmd="LD_PRELOAD=$DYAD_WRAPPER_LIB DYAD_KVS_NAMESPACE=$KVS_NAMESPACE \
    DYAD_PATH_CONSUMER=$CONSUMER_DIR flux mini run --exclusive -N 1 -n 1 \
    $CONSUMER_EXEC $SCRIPT_DIR/compute.py analyze $NSTEPS -g 0 -c $NSTEPS -d $CONSUMER_DIR"
echo ${consumer_cmd}
eval ${consumer_cmd} &> $OUT_DIR/log.consumer &
consumer_pid=$!
