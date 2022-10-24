#!/bin/bash

divideBenchmarksAndOptions() {
  options=()
  optionsCounter=0
  benchmarks=("deleteMe")
  benchmarksCounter=1
  while [ -n "$1" ]
  do
    if [ $1 = "-h" ] || [ $1 = "--help" ]; then
      echo "help"
      return
    fi

    FILE=$SCRIPT_DIR/src/$1.sh
    if test -f "$FILE"; then
      benchmarks[$benchmarksCounter]=$1
      ((benchmarksCounter=benchmarksCounter+1))
    else
      options[$optionsCounter]=$1
      ((optionsCounter=optionsCounter+1))
    fi
    shift
  done

  echo $(IFS="," ; echo "${benchmarks[*]}") $(IFS=" " ; echo "${options[*]}")
}