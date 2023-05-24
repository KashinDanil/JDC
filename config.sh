#!/bin/bash

#any parameters in this file can be changed to a specific values

#automatically set the number of nodes
NUMBER_OF_CORES_PER_NODE=$(nproc)
#automatically set total memory in bytes
TOTAL_MEM_B=$(grep MemTotal /proc/meminfo | awk '{print $2}')