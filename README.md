By default, configurations are set for supercomputer Lomonosov-2

If you want to change it replace the values of the corresponding variables in `config.sh`

Prerequisites (There are presented versions of modules on which JDC works properly):
* mpich/3.4.2-gcc9
* gcc/9.1
* openmpi/4.1.1-icc
* cudatoolkit/8.0
* cuda/10.1

Installation
------------
On Lomonosov-2, you will need to use the following commands to get necessary modules:

    module add openmpi/4.1.1-icc;module add cuda/10.1

To compile all tests, use the command:

    make

Usage
------------
To run benchmarks directly use `jdc.sh` script.
To run benchmarks using sbatch use `sbatch-jdc.sh` script.

To get help use parameter `-h` or `--help`


Currently, available following benchmarks:
1. cpuload - runs [NUMBER_OF_CORES_PER_NODE](https://github.com/KashinDanil/JDC/blob/3244eafabb43b89c17f47ffae34ac60257f25381/config.sh#L3) times [HPAS](https://github.com/peaclab/HPAS) cpuoccupy anomaly
2. cpuloadavg - runs [HPAS](https://github.com/peaclab/HPAS) cpuoccupy anomaly
3. gpuload - runs custom-made test for loading GPU
4. iobandwidth - runs [HPAS](https://github.com/peaclab/HPAS) iobandwidth anomaly
5. l1cache - runs custom-made test for L1 cache misses
6. llccache - runs custom-made test for last level cache misses
7. memfree - runs [HPAS](https://github.com/peaclab/HPAS) memleak anomaly
8. mpiib - runs [osu](https://mvapich.cse.ohio-state.edu/benchmarks/) osu_bw benchmark
9. mpipacks - runs custom-made test for number of MPI IB send/receive packets


Examples
------------
    #runs all benchmarks one time
    ./sbatch-jdc.sh

    #runs all benchmarks three times
    ./sbatch-jdc.sh -n 3
    
    #runs only cpuload with default parameters
    ./sbatch-jdc.sh cpuload
    
    #runs only cpuload using 50% CPU usage for 15 minutes two times
    ./sbatch-jdc.sh cpuload='-u 50 -d 900' -n 2
    
    #runs mpiib with default amount of passing data for 3 millions times
    #without warmup and memfree with default parameters
    ./sbatch-jdc.sh mpiib='-x 0 -i 3000000' memfree
    
    #runs all benchmarks with help option
    ./sbatch-jdc.sh cpuload='-h' memfree='-h' mpiib='-h'