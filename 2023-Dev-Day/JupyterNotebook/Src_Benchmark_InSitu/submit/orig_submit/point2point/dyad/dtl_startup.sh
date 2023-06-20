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

######################
# END DTL PARAMETERS #
######################

BINDIR=$INSTALL_PREFIX/bin
LIBDIR=$INSTALL_PREFIX/lib64
DYAD_WRAPPER_LIB=$LIBDIR/dyad_wrapper.so
DYAD_MODULE=$LIBDIR/dyad.so

if [ ! -d $PRODUCER_DIR ]; then
    mkdir -p $PRODUCER_DIR
fi
if [ ! -d $CONSUMER_DIR ]; then
    mkdir -p $CONSUMER_DIR
fi

flux kvs namespace create $KVS_NAMESPACE

flux exec -r all flux module load $DYAD_MODULE ${PRODUCER_DIR}
