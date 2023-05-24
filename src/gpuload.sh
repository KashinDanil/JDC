#!/bin/bash

: "
GPU benchmark that uses custom test to load GPU (src/Tests/GPU/GPUUtilization.cu).
"
gpuload() {

  #get all function options
  local options=${@##*( )}
  local testOptions=""
  local util=0
  #rearrange the options since the test reads the parameters in particular order
  #wished utilization is the first option in the test
  if [[ $options =~ ((u|utilization) ([0-9]+)) ]]; then
    testOptions="${BASH_REMATCH[3]}"
    util=${BASH_REMATCH[3]}
  else
    #run 70% utilization for GPU
    testOptions="70"
    util=70
  fi
  #duration is the second option in the test
  if [[ $options =~ ((d|duration) ([0-9]+)) ]]; then
    testOptions=$testOptions" ${BASH_REMATCH[3]}"
  else
    testOptions=$testOptions" 600"
  fi
  #if there is a -h or --help option, then show the help message and stop running
  if [[ $options =~ ((h|help)) ]]; then
    echo -e "\033[32mgpuload\033[0m: \033[0;36m(In JD, should be equal to the average value of 'GPU user load in %')\033[0m
  -u, --utilization (70)          The utilization (%).
  -d, --duration (600)            The total duration (in seconds)."
    return
  fi
  command="$SCRIPT_DIR/src/Tests/GPU/GPUUtilization $testOptions"
  $command
}
