#!/bin/bash

# If an error occurs in any command,
# crash the job
set -e

######################
# GENERAL PARAMETERS #
######################

## Number of steps
NSTEPS=10
## Number of atoms
NATOMS=200
## Delay time
DELAY=0

##########################
# END GENERAL PARAMETERS #
##########################

## Number of ingesters and comsumers in total
## Hardcoded to 2 because this workflow only consists of
## a single producer and a single consumer
NCLIENTS=2

## Clean up
rm -rf __pycache__ log.*

source ./dtl_startup.sh

source ./run_prod.sh

source ./run_cons.sh

echo "-- Wait until all applications exit."
#wait

wait $producer_pid
echo "---- Producer exit."

wait $consumer_pid
echo "---- Consumer exit."

source ./dtl_shutdown.sh

echo "-- All applications exit."
