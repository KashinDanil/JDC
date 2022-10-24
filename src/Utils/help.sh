#!/bin/bash

$SCRIPT_DIR/src/Utils/"getAvailableBenchmarks.sh"

help() {
  echo "Input a valid benchmark name:"
  local benchmarks=$(getAvailableBenchmarks)
  echo -e "\033[32m"${benchmarks//" "/"\033[0m \033[32m"}"\033[0m"
  exit 0
}