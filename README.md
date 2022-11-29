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

    chmod -R 777 src/osu-micro-benchmarks
    cd src/osu-micro-benchmarks
    ./configure CC=oshcc CXX=oshcxx
	make
	make install
    cd ../..


Usage
------------
To run benchmarks use `jdc.sh` script or `sbatch-jdc.sh` to run benchmarks using sbatch.

To get help use parameter `-h` or `--help`