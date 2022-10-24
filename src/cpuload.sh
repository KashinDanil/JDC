#!/bin/bash

cpuload() {
  cpuloadCall() {
    for ((i = 0 ; i < NUMBER_OF_CORES_PER_NODE - 1 ; i++)); do
#        echo $i" $@ &"
        $@ &
      done
#      echo $((NUMBER_OF_CORES_PER_NODE-1))" $@"
      $@
  }

  local options=${@##*( )}
  if [[ ! "$options" == *"-u"* ]]; then
    #use 100% of cpu on one node
    options=$options" -u 100"
  fi
  if [[ ! "$options" == *"-d"* ]]; then
    #5 minutes to run
    options=$options" -d 300"
  fi
  command="$SCRIPT_DIR/src/HPAS-master/bin/hpas cpuoccupy $options"
  cpuloadCall $command
}