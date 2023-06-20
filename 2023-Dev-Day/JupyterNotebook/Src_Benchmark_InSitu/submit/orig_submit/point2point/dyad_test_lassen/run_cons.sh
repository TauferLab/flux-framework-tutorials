#!/bin/bash

CONSUMER_EXEC=$BINDIR/pipeline1_consumer

echo "-- Start consumer application"
consumer_cmd="LD_PRELOAD=$DYAD_WRAPPER_LIB DYAD_KVS_NAMESPACE=$KVS_NAMESPACE \
    DYAD_PATH_CONSUMER=$CONSUMER_DIR DYAD_DTL_MODE=$DYAD_DTL_MODE UCX_LOG_LEVEL=diag \
    flux mini run --exclusive -N 1 \
    $CONSUMER_EXEC $SCRIPT_DIR/compute.py analyze $NSTEPS -g 0 -c $NSTEPS -d $CONSUMER_DIR"
echo ${consumer_cmd}
eval ${consumer_cmd} &> $OUT_DIR/log.consumer &
consumer_pid=$!

#DYAD_PATH_CONSUMER=$CONSUMER_DIR DYAD_DTL_MODE=$DYAD_DTL_MODE flux mini run --exclusive -N 1 -n 1 valgrind --tool=memcheck --leak-check=yes --log-file=$(pwd)/valgrind.out \
