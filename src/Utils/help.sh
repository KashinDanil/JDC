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
  -h, --help                      Shows this message
  -d, --duration                  The total duration (in seconds) (This option is used for all benchmarks
                                  except those that are independent of time)
\033[33mNote:
  The mpiib benchmark cannot use the -d, --duration options as it has no time limit.
  It transmits a certain amount of data through network a certain number of times and is independent of time.
\033[0m

Benchmarks parameters:
\033[32mcpuload\033[0m: \033[0;36m(In JD, should be equal to the max value of 'CPU user load in %')\033[0m
  -u, --utilization (100%)        The utilization (%) of one core.
  -d, --duration (-1.0)           The total duration (in seconds), -1 for infinite.

\033[32mcpuloadavg\033[0m: \033[0;36m(In JD, should be equal to the max value of 'LoadAVG')\033[0m
  -l, --loadavg                   Integer of desired load average
  -d, --duration (-1.0)           The total duration (in seconds), -1 for infinite.

\033[32mgpuload\033[0m: \033[0;36m(In JD, should be equal to the max value of 'GPU user load in %')\033[0m
  -u, --utilization (70)          The utilization (%).
  -d, --duration (600)            The total duration (in seconds).

\033[32miobandwidth\033[0m: \033[0;36m(In JD, should be equal to the max value of 'Lustre read bytes')\033[0m
  -s (1G)                         Block size (in bytes)
  -d, --duration (600)            The total duration (in seconds).

\033[32ml1cache\033[0m: \033[0;36m(In JD, should be equal to the average value of 'L1 cache misses')\033[0m
  -d, --duration (600)            The number of seconds to the program to work.

\033[32mllccache\033[0m: \033[0;36m(In JD, should be equal to the average value of 'Last level cache misses')\033[0m
  -d, --duration (600)            The number of seconds to the program to work.

\033[32mmemfree\033[0m: \033[0;36m(In JD, should be equal to the min value of 'Free memory')\033[0m
  -s, --size (20M)                The size (in bytes) of the array to be allocated.
  -d, --duration (-1.0)           The total duration (in seconds), -1 for infinite.
  -t, --start (120)               The time to wait (in seconds) before starting the anomaly and after finishing.
\033[33mAttention: There is no upper limit on allocated memory, so make sure you don't run out of memory\033[0m

\033[32mmpiib\033[0m: \033[0;36m(In JD, should be equal to the max value of 'MPI IB send/receive data')\033[0m
  -m, --message-size              [MIN:]MAX  set the minimum and/or the maximum message size to MIN and/or MAX
                                  bytes respectively. Examples:
                                  -m 2:128    // min = 2, max = 128
  -i, --iterations ITER           set iterations per message size to ITER (default 1000 for small
                                  messages, 100 for large messages)
  tiny                            Executes parameters -i 500000
  small                           Executes parameters -i 1000000
  medium (default)                Executes parameters -i 2000000
  large                           Executes parameters -i 3000000
\033[33mAttention: This test can only be run on two nodes.\033[0m

\033[32mmpipacks\033[0m: \033[0;36m(In JD, should be equal to the average value of 'MPI IB send/receive packets')\033[0m
  -d, --duration (600)            The number of seconds to the program to work.

\033[33mOnly the main options are shown here, if you want to see the full list of options, run the test name with the -h option.\033[0m


Default benchmarks parameters:
  cpuload -u 100 -d 600 -v                                  #uses 100% CPU usage for 10 minutes with verbose returns
  cpuloadavg -u 100 -d 600 -v -l 10                         #runs 10 processes loading the processor
  gpuload -u 70 -i 10000                                    #uses 70% GPU usage for 10000 iterations
  iobandwidth -s 1G -d 600 -v                               #creates a 1G file and repeatable copies it for 10 minutes
  l1cache -d 600                                            #makes L1 cache misses for 10 minutes
  llccache -d 600                                           #makes last level cache misses for 10 minutes
  memfree -t 120 -d 600 -s 'TOTAL_MEM_B / 600 / 50 / 4' -v  #uses 'TOTAL_MEM_B / 600 / 5 / 4' bytes for 10 minutes
  mpiib -m 16384:16384 medium -x 0                          #passes 16 bytes between two nodes 2 million times with no extra passes for warmup
  mpipacks -d 600                                         #sequentially passes 1 bytes between two nodes until the time is out
  "
}