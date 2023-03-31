#!/bin/bash

: "
I/O benchmark uses dd for copying a random data into files.
Then copies that file into other files and so on. (src/HPAS/bin/iobandwidth).
"
iobandwidth() {
  #get all function options
  local options=${@##*( )}
  if [[ ! "$options" == *"-s"* ]]; then
    #Block size
    options=$options" -s 1G"
  fi
  if [[ ! "$options" == *"-d"* ]]; then
    #run fo 600 seconds
    options=$options" -d 600"
  fi
  if [[ ! "$options" == *"-v"* ]]; then
    #show verbose data
    options=$options" -v"
  fi
  command="$SCRIPT_DIR/src/HPAS/bin/iobandwidth $options"
#  echo $command
  $command
}