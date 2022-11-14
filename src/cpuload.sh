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
  command="$SCRIPT_DIR/src/HPAS/bin/hpas cpuoccupy $options"
  cpuloadCall $command
}