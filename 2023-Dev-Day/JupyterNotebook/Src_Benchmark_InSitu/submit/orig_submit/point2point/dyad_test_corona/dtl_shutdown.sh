#!/bin/bash

echo "Checking for files on Flux ranks (after run)"
echo "============================================"
echo
echo "Node 0: $(flux exec -r 0 ls $PRODUCER_DIR/group0 | wc -l)"
echo "Node 1: $(flux exec -r 1 ls $PRODUCER_DIR/group0 | wc -l)"

flux exec -r all flux module unload dyad

flux kvs namespace remove $KVS_NAMESPACE
