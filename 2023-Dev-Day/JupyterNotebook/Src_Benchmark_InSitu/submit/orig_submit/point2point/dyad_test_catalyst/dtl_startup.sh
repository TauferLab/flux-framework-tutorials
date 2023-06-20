#!/bin/bash

##################
# DTL PARAMETERS #
##################

# Flux KVS namespace to be used by DYAD
KVS_NAMESPACE="dyad_pipeline1"
# Directory where the producer will store data
PRODUCER_DIR="/tmp/lumsden1/dyad_pipeline1"
# Directory where the consumer will store data
CONSUMER_DIR="/tmp/lumsden1/dyad_pipeline1"
# Data transport mode for DYAD
# DYAD_DTL_MODE="FLUX_RPC"
DYAD_DTL_MODE="UCX"

######################
# END DTL PARAMETERS #
######################

BINDIR=$INSTALL_PREFIX/bin
LIBDIR=$INSTALL_PREFIX/lib64
DYAD_WRAPPER_LIB=$LIBDIR/dyad_wrapper.so
DYAD_MODULE=$LIBDIR/dyad.so

for broker_rank in $(seq 0 1); do
    if flux exec -r $broker_rank test ! -d $PRODUCER_DIR; then
        mkdir -p $PRODUCER_DIR/group0
        echo "Created $PRODUCER_DIR/group0 on broker $broker_rank"
    else
        echo "$PRODUCER_DIR/group0 already exists on broker $broker_rank"
    fi
    if flux exec -r $broker_rank test ! -d $CONSUMER_DIR; then
        mkdir -p $CONSUMER_DIR/group0
        echo "Created $CONSUMER_DIR/group0 on broker $broker_rank"
    else
        echo "$CONSUMER_DIR/group0 already exists on broker $broker_rank"
    fi
done
echo "Checking for files on Flux ranks (before run)"
echo "============================================"
echo
echo "Node 0: $(flux exec -r 0 ls $PRODUCER_DIR/group0 | wc -l)"
echo "Node 1: $(flux exec -r 1 ls $PRODUCER_DIR/group0 | wc -l)"

if flux kvs namespace list | grep -q "$KVS_NAMESPACE"; then
    flux kvs namespace remove $KVS_NAMESPACE
fi

flux kvs namespace create $KVS_NAMESPACE

if flux exec -r all flux module list | grep -q "dyad"; then
    flux exec -r all flux module unload dyad
fi

flux exec -r all flux module load $DYAD_MODULE ${PRODUCER_DIR} ${DYAD_DTL_MODE}
