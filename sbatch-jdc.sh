#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

#import function to get available benchmarks
. "$SCRIPT_DIR/src/Utils/getAvailableBenchmarks.sh"
#import help
. "$SCRIPT_DIR/src/Utils/help.sh"
. "$SCRIPT_DIR/src/Utils/sbatchHelp.sh"

availableBenchmarks=$(getAvailableBenchmarks)

sbatchParameters=''
sbatchScript='run' #use run as default script for benchmarks
sbatchMPIParameters=''
sbatchMPIScript='ompi' #use run as default script for mpi benchmarks
numberOfIterations=1

benchmarks=()

commonParams=()
while [ -n "$1" ]
do
  param=$1
  key=${param%%=*}
  value=${param#*=}

  if [[ $param = "-h" ]] || [[ $param = "--help" ]]; then
    help
    sbatchHelp
    exit 0
  fi

  if [[ $key = "--sbatch-params" ]]; then
    sbatchParameters=$value
    shift
    continue
  fi
  if [[ $key = "--sbatch-script" ]]; then
    sbatchScript=$value
    shift
    continue
  fi
  if [[ $key = "--sbatch-mpi-params" ]]; then
    sbatchMPIParameters=$value
    shift
    continue
  fi
  if [[ $key = "--sbatch-mpi-script" ]]; then
    sbatchMPIScript=$value
    shift
    continue
  fi
  if [[ $key = "-n" ]]; then
    if [[ $value != "-n" ]]
    then
      numberOfIterations=$value
    else
      re='^[0-9]+$'
      if ! [[ $2 =~ $re ]] ; then
        echo "Specify the number of iterations after using -n flag"
        exit
      else
        numberOfIterations=$2
        shift
      fi
    fi
    shift
    continue
  fi

  #add to every benchmark run all params that are not benchmarks
  if [[ ! " $availableBenchmarks " == *" $key "* ]]; then
    commonParams+=("$1")
    shift
    continue
  fi

  benchmarks+=("$key=$value")
  shift
done

if [[ ! "$sbatchParameters" == *"-p"* ]]; then
  #default queue is test for benchmarks
  sbatchParameters=$sbatchParameters" -p test"
fi

if [[ ! "$sbatchMPIParameters" == *"-p"* ]]; then
  #default queue is test for mpi benchmarks
  sbatchMPIParameters=$sbatchMPIParameters" -p test"
fi

if [[ ! "$sbatchMPIParameters" == *"-N"* ]]; then
  #mpi benchmarks requires at least(exactly) 2 threads
  sbatchMPIParameters=$sbatchMPIParameters" -N 2"
fi

#if there is no benchmarks chosen, use them all
if [ "${#benchmarks[@]}" -eq "0" ]; then
  echo "Use all benchmarks: $availableBenchmarks"
  IFS=' ' read -r -a benchmarks <<< $availableBenchmarks
  benchmarksCounter=${#benchmarks[@]}
fi

sleepTime=60
for ((i = 0; i < numberOfIterations; i++)); do
  for benchmark in "${benchmarks[@]}"
  do
    key=${benchmark%%=*}
    if [[ $key == *"mpi"* ]]; then
      #use mpi params to mpi benchmark
      command="sbatch ${sbatchMPIParameters} ${sbatchMPIScript} -- ./jdc.sh"
    else
      #use regular params to sequential benchmark
      command="sbatch ${sbatchParameters} ${sbatchScript} -- ./jdc.sh"
    fi

    while : ; do
      echo "$command '${benchmark}' ${commonParams[@]}"
      res=$($command "${benchmark}" ${commonParams[@]})
      echo $res
      [[ "$res" != *"Submitted batch job"* ]] || break
      echo "Was not able to submit a batch job. Waiting $sleepTime seconds"
      sleep $sleepTime
    done
  done
done