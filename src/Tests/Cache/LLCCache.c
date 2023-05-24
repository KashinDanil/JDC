#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <limits.h>


inline int genRandBetween(int min, int max) {
//  return a random value within the given range
    return rand() % ((max + 1) - min) + min;
}

void genArray(int N, int *arr) {
    int i;
    for (i = 0; i < N; i++) {
        arr[i] = i % 10;
    }
}

void genArrayRevert(int N, int *arr) {
    int i;
    for (i = 0; i < N; i++) {
        arr[i] = (N - i) % 10;
    }
}

inline int getNewKey(int prev_key, int arr_len, int llc_dcache_line_size) {
    int min, max;
//  set range from where we can take value
//  the minimum value is the last value plus last level cache line size
    min = (prev_key + llc_dcache_line_size) % arr_len;
//  the maximum value is the minimum value plus last level cache line size
    max = (min + llc_dcache_line_size) % arr_len;
    if (max < min) {//made a full cycle
        min = 0;
    }
    return genRandBetween(min, max);
}

int arraySum(int N, int *arr) {
    int sum = 0;
    int i;
    for (i = 0; i < N; i++) {
        sum = (sum + arr[i]) % INT_MAX;
    }

    return sum;
}

void makeMiss(int duration) {
//  read size of last level cache line starting from level 4
    int llc_dcache_line_size = sysconf(_SC_LEVEL4_CACHE_LINESIZE);
//  read size of last level cache starting from level 4
    int llc_dcache_size = sysconf(_SC_LEVEL4_CACHE_SIZE);
    if ((llc_dcache_line_size <= 0) || (llc_dcache_size <= 0)) {
        llc_dcache_line_size = sysconf(_SC_LEVEL3_CACHE_LINESIZE);
        llc_dcache_size = sysconf(_SC_LEVEL3_CACHE_SIZE);
        printf("LLC is 3\n");
    }
    if ((llc_dcache_line_size <= 0) || (llc_dcache_size <= 0)) {
        llc_dcache_line_size = sysconf(_SC_LEVEL2_CACHE_LINESIZE);
        llc_dcache_size = sysconf(_SC_LEVEL2_CACHE_SIZE);
        printf("LLC is 2\n");
    }

//  set array size equal to three llc cache sizes
    int N = llc_dcache_size * 3;

//  create and fill arrays with different data
    int *B = (int *) malloc(sizeof(int) * N);
    genArray(N, B);

    int *C = (int *) malloc(sizeof(int) * N);
    genArrayRevert(N, C);

    int *A = (int *) malloc(sizeof(int) * N);

    srand(time(NULL));

//  set start time
    struct timespec mt1, mt2;
    clock_gettime(CLOCK_REALTIME, &mt1);

    int i, key, prev_key = N - 1;
    long long miss_count = 0;
    int time_spent;
//  each number of iterations iterNum, we will check if the time has elapsed
    int iterNum = 1000000;
    do {
        for (i = 0; i < iterNum; i++) {
//          generate random key in a gap from one to two last level cache line sizes
            key = getNewKey(prev_key, N, llc_dcache_line_size);
            A[key] = B[key] * C[key];
//          there are 3 accesses to the array elements, so we assume that we get three cache misses
            miss_count += 3;
//          remember last key
            prev_key = key;
        }
//      check if the time has elapsed
        clock_gettime(CLOCK_REALTIME, &mt2);
        time_spent = mt2.tv_sec - mt1.tv_sec;
    } while (time_spent < duration);

    printf("Time spent: %d s\n", time_spent);
    printf("Expected total number of LLC cache misses: %lld\n", miss_count);

//  calculate the sum so that the compiler does not remove unnecessary steps
    int sum = arraySum(N, A);
    printf("Total sum: %d", sum);
    printf("\33[2K\r");//clear line
}

void help() {
    printf("The program generates LLC cache misses. Pass the number of seconds in the first argument to run.\n"
           "Execution:\n"
           "./LLCCache {duration in seconds}\n");
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        help();
        return 0;
    }
    int duration = atoi(argv[1]);

    makeMiss(duration);

    return 0;
}
