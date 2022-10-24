#!/bin/bash

function help {
    echo "Please input a valid test name:"
    cd $SCRIPT_DIR/src #In order to not delete the path to the folder
    TESTS=$(grep -IL -d skip *)
    cd ..
    echo -e "\033[32m"$TESTS"\033[0m"
}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
FILE=$SCRIPT_DIR/src/$1
if test -f "$FILE"; then
	echo "Run $1 benchmark"
	#$FILE $@
else
	help
fi
