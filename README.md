By default, configurations are set for supercomputer Lomonosov-2

If you want to change it replace the values of corresponding variables in `config.sh`


Installation
------------
Configure [HPAS](https://github.com/peaclab/HPAS)
1. `chmod -R 777 src/HPAS`
2. `cd src/HPAS`
3. `./autogen.sh`
4. `./configure --prefix=$PWD`
5. `make`
6. `make install`
7. `cd ../..`


Usage
------------
To run all benchmarks  use `jdc.sh`

To get help use parameter `-jdch` or `-JDCHelp`