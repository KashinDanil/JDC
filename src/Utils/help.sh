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
  echo -e "Or input no benchmark names in that case all of them will be executed.


jdc.sh parameters:
  -h shows this message
  -d duration time in seconds (This option is used for all benchmarks except those that are independent of time)
Note:
  The mpiib benchmark cannot use the -d option as it has no time limit.
  It transmits a certain amount of data through network a certain number of times
  and is independent of time.
  The gpuload test also is independent of the -d option as it runs certain number of iterations.


Benchmarks parameters:
\033[32mcpuload\033[0m: \033[0;36m(In JD, should be equal to the max value of 'CPU user load in %')\033[0m
  -u, --utilization (100%)        The utilization (%) of one core.
  -d, --duration (-1.0)           The total duration (in seconds), -1 for infinite.

\033[32mcpuloadavg\033[0m: \033[0;36m(In JD, should be equal to the max value of 'LoadAVG')\033[0m
  -l, --loadavg                   Integer of desired load average
  -d, --duration (-1.0)           The total duration (in seconds), -1 for infinite.

\033[32mmemfree\033[0m: \033[0;36m(In JD, should be equal to the min value of 'Free memory')\033[0m
  -s, --size (20M)                The size (in bytes) of the array to be allocated.
  -d, --duration (-1.0)           The total duration (in seconds), -1 for infinite.
\033[33mAttention: There is no upper limit on allocated memory, so make sure you don't run out of memory\033[0m

\033[32mmpiib\033[0m: \033[0;36m(In JD, should be equal to the max value of 'MPI IB send/receive data')\033[0m
  -m, --message-size              [MIN:]MAX  set the minimum and/or the maximum message size to MIN and/or MAX
                                  bytes respectively. Examples:
                                  -m 128      // min = default, max = 128
                                  -m 2:128    // min = 2, max = 128
                                  -m 2:       // min = 2, max = default
  -i, --iterations ITER           set iterations per message size to ITER (default 1000 for small
                                  messages, 100 for large messages)
  tiny                            Executes parameters -i 500000
  small                           Executes parameters -i 1000000
  medium                          Executes parameters -i 2000000
  large                           Executes parameters -i 3000000

\033[32ml1cache\033[0m: \033[0;36m(In JD, should be equal to the max value of 'L1 cache misses' multiplied by the number of seconds of work)\033[0m
  -i, --iterations (1000000000)   The number of iterations per minute (Each iteration equals 3 misses).
  -d, --duration (600)            The number of seconds to the program to work.

\033[32mgpuload\033[0m: \033[0;36m(In JD, should be equal to the max value of 'GPU user load in %')\033[0m
  -u, --utilization (70)          The utilization (%).
  -d, --duration (600)            The total duration (in seconds).

\033[33mOnly the main options are shown here, if you want to see the full list of options, run the test name with the -h option.\033[0m


Default benchmarks parameters:
  cpuload -u 100 -d 600 -v                            #uses 100% CPU usage for 10 minutes with verbose returns
  cpuloadavg -u 100 -d 600 -v -l 10                   #runs 10 processes loading the processor
  gpuload -u 70 -i 10000                              #uses 70% GPU usage for 10000 iterations
  l1cache -i 1000000000 -d 600                        #runs 1 billion iterations every minute for 10 minutes
  memfree -d 600 -s 'TOTAL_MEM_B / 600 / 50 / 4' -v   #uses 'TOTAL_MEM_B / 600 / 5 / 4' bytes for 10 minutes
  mpiib -m 16384:16384 medium -x 0                    #passes 16 bytes between two nodes 2 million times with no extra passes for warmup
  "
}