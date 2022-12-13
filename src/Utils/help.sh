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

Benchmarks parameters:
cpuload:
  -u, --utilization (=100%)  The utilization (%) of one core.
  -d, --duration (=-1.0)     The total duration (in seconds), -1 for infinite.
  -t, --start (=0.0)         The time to wait (in seconds) before starting the anomaly.
  -v, --verbose              Prints execution information.
  -h, --help                 Prints this message

memfree:
  -s, --size (=20M)         The size (in bytes) of the array to be allocated.
  -p, --period (=0.2)       The time to wait (in seconds) between array allocations.
  -d, --duration (=-1.0)    The total duration (in seconds), -1 for infinite.
  -t, --start (=0.0)        The time to wait (in seconds) before starting the anomaly.
  -v, --verbose             Prints execution information.
  -h, --help                Prints this message.

mpiib:
  tiny                      Executes parameters -i 500000
  small                     Executes parameters -i 1000000
  medium                    Executes parameters -i 2000000
  large                     Executes parameters -i 3000000
  -b, --buffer-num            Use different buffers to perform data transfer (default single)
                              Options: single, multiple
  -m, --message-size          [MIN:]MAX  set the minimum and/or the maximum message size to MIN and/or MAX
                              bytes respectively. Examples:
                              -m 128      // min = default, max = 128
                              -m 2:128    // min = 2, max = 128
                              -m 2:       // min = 2, max = default
  -M, --mem-limit SIZE        set per process maximum memory consumption to SIZE bytes
                              (default 536870912)
  -i, --iterations ITER       set iterations per message size to ITER (default 1000 for small
                              messages, 100 for large messages)
  -x, --warmup ITER           set number of warmup iterations to skip before timing (default 200)
  -W, --window-size SIZE      set number of messages to send before synchronization (default 64)
  -c, --validation            Enable or disable validation. Disabled by default.
  -u, --validation-warmup ITR Set number of warmup iterations to skip before timing when validation is enabled (default 5)
  -D, --ddt [TYPE]:[ARGS]     Enable DDT support
                              -D cont                          //Contiguous
                              -D vect:[stride]:[block_length]  //Vector
                              -D indx:[ddt file path]          //Index
  -G, --graph tty,png,pdf    graph output of per iteration values.
  -h, --help                  print this help
  -v, --version               print version info

Default benchmarks parameters:
  cpuload -u 100 -d 600 -v                            #uses 100% CPU usage for 10 minutes with verbose returns
  memfree -d 600 -s 'TOTAL_MEM_B / 600 / 5 / 4' -v    #uses 'TOTAL_MEM_B / 600 / 5 / 4' bytes for 10 minutes
  mpiib -m 16384:16384 medium -x 0                #passes 16 bytes between two nodes 2 million times with no extra passes for warmup
"
}