#!/bin/bash

$SCRIPT_DIR/src/Utils/"getAvailableBenchmarks.sh"

: '
Returns additional help to sbatch-jdc.sh
'
sbatchHelp() {
  echo "
Each benchmark is launched by a separate task.

Sbatch-jdc parameters:
  --sbatch-params='sbatch parameters for sequential benchmarks' (By default runs --sbatch-params='-p test')
  --sbatch-script='sbatch script to run sequential benchmarks' (By default runs --sbatch-script='run')
  --sbatch-mpi-params='sbatch parameters for parallel benchmarks' (By default runs --sbatch-mpi-params='-p test -N 2')
  --sbatch-mpi-script='sbatch script to run parallel benchmarks' (By default runs --sbatch-mpi-script='ompi')
  -n number of iterations for every benchmark (By default every benchmark runs 1 time)
  --result-file='result-file-name' result filename (By default sbatch-jdc-{unix-time-in-milliseconds}.out)
  --dndoof do not delete the original output files
  "
  exit 0
}