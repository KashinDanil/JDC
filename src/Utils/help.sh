#!/bin/bash

$SCRIPT_DIR/src/Utils/"getAvailableBenchmarks.sh"

: '
Returns help
'
help() {
  echo "Input a valid benchmark name (and optionally parameters to them):"
  local benchmarks=($(getAvailableBenchmarks))
  for benchmark in "${benchmarks[@]}"
  do
    behavior=''
    if [[ $benchmark == *"mpi"* ]]; then
      behavior='parallel, requires an mpi run'
    else
      behavior='sequential'
    fi
    echo -e "  \033[32m"${benchmark}"\033[0m[='parameters'] (${behavior})"
  done
  echo "Or input no benchmark names in that case all of them will be executed"
  echo "There are also additional parameters that are used for every selected benchmark:
  '-d' execution time (by default  every benchmark has it's own execution time)"
}