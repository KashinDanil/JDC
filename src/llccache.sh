#!/bin/bash

: "
LLC cache test addresses to an array's element that is not in LLC cache in a cycle for a specific amount of time.
API for the test (src/Tests/Cache/LLCCache.c) because it should be the simplest and cannot have hard arguments structure.
"
llccache() {
  #get all function options
  local options=${@##*( )}
  local testOptions=""
  #rearrange the options since the test reads the parameters in particular order
  #duration is the first and only option in the test
  if [[ $options =~ ((d|duration) ([0-9]+)) ]]; then
    testOptions="$((BASH_REMATCH[3]))"
  else
    #run for 10 minutes with default period and certain memory
    testOptions="600"
  fi
  #if there is a -h or --help option, then show the help message and stop running
  if [[ $options =~ ((h|help)) ]]; then
    echo -e "\033[32mllccache\033[0m: \033[0;36m(In JD, should be equal to the average value of 'Last level cache misses')\033[0m
  -d, --duration (600)            The number of seconds to the program to work."
    return
  fi
  command="$SCRIPT_DIR/src/Tests/Cache/LLCCache $testOptions"
  $command
}
