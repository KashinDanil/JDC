#!/bin/bash

: '
Memory benchmark that uses RAM using memleak anomaly in HPAS
'
memfree() {
  #get all function options
  local options=${@##*( )}
  if [[ ! "$options" == *"-p"* ]] && [[ ! "$options" == *"-s"* ]] && [[ ! "$options" == *"-d"* ]]; then
    #run for 10 minutes with default period and certain memory
    options=$options" -d 600 -s "$(($TOTAL_MEM_B / 600 / 50 / 4))
  fi
  if [[ ! "$options" == *"-v"* ]]; then
    #show verbose data
    options=$options" -v"
  fi
  command="$SCRIPT_DIR/src/HPAS/bin/hpas memleak $options"
#  echo $command
  $command
}