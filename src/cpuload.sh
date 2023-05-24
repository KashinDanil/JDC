#!/bin/bash

: '
CPU benchmark that loads cpu using cpuoccupy anomaly in HPAS
'
cpuload() {
  cpuloadCall() {
    for ((i = 0; i < NUMBER_OF_CORES_PER_NODE; i++)); do
      #run specific number of processes
      $@ &
      #remember the IDs of all processes
      pids[$i]=$!
    done
    #wait till every process is finished
    for ((i = 0; i < NUMBER_OF_CORES_PER_NODE; i++)); do
      wait ${pids[$i]}
    done
  }

  #get all function options
  local options=${@##*( )}
  if [[ ! "$options" == *"-u"* ]]; then
    #use 100% of cpu on one node as default cpu load
    options=$options" -u 100"
  fi
  if [[ ! "$options" == *"-d"* ]]; then
    #10 minutes to run as default time
    options=$options" -d 600"
  fi
  if [[ ! "$options" == *"-v"* ]]; then
    #always show verbose data for free memory knowledge
    options=$options" -v"
  fi
  command="$SCRIPT_DIR/src/HPAS/bin/hpas cpuoccupy $options"
  cpuloadCall $command
}
