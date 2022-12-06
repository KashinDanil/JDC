#!/bin/bash

$SCRIPT_DIR/src/Utils/"getAvailableBenchmarks.sh"

: '
Returns additional help to sbatch-jdc.sh
'
sbatchHelp() {
  echo "
Each benchmark is launched by a separate task.

Sbatch parameters:
  --sbatch-params='sbatch parameters for sequential benchmarks' (By default runs --sbatch-params='-p test')
  --sbatch-script='sbatch script to run sequential benchmarks' (By default runs --sbatch-script='run')
  --sbatch-mpi-params='sbatch parameters for parallel benchmarks' (By default runs --sbatch-mpi-params='-p test -N 2')
  --sbatch-mpi-script='sbatch script to run parallel benchmarks' (By default runs --sbatch-mpi-script='ompi')
  -n number of iterations for every benchmark (By default every benchmark runs 1 time)

Examples:
  ./sbatch-jdc.sh                                         #runs all benchmarks one time
  ./sbatch-jdc.sh -n 3                                    #runs all benchmarks three times
  ./sbatch-jdc.sh cpuload                                 #runs only cpuload with default parameters
  ./sbatch-jdc.sh cpuload='-u 50 -d 900' -n 2             #runs only cpuload using 50% CPU usage for 15 minutes two times
  ./sbatch-jdc.sh mpiib='-x 0 -i 3000000' memfree         #runs mpiib with default amount of passing data for 3 millions times without warmup and memfree with default parameters
  ./sbatch-jdc.sh cpuload='-h' memfree='-h' mpiib='-h'    #runs mpiib with default amount of passing data for 3 millions times without warmup and memfree with default parameters
  "
  exit 0
}