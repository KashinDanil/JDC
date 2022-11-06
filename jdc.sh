#!/bin/bash

#important constants#
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

#import utils
. "$SCRIPT_DIR/config.sh"
for script in $SCRIPT_DIR/src/Utils/*.sh; do
  . "$script"
done
for script in $SCRIPT_DIR/src/*.sh; do
  . "$script"
done

availableBenchmarks=$(getAvailableBenchmarks)

#divide arguments by benchmark names and options
parameters=()
benchmarks=()
benchmarksCounter=0
while [ -n "$1" ]
do
  param=$1

  if [[ $param = "-h" ]] || [[ $param = "--help" ]]; then
    help
    exit 0
  fi

  benchmark=${param%%=*}

  if [[ ! " $availableBenchmarks " == *" $benchmark "* ]]; then
    echo -e "There is no \033[32m'$benchmark'\033[0m benchmark"
    shift
    continue
  fi

  benchmarks[$benchmarksCounter]=$benchmark
  parameters[$benchmarksCounter]=${param#*=}
  if [[ ! "$param" == *"="* ]]; then
    parameters[$benchmarksCounter]=''
  fi

  ((benchmarksCounter=benchmarksCounter+1))

  shift
done

#if there is no benchmarks chosen, use them all
if [ "${#benchmarks[@]}" -eq "0" ]; then
  echo "Use all benchmarks: $availableBenchmarks"
  IFS=' ' read -r -a benchmarks <<< $availableBenchmarks
  benchmarksCounter=${#benchmarks[@]}
fi

#run chosen benchmarks using all parameters
for (( i=0; i < $benchmarksCounter; i++ )) do
  echo -e "Run benchmark: \033[32m"${benchmarks[$i]}"\033[0m" ${parameters[$i]##*( )}
  ${benchmarks[$i]} ${parameters[$i]}
done