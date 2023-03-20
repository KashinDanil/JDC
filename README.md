By default, configurations are set for supercomputer Lomonosov-2

If you want to change it replace the values of the corresponding variables in `config.sh`


Installation
------------
On Lomonosov-2, you will need to use the following commands to get necessary modules:

    module add openmpi/4.1.1-icc;module add cuda/10.1

After that you can simply compile all benchmarks using command:

    make

Usage
------------
To run benchmarks directly use `jdc.sh` script.
To run benchmarks using sbatch use `sbatch-jdc.sh` script.

To get help use parameter `-h` or `--help`


Currently, available following benchmarks:
1. cpuload - runs [NUMBER_OF_CORES_PER_NODE](https://github.com/KashinDanil/JDC/blob/3244eafabb43b89c17f47ffae34ac60257f25381/config.sh#L3) times [HPAS](https://github.com/peaclab/HPAS) cpuoccupy anomaly
2. cpuloadavg - runs [HPAS](https://github.com/peaclab/HPAS) cpuoccupy anomaly
3. memfree - runs [HPAS](https://github.com/peaclab/HPAS) memleak anomaly
4. mpiib - runs [osu](https://mvapich.cse.ohio-state.edu/benchmarks/) osu_bw benchmark
5. l1cache - runs custom-made test for L1 cache misses
6. gpuload - runs custom-made test for loading GPU