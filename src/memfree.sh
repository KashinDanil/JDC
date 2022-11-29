#!/bin/bash

: '
Memory benchmark that uses RAM using memleak anomaly in HPAS
'
memfree() {
  memfreeCall() {
    for ((i = 0 ; i < 2 ; i++)); do
#        echo $i" $@ &"
        $@ &
      done
#      echo $((NUMBER_OF_CORES_PER_NODE-1))" $@"
      $@
  }

  #get all function options
  local options=${@##*( )}
  if [[ ! "$options" == *"-p"* ]] && [[ ! "$options" == *"-s"* ]] && [[ ! "$options" == *"-d"* ]]; then
    #run for 10 minutes with default period and certain memory
    options=$options" -d 600 -s "$(($TOTAL_MEM_B / 600 / 5 / 4))
  fi
  if [[ ! "$options" == *"-v"* ]]; then
    #show verbose data
    options=$options" -v"
  fi
  command="$SCRIPT_DIR/src/HPAS/bin/hpas memleak $options"
  memfreeCall $command
}