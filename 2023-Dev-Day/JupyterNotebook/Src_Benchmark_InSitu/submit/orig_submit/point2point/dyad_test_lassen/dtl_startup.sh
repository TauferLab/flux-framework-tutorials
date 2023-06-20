#!/bin/bash

##################
# DTL PARAMETERS #
##################

# Flux KVS namespace to be used by DYAD
KVS_NAMESPACE="dyad_pipeline1"
# Directory where the producer will store data
PRODUCER_DIR="/tmp/dyad_pipeline1"
# Directory where the consumer will store data
CONSUMER_DIR="/tmp/dyad_pipeline1"
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

if [ ! -d $PRODUCER_DIR ]; then
    mkdir -p $PRODUCER_DIR/group0
fi
if [ ! -d $CONSUMER_DIR ]; then
    mkdir -p $CONSUMER_DIR/group0
fi
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
