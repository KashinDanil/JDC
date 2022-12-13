#!/bin/bash

: '
MPI InfiniBand benchmark that transmits a certain amount of data
through network a certain number of times and is independent of time.
'
mpiib() {
  #get all function options
  local options=${@##*( )}
  if [[ ! "$options" == *"-m"* ]]; then
    #use 100% of cpu on one node as default cpu load
    options=$options" -m 16384:16384"
  fi
  if [[ ! "$options" == *"-i"* ]]; then
    if [[ "$options" == *"tiny"* ]]; then
      #2000000 iterations, which is around 2 minutes
      options="${options/tiny/""} -i 500000"
    elif [[ "$options" == *"small"* ]]; then
      #2000000 iterations, which is around 15 minutes
      options="${options/small/""} -i 1000000"
    elif [[ "$options" == *"large"* ]]; then
      #2000000 iterations, which is around 15 minutes
      options="${options/large/""} -i 3000000"
    else #medium
      #2000000 iterations, which is around 10 minutes
      options="${options/medium/""} -i 2000000"
    fi
  fi
  if [[ ! "$options" == *"-x"* ]]; then
    #10 minutes to run as default time
    options=$options" -x 0"
  fi
  command="$SCRIPT_DIR/src/osu-micro-benchmarks/c/mpi/pt2pt/osu_bw $options"
  $command
}