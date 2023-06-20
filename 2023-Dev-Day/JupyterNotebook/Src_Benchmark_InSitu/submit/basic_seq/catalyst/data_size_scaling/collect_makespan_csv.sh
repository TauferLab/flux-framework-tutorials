#!/bin/bash

first_file=true

for file in $(pwd)/out/**/makespan.txt; do
    if $first_file; then
        cat $file > $(pwd)/makespan.csv
        echo >> $(pwd)/makespan.csv
        first_file=false
    else
        tail -n +2 $file >> $(pwd)/makespan.csv
        echo >> $(pwd)/makespan.csv
    fi
done
