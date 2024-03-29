#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

#import function to get available benchmarks
. "$SCRIPT_DIR/src/Utils/getAvailableBenchmarks.sh"
#import help
. "$SCRIPT_DIR/src/Utils/help.sh"
. "$SCRIPT_DIR/src/Utils/sbatchHelp.sh"

#get all available benchmarks
availableBenchmarks=$(getAvailableBenchmarks)

#set default output filename
resultFileName="sbatch-jdc-$(($(date +%s%N) / 1000000)).out"
additionalParseParams=''

sbatchParameters=''
#use 'run' as default script for sequential benchmarks
sbatchScript='run'
sbatchMPIParameters=''
#use 'ompi' as default script for mpi benchmarks
sbatchMPIScript='ompi'
numberOfIterations=1

benchmarks=()

commonParams=()
while [ -n "$1" ]; do
  #  split param by equals sign
  param=$1
  key=${param%%=*}
  value=${param#*=}

  #set the value empty if it was not set by an equal sign
  if [[ $key == $value ]]; then
    value=''
  fi

  if [[ $param == "-h" ]] || [[ $param == "--help" ]]; then
    help
    sbatchHelp
    exit 0
  fi

  if [[ $key == "--sbatch-params" ]]; then
    sbatchParameters=$value
    shift
    continue
  fi
  if [[ $key == "--sbatch-script" ]]; then
    sbatchScript=$value
    shift
    continue
  fi
  if [[ $key == "--sbatch-mpi-params" ]]; then
    sbatchMPIParameters=$value
    shift
    continue
  fi
  if [[ $key == "--sbatch-mpi-script" ]]; then
    sbatchMPIScript=$value
    shift
    continue
  fi
  if [[ $key == "--result-file" ]]; then
    resultFileName=$value
    shift
    continue
  fi
  if [[ $key == "--dndoof" ]]; then
    additionalParseParams=$additionalParseParams" --dndoof"
    shift
    continue
  fi
  if [[ $key == "-n" ]]; then
    if [[ $value != "" ]]; then
      numberOfIterations=$value
    else
      re='^[0-9]+$'
      if ! [[ $2 =~ $re ]]; then
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
  IFS=' ' read -r -a benchmarks <<<$availableBenchmarks
  benchmarksCounter=${#benchmarks[@]}
fi

sleepTime=60
parseResults=''
jobIds=()
for ((i = 0; i < numberOfIterations; i++)); do
  for benchmark in "${benchmarks[@]}"; do
    key=${benchmark%%=*}
    if [[ $key == *"mpi"* ]]; then
      #use mpi params to mpi benchmark
      command="sbatch ${sbatchMPIParameters} ${sbatchMPIScript} -- ./jdc.sh"
    else
      #use regular params to sequential benchmark
      command="sbatch ${sbatchParameters} ${sbatchScript} -- ./jdc.sh"
    fi

    repeat=0
    while :; do
      if ((repeat == 0)); then
        echo "$command '${benchmark}' ${commonParams[@]}"
      fi
      res=$($command "${benchmark}" ${commonParams[@]} 2>&1 2>&1)
      if [[ "$res" != *"Submitted batch job"* ]]; then
        repeat=$((repeat + 1))
        if ((repeat > 1)); then
          echo -en "\r\033[1K"
        fi
        echo -en "\033[0;33m"
        printf "%${repeat}s" | sed 's/ /*/g'
        echo -en " Was not able to submit a batch job. Waiting $((sleepTime * repeat)) seconds "
        printf "%${repeat}s" | sed 's/ /*/g'
        echo -en "\033[0m"
        sleep $sleepTime
      else
        if ((repeat > 0)); then
          echo ""
        fi
        echo $res
        echo ""
        jobID=${res/'Submitted batch job '/''}
        jobIds+=("$jobID")
        parseResults=$parseResults" $key=slurm-$jobID.out"
        break
      fi
    done
  done
done

minNumberOfLines=1
repeat=0
while :; do
  queue=$(squeue -j $(printf ",%s" "${jobIds[@]}"))
  if [[ $(echo "$queue" | wc -l) != $minNumberOfLines ]]; then
    repeat=$((repeat + 1))
    if ((repeat > 1)); then
      echo -en "\r\033[1K"
    fi
    echo -en "\033[0;33m"
    printf "%${repeat}s" | sed 's/ /*/g'
    echo -en " Waiting $((sleepTime * repeat)) seconds for all jobs to complete "
    printf "%${repeat}s" | sed 's/ /*/g'
    echo -en "\033[0m"
    sleep $sleepTime
  else
    if ((repeat > 0)); then
      echo ""
    fi
    break
  fi
done

command="python src/parse-results/sbatch-parse.py $parseResults$additionalParseParams"
echo $command
$command >>$resultFileName

echo ""
echo ""
echo "The results are presented in $resultFileName"
