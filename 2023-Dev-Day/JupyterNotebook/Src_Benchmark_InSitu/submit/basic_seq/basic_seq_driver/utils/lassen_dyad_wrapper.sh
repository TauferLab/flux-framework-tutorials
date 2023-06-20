#!/bin/sh

set -e

dyad_wrapper_path=$1
shift
app=$1
shift

export LD_PRELOAD="$dyad_wrapper_path:$LD_PRELOAD"

exec $app "$@"
