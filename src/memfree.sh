#!/bin/bash

: '
Memory benchmark that uses RAM using memleak anomaly in HPAS
'
memfree() {
  #get all function options
  local options=${@##*( )}
  if [[ ! "$options" == *"-s"* ]]; then
    #use 100% of cpu on one node as default cpu load
    options=$options" -s "$(($TOTAL_MEM_B / 600 / 50 / 4))
  fi
  if [[ ! "$options" == *"-d"* ]]; then
    #use 100% of cpu on one node as default cpu load
    options=$options" -d 600"
  fi
  if [[ ! "$options" == *"-v"* ]]; then
    #show verbose data
    options=$options" -v"
  fi
  if [[ ! "$options" == *"-t"* ]]; then
    #waiting time before and after running
    options=$options" -t 120"
  fi
  command="$SCRIPT_DIR/src/HPAS/bin/hpas memleak $options"
#  echo $command
  $command
}