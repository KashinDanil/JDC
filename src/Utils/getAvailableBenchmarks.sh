#!/bin/bash

: '
Returns all available benchmarks
'
getAvailableBenchmarks() {
  cd $SCRIPT_DIR/src/ #In order to not delete the path to the folder
  local benchmarks=$(ls *.sh)
  cd ..
  echo ${benchmarks//".sh"/""}
}