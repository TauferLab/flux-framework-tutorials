#!/bin/bash

PRODUCER_EXEC=$BINDIR/pipeline1_producer

echo "-- Start producer application"
producer_cmd="LD_PRELOAD=$DYAD_WRAPPER_LIB DYAD_KVS_NAMESPACE=$KVS_NAMESPACE \
    DYAD_PATH_PRODUCER=$PRODUCER_DIR DYAD_DTL_MODE=$DYAD_DTL_MODE UCX_LOG_LEVEL=diag \
    flux mini run --exclusive -N 1 -n 1 \
    $PRODUCER_EXEC $SCRIPT_DIR/load.py extract_frame $NSTEPS $NATOMS $DELAY \
    -g 0 -c $NSTEPS -d $PRODUCER_DIR"
echo ${producer_cmd}
eval ${producer_cmd} &> $OUT_DIR/log.producer &
producer_pid=$!
