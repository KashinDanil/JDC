#!/bin/bash

: '
MPI InfiniBand benchmark that transmits a certain amount of data
through network a certain period of time.
'
mpiib2() {
  #get all function options
  local options=${@##*( )}
  if [[ ! "$options" == *"-d"* ]]; then
    #10 minutes to run as default time
    options=$options" -d 600"
  fi
  command="$SCRIPT_DIR/src/HPAS/bin/hpas netoccupy $options"
  $command
}