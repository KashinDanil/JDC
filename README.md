By default, configurations are set for supercomputer Lomonosov-2

If you want to change it replace the values of the corresponding variables in `config.sh`


Installation
------------
Configure [HPAS](https://github.com/peaclab/HPAS)

    chmod -R 777 src/HPAS
    cd src/HPAS
    ./autogen.sh
    ./configure --prefix=$PWD
    make
    make install
    cd ../..

Configure [osu](https://mvapich.cse.ohio-state.edu/benchmarks/)

This benchmark requires oshcc and oshcxx compilers.
On Lomonosov-2, use an additional command to have these compilers: 

    module add openmpi/4.1.1-icc

For all:

    chmod -R 777 src/osu-micro-benchmarks
    cd src/osu-micro-benchmarks
    ./configure CC=oshcc CXX=oshcxx
	make
	make install
    cd ../..


Usage
------------
To run benchmarks using a workload manager use the `jdc.sh` script.
To run benchmarks using sbatch use the `sbatch-jdc.sh` script.

To get help use parameter `-h` or `--help`