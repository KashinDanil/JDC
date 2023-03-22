#!/bin/bash

: '
CPU benchmark that loads cpu using cpuoccupy anomaly in HPAS
'
cpuloadavg() {
  cpuloadavgCall() {
    for ((i = 0 ; i < $loadAvg - 1 ; i++)); do
#        echo $i" $@ &"
        $@ &
      done
#      echo $((loadAvg-1))" $@"
      $@
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
  while [ -n "$1" ]
  do
    if [[ "$1" == "-l" ]] || [[ "$1" == "--loadavg" ]]; then
      #number of processes to run
      loadAvg=$2
      options=${options//$1 $2/}
    fi
    shift
  done

  echo "Expected load average is $loadAvg"

  command="$SCRIPT_DIR/src/HPAS/bin/hpas cpuoccupy $options"
  cpuloadavgCall $command
}