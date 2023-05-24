#!/bin/bash

#important constants#
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

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
#common parameters used in all benchmarks (-d for duration)
commonParamKeys=("-d", "--duration")
commonParams=()
while [ -n "$1" ]; do
  param=$1

  if [[ $param == "-h" ]] || [[ $param == "--help" ]]; then
    help
    exit 0
  fi

  #check if common parameters are used
  if [[ " ${commonParamKeys[*]} " =~ "$1" ]]; then
    commonParams+=("$1 $2")
    shift 2
    continue
  fi

  benchmark=${param%%=*}

  if [[ ! " $availableBenchmarks " == *" $benchmark "* ]]; then
    #skipping benchmarks which are not in the list
    echo -e "There is no \033[32m'$benchmark'\033[0m benchmark"
    shift
    continue
  fi

  benchmarks[$benchmarksCounter]=$benchmark
  parameters[$benchmarksCounter]=${param#*=}
  if [[ ! "$param" == *"="* ]]; then
    parameters[$benchmarksCounter]=''
  fi

  ((benchmarksCounter = benchmarksCounter + 1))

  shift
done

#if there is no benchmarks chosen, use them all
if [ "${#benchmarks[@]}" -eq "0" ]; then
  echo "Use all benchmarks: $availableBenchmarks"
  IFS=' ' read -r -a benchmarks <<<$availableBenchmarks
  benchmarksCounter=${#benchmarks[@]}
fi

#run chosen benchmarks using all parameters
for ((bn = 0; bn < $benchmarksCounter; bn++)); do
  echo -e "Run benchmark: \033[32m"${benchmarks[$bn]}"\033[0m" ${parameters[$bn]##*( )} ${commonParams[@]}
  ${benchmarks[$bn]} ${parameters[$bn]} ${commonParams[@]}
done
