#!/bin/bash

: '
Function that divides arguments to benchmark names and options to these benchmarks
Returns given glued benchmarks by comma then space and all options
It gives a user an opportunity to use benchmark names and options in any order
'
divideBenchmarksAndOptions() {
  options=()
  optionsCounter=0
  benchmarks=("deleteMe")
  benchmarksCounter=1
  while [ -n "$1" ]
  do
    if [ $1 = "-jdch" ] || [ $1 = "--JDCHelp" ]; then
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