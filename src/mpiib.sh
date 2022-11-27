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
    #10 minutes to run as default time
    options=$options" -i 2000000"
  fi
  if [[ ! "$options" == *"-x"* ]]; then
    #10 minutes to run as default time
    options=$options" -x 0"
  fi
  command="$SCRIPT_DIR/src/osu-micro-benchmarks/c/mpi/pt2pt/osu_bw $options"
  $command
}