#!/bin/bash

: '
CPU benchmark that loads cpu using cpuoccupy anomaly in HPAS
'
cpuloadavg() {
  cpuloadavgCall() {
    for ((i = 0; i < $loadAvg; i++)); do
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
  loadAvg=10
  while [ -n "$1" ]; do
    if [[ "$1" == "-l" ]] || [[ "$1" == "--loadavg" ]]; then
      #number of processes to run
      loadAvg=$2
      #remove this option from running in cpuoccupy from hpas as it has no such parameter
      options=${options//$1 $2/}
    fi
    shift
  done

  echo "Expected load average is $loadAvg"

  command="$SCRIPT_DIR/src/HPAS/bin/hpas cpuoccupy $options"
  cpuloadavgCall $command
}
