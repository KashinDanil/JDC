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
To run benchmarks directly use `jdc.sh` script.
To run benchmarks using sbatch use `sbatch-jdc.sh` script 
(This script runs `jdc.sh` using sbatch).

To get help use parameter `-h` or `--help`

The following tests are currently available:
Currently available following benchmarks:
1. cpuload - runs [NUMBER_OF_CORES_PER_NODE](https://github.com/KashinDanil/JDC/blob/3244eafabb43b89c17f47ffae34ac60257f25381/config.sh#L3) times [HPAS](https://github.com/peaclab/HPAS) cpuoccupy anomaly
2. memfree - runs [HPAS](https://github.com/peaclab/HPAS) memleak anomaly
3. mpiib - runs [osu](https://mvapich.cse.ohio-state.edu/benchmarks/) osu_bw benchmark that passes data between two nodes