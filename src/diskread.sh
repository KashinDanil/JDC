#!/bin/bash

: "
Disk read benchmark. Measures disk read speed. (src/Tests/IO/read.py).
"
diskread() {
  #get all function options
  local options=${@##*( )}
  local testOptions=""
  #rearrange the options since the test reads the parameters in particular order
  #duration is the first option in the test
  if [[ $options =~ ((d|duration) ([0-9]+)) ]]; then
    testOptions="${BASH_REMATCH[3]}"
  else
    #run for 10 minutes with default period and certain memory
    testOptions="600"
  fi
  #temporary directory location is the second option in the test
  if [[ $options =~ ((l|location) ([^[:space:]]+)) ]]; then
    testOptions=$testOptions" ${BASH_REMATCH[3]}"
  fi
  #if there is a -h or --help option, then show the help message and stop running
  if [[ $options =~ ((h|help)) ]]; then
    echo -e "\033[32mdiskread\033[0m: \033[0;36m(In JD, should be equal to the average value of 'Lustre read bytes')\033[0m
  -d, --duration (600)            The total duration (in seconds).
  -l (.)                          Location of output folder"
    return
  fi
  command="python $SCRIPT_DIR/src/Tests/IO/read.py $testOptions"
  $command
}
