#!/bin/bash

chmod -R 777 src/HPAS;
cd src/HPAS;
./autogen.sh;
./configure --prefix=$PWD;
make;
make install;
cd ../..;

chmod -R 777 src/osu-micro-benchmarks;
cd src/osu-micro-benchmarks;
./configure CC=oshcc CXX=oshcxx;
make;
cd ../..;

chmod -R 777 src/Tests/Cache;
cd src/Tests/Cache;
make;
cd ../../..;

chmod -R 777 src/Tests/GPU;
cd src/Tests/GPU;
make;
cd ../../..;