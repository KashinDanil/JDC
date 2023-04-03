#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <limits.h>


inline int genRandBetween(int min, int max) {
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
    min = (prev_key + llc_dcache_line_size) % arr_len;
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
    int llc_dcache_line_size = sysconf(_SC_LEVEL4_CACHE_LINESIZE);
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

    int N = llc_dcache_size * 3;

    int *B = (int *) malloc(sizeof(int) * N);
    genArray(N, B);

    int *C = (int *) malloc(sizeof(int) * N);
    genArrayRevert(N, C);

    int *A = (int *) malloc(sizeof(int) * N);

    srand(time(NULL));

    struct timespec mt1, mt2;
    clock_gettime(CLOCK_REALTIME, &mt1);

    int i, key, prev_key = N - 1;
    long long miss_count = 0;
    int time_spent;
    int iterNum = 1000000;
    do {
        for (i = 0; i < iterNum; i++) {
            key = getNewKey(prev_key, N, llc_dcache_line_size);
            A[key] = B[key] * C[key];
            miss_count += 3;

            prev_key = key;
        }
        clock_gettime(CLOCK_REALTIME, &mt2);
        time_spent = mt2.tv_sec - mt1.tv_sec;
    } while (time_spent < duration);
    printf("Time spent: %d s\n", time_spent);

    printf("Expected total number of LLC cache misses: %lld\n", miss_count);

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
