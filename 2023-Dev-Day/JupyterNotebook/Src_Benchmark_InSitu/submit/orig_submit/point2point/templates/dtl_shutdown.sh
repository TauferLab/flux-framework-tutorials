#!/bin/bash

if [ ! -z ${server_pid+x} ]; then
    kill -9 ${server_pid}
fi

# Add any code needed to shutdown the tool's service
# here. By default, this script will simply kill the
# service's process if the service's PID is obtained
# in dtl_startup.sh
