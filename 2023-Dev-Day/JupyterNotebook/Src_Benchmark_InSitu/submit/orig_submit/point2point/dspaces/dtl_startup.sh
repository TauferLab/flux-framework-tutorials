#!/bin/bash

##################
# DTL PARAMETERS #
##################

## A4MD installation directory
INSTALL_PREFIX=$SCRATCH/application/a4md/a4md/
## Number of nodes for the DataSpaces servers
## When changing this value, make sure that
## the number of nodes requested in the submission
## script is equal to NSERVER_NODES + 2
NSERVER_NODES=1
## Number of DataSpaces servers
NSERVERS=1
## Lock type
LOCK=2

######################
# END DTL PARAMETERS #
######################

rm -rf conf dataspaces.conf

BINDIR=$INSTALL_PREFIX/bin

## Create dataspaces configuration file
echo "## Config file for DataSpaces
ndim = 1
dims = 1024
max_versions = 1
max_readers = 1
lock_type =" $LOCK > dataspaces.conf

## Run DataSpaces servers
echo "-- Start DataSpaces server on $NSERVERS PEs"
server_cmd="flux mini run -N $NSERVER_NODES -n $NSERVERS \
    $BINDIR/dataspaces_server -s $NSERVERS -c $NCLIENTS"
echo ${server_cmd}
${server_cmd} &> log.server &
server_pid=$!

## Give some time for the servers to load and startup
sleep 1s
while [ ! -f conf ]; do
    echo "-- File conf is not yet available from server. Sleep more"
    sleep 1s
done
sleep 3s  # wait server to fill up the conf file
## Export the main server config to the environment
while read line; do
    export set "${line}"
done < conf
echo "-- Dataspaces Servers initialize successfully"
echo "-- DataSpaces IDs: P2TNID = $P2TNID   P2TPID = $P2TPID"
