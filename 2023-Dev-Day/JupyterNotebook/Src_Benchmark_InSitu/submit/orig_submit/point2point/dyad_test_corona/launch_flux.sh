#!/bin/bash
# flux: -N 2
# flux: --exclusive
# flux: -t 30
# flux: --output=dyad_benchmark_test_p1.out
# flux: --error=dyad_benchmark_test_p1.err
# flux: --setattr=system.bank=guests

./dyad.sh
