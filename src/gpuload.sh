#!/bin/bash

: "
GPU benchmark that uses custom test to load GPU (src/Tests/GPU/GPUUtilization.cu).
"
gpuload() {

  #get all function options
  local options=${@##*( )}
  local testOptions=""
  local util=0
  if [[ $options =~ ((u|utilization) ([0-9]+)) ]]; then
      testOptions="${BASH_REMATCH[3]}"
      util=${BASH_REMATCH[3]}
  else
      #run 70% utilization for GPU
      testOptions="70"
      util=70
  fi
  if [[ $options =~ ((d|duration) ([0-9]+)) ]]; then
      testOptions=$testOptions" ${BASH_REMATCH[3]}"
  else
      testOptions=$testOptions" 600"
  fi
  if [[ $options =~ ((h|help)) ]]; then
      testOptions=""
  fi
  command="$SCRIPT_DIR/src/Tests/GPU/GPUUtilization $testOptions"
#  echo $command
  $command
}