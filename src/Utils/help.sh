#!/bin/bash

$SCRIPT_DIR/src/Utils/"getAvailableBenchmarks.sh"

: '
Returns help
'
help() {
  echo "Input a valid benchmark name:"
  local benchmarks=$(getAvailableBenchmarks)
  echo -e "\033[32m"${benchmarks//" "/"\033[0m \033[32m"}"\033[0m"
  echo "And optionally any parameters to them (if you know what you are doing)"
  exit 0
}