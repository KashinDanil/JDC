#!/bin/bash

: "
LLC cache test addresses to an array's element that is not in LLC cache in a cycle for a specific amount of time.
API for the test (src/Tests/Cache/LLCCache.c) because it should be the simplest and cannot have hard arguments structure.
"
llccache() {
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
  command="$SCRIPT_DIR/src/Tests/Cache/LLCCache $testOptions"
#  echo $command
  $command
}