#!/bin/bash

$SCRIPT_DIR/src/Utils/"getAvailableBenchmarks.sh"

: '
Returns additional help to sbatch-jdc.sh
'
sbatchHelp() {
  echo "
Sbatch parameters:
  --sbatch-params='sbatch parameters for sequential benchmarks' (By default runs --sbatch-params='-p test')
  --sbatch-script='sbatch script to run sequential benchmarks' (By default runs --sbatch-script='run')
  --sbatch-mpi-params='sbatch parameters for parallel benchmarks' (By default runs --sbatch-mpi-params='-p test -N 2')
  --sbatch-mpi-script='sbatch script to run parallel benchmarks' (By default runs --sbatch-mpi-script='ompi')
  "
  exit 0
}