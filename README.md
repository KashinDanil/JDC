Prerequisites
------------
There are presented versions of modules on which JDC works properly:
* gcc/9.1 (To compile most of the benchmarks)
* openmpi/4.1.1-icc (To compile the mpiib and mpipacks benchmarks)
* cuda/10.1 (To compile the gpuload benchmark)

Installation
------------
On Lomonosov-2, you will need to use the following command to get necessary modules:

    module add openmpi/4.1.1-icc cuda/10.1

To compile all tests, use the command:

    make

Usage
------------
To run benchmarks directly use [`jdc.sh`](https://github.com/KashinDanil/JDC/blob/master/jdc.sh) script.
To run benchmarks using sbatch use [`sbatch-jdc.sh`](https://github.com/KashinDanil/JDC/blob/master/sbatch-jdc.sh) script.

To get help use parameter `-h` or `--help`


Currently, available following benchmarks:
1. cpuload - runs [NUMBER_OF_CORES_PER_NODE](https://github.com/KashinDanil/JDC/blob/master/config.sh#L6) times [HPAS](https://github.com/peaclab/HPAS) cpuoccupy anomaly
2. cpuloadavg - runs [HPAS](https://github.com/peaclab/HPAS) cpuoccupy anomaly
3. diskread - runs custom-made test for disk read speed
4. diskwrite - runs custom-made test for disk write speed
5. gpuload - runs custom-made test for loading GPU
6. l1cache - runs custom-made test for L1 cache misses
7. llccache - runs custom-made test for last level cache misses
8. memfree - runs [HPAS](https://github.com/peaclab/HPAS) memleak anomaly
9. mpiib - runs [osu](https://mvapich.cse.ohio-state.edu/benchmarks/) osu_bw benchmark
10. mpipacks - runs custom-made test for number of MPI IB send/receive packets


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



Creating a new benchmark
------------
In order to create a new test, you must use the templates from
[the appropriate directory](https://github.com/KashinDanil/JDC/blob/master/templates/).
The following steps will help you achieve this goal:
1. Copy and paste the
[`newbenchmarkname.sh`](https://github.com/KashinDanil/JDC/blob/master/templates/newbenchmarkname.sh) file in
[src](https://github.com/KashinDanil/JDC/blob/master/src) directory to create a new benchmark;
2. Replace "newbenchmarkname" in the filename and in the function name in the file with the actual name of
the new benchmark;
3. Change the script inside the function;
4. To be able to easily parse results, copy and paste the
[`newbenchmarkname.py`](https://github.com/KashinDanil/JDC/blob/master/templates/newbenchmarkname.py) file in
[src/parse-results](https://github.com/KashinDanil/JDC/blob/master/src/parse-results/) directory;
5. Replace the "newbenchmarkname" in filename with the same name of the benchmark that was used in step 2;
6. Change the regular expression and the output text of the result inside the file.

NOTE: if the test uses MPI, then the word "mpi" must be used in the name of the test.  

License
-------

JDC is licensed under the [BSD 3-Clause license](https://github.com/KashinDanil/JDC/blob/master/LICENSE).