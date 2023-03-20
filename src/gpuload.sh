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
  if [[ $options =~ ((i|iterations) ([0-9]+)) ]]; then
      testOptions=$testOptions" ${BASH_REMATCH[3]}"
  else
      if [[ $util < 11 ]]; then
        testOptions=$testOptions" 1000"
      elif [[ $util < 21 ]]; then
        testOptions=$testOptions" 2400"
      elif [[ $util < 51 ]]; then
        testOptions=$testOptions" 7000"
      elif [[ $util < 91 ]]; then
        testOptions=$testOptions" 10000"
      else
        testOptions=$testOptions" 50000"
      fi
  fi
  if [[ $options =~ ((h|help)) ]]; then
      testOptions=""
  fi
  command="$SCRIPT_DIR/src/Tests/GPU/GPUUtilization $testOptions"
#  echo $command
  $command
}