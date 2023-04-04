#!/bin/bash

: "
MPI InfiniBand benchmark that transmits 1 character through network until the time
is out therefore shows the number of sent/received packets as every send/recv is a single packet
"
mpipacks() {
  #get all function options
  local options=${@##*( )}
  local testOptions=""
  if [[ $options =~ ((d|duration) ([0-9]+)) ]]; then
      testOptions="$((BASH_REMATCH[3]))"
  else
      #run for 10 minutes with default period and certain memory
      testOptions="600"
  fi
  if [[ $options =~ ((h|help)) ]]; then
      testOptions=""
  fi
  command="$SCRIPT_DIR/src/Tests/MPI/mpipacks $testOptions"
#  echo $command
  $command
}