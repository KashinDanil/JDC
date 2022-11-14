By default, configurations are set for supercomputer Lomonosov-2

If you want to change it replace the values of corresponding variables in `config.sh`


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
    ./configure CC=mpicc CXX=mpicxx
	make
	make install
    cd ../..


Usage
------------
To run all benchmarks  use `jdc.sh`

To get help use parameter `-h` or `--help`