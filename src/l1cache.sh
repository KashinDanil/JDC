#!/bin/bash

: "
L1 cache test addresses to an array's element that is not in l1 cache in a cycle for a specific amount of time.
API for the test (src/Tests/Cache/L1Cache.c) because it should be the simplest and cannot have hard arguments structure.
"
l1cache() {

  #get all function options
  local options=${@##*( )}
  local testOptions=""
  if [[ $options =~ ((i|iterations) ([0-9]+)) ]]; then
      testOptions="${BASH_REMATCH[3]}"
  else
      #use 1000000000 iterations in l1 cache miss test
      options=$options" -i 1000000000"
      testOptions="1000000000"
  fi
  if [[ $options =~ ((d|duration) ([0-9]+)) ]]; then
      testOptions=$testOptions" $((BASH_REMATCH[3]/60))"
  else
      #run for 10 minutes with default period and certain memory
      options=$options" -d 600"
      testOptions=$testOptions" 10"
  fi
  if [[ $options =~ ((h|help)) ]]; then
      testOptions=""
  fi
  command="$SCRIPT_DIR/src/Tests/Cache/L1Cache $options"
  echo $command
  command="$SCRIPT_DIR/src/Tests/Cache/L1Cache $testOptions"
  $command
}