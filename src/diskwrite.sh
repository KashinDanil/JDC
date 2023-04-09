#!/bin/bash

: "
Disk write benchmark. Measures disk write speed. (src/Tests/IO/write.py).
"
diskwrite() {
  #get all function options
  local options=${@##*( )}
  local testOptions=""
  if [[ $options =~ ((d|duration) ([0-9]+)) ]]; then
        testOptions="${BASH_REMATCH[3]}"
    else
        #run for 10 minutes with default period and certain memory
        testOptions="600"
    fi
    if [[ $options =~ ((l|location) ([^[:space:]]+)) ]]; then
        testOptions=$testOptions" ${BASH_REMATCH[3]}"
    fi
    if [[ $options =~ ((h|help)) ]]; then
        testOptions=""
    fi
  command="python $SCRIPT_DIR/src/Tests/IO/write.py $testOptions"
#  echo $command
  $command
}