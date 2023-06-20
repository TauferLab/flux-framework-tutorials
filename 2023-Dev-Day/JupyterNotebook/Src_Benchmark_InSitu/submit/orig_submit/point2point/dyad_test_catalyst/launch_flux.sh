#!/bin/bash
# flux: -N 2
# flux: --exclusive
# flux: -t 30
# flux: --output=dyad_benchmark_test_p1.out
# flux: --error=dyad_benchmark_test_p1.err
# flux: --setattr=system.bank=guests
# flux: --log=/g/g90/lumsden1/ws/insitu_benchmark/Src_Benchmark_InSitu/submit/point2point/dyad_test_corona/flux.log
# flux: --log-stderr=/g/g90/lumsden1/ws/insitu_benchmark/Src_Benchmark_InSitu/submit/point2point/dyad_test_corona/flux.log

./dyad.sh
