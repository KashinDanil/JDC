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

#divide arguments by benchmark names and options
read benchmarks options <<<$(divideBenchmarksAndOptions $@)
benchmarks=${benchmarks/"deleteMe,"/""}
benchmarks=${benchmarks/"deleteMe"/""}
if [ "$benchmarks" == "help" ]; then
  #had to use this crutch, cos command exit works in file not in process. Have no idea why it's so
  help
  exit
fi
IFS=',' read -r -a benchmarks <<< "$benchmarks"

#if there is no benchmark chosen, use them all
if [ "${#benchmarks[@]}" -eq "0" ]; then
  availableBenches=$(getAvailableBenchmarks)
  echo "Use all benchmarks: $availableBenches"
  IFS=' ' read -r -a benchmarks <<< $availableBenches
fi

#run chosen benchmarks using all parameters
for key in "${!benchmarks[@]}"; do
  echo "Run benchmark: "${benchmarks[$key]} $options
  ${benchmarks[$key]} $options
done