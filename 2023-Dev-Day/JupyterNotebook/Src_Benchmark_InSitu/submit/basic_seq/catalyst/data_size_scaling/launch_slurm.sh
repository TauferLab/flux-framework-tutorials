#!/bin/bash
#SBATCH -N 2
#SBATCH -A guests
#SBATCH -J insitu_benchmark_basic_sequential
#SBATCH -o insitu_benchmark_basic_sequential.out
#SBATCH -e insitu_benchmark_basic_sequential.err
#SBATCH -t 120

config_cutoff=""

config_files=()
for file in ./*.toml; do
    natoms=$(echo "$file" | grep -o '[0-9]\+')
    if test ! -z "$config_cutoff"; then
        if test "$natoms" -ge "$config_cutoff"; then
            echo "Will skip run with natoms = $natoms due to cutoff of $config_cutoff"
            continue
        fi
    fi
    config_files+=( $file )
done

for config_file in ${config_files[@]}; do
    natoms=$(echo "$config_file" | grep -o '[0-9]\+')
    echo "Starting run for $natoms atoms"
    FLUX_STARTUP_ARGS="-o,-S,log-filename=$(pwd)/flux-$natoms-atoms.log"
    srun --pty --mpi=pmi2 -N 2 flux start $FLUX_STARTUP_ARGS \
        /collab/usr/gapps/python/build/spack-toss3.4/opt/spack/linux-rhel7-ivybridge/gcc-4.9.3/python-3.8.2-6me27g5yfvrxpcsemax25kovzjbf22vt/bin/python3 \
        /g/g90/lumsden1/ws/insitu_benchmark/Src_Benchmark_InSitu/submit/basic_seq/driver.py dyad $config_file
    echo "Ending run for $natoms atoms"
    echo
done
