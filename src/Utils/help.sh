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
  echo "Or input no benchmark names in that case all of them will be executed.
  -h shows this message."
  echo "There are also additional parameters that are used for every selected benchmark:
  -d duration time in seconds (By default every benchmark has it's own duration time)"
  echo "Note:
  The mpiib benchmark cannot use the -d option as it has no time limit.
  It transmits a certain amount of data through network a certain number of times
  and is independent of time.

Default benchmarks parameters:
  cpuload -u 100 -d 600 -v                            #uses 100% CPU usage for 10 minutes with verbose returns
  memfree -d 600 -s 'TOTAL_MEM_B / 600 / 5 / 4' -v    #uses 'TOTAL_MEM_B / 600 / 5 / 4' bytes for 10 minutes
  mpiib -m 16384:16384 -i 2000000 -x 0                #passes 16 bytes between two nodes 2 million times with no extra passes for warmup"
}