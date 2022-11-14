#!/bin/bash

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
  command="$SCRIPT_DIR/src/osu/mpi/pt2pt2/osu_bw $options"
  $command
}