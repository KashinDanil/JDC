#!/bin/bash

memfree() {
  memfreeCall() {
    for ((i = 0 ; i < 2 ; i++)); do
#        echo $i" $@ &"
        $@ &
      done
#      echo $((NUMBER_OF_CORES_PER_NODE-1))" $@"
      $@
  }
  local options=${@##*( )}
  if [[ ! "$options" == *"-p"* ]] && [[ ! "$options" == *"-s"* ]] && [[ ! "$options" == *"-d"* ]]; then
    #run for 10 minutes with default period and certain memory
    options=$options" -d 600 -s "$(($TOTAL_MEM_KB / 600 / 5 / 4))
  fi
  command="$SCRIPT_DIR/src/HPAS/bin/hpas memleak $options"
  memfreeCall $command
}