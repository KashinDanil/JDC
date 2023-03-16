#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
//#include <papi.h>
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

inline int getNewKey(int prev_key, int arr_len, int l1_dcache_line_size) {
    int min, max;
//            if (prev_key < arr_len / 2) {
//                min = arr_len / 2;
//                max = arr_len - 1;
//            } else {//TODO mod
//                min = 0;
//                max = arr_len / 2 - 1;
//            }
    min = (prev_key + l1_dcache_line_size) % arr_len;
    max = (min + l1_dcache_line_size) % arr_len;
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

//void handle_error(int ret_val) {
//    printf("PAPI error %d: %s\n", ret_val, PAPI_strerror(ret_val));
//    exit(1);
//}

void makeMiss(long long iterNum, int duration) {
    int l1_dcache_line_size = sysconf(_SC_LEVEL1_DCACHE_LINESIZE);
    int l1_dcache_size = sysconf(_SC_LEVEL1_DCACHE_SIZE);

    int N = l1_dcache_line_size * l1_dcache_size;

    int *B = (int *) malloc(sizeof(int) * N);
    genArray(N, B);

    int *C = (int *) malloc(sizeof(int) * N);
    genArrayRevert(N, C);

    int *A = (int *) malloc(sizeof(int) * N);

    srand(time(NULL));


//    int ret_val;
//    int event_set = PAPI_NULL;
//    long long cm;
//    ret_val = PAPI_library_init(PAPI_VER_CURRENT);
//    if (ret_val != PAPI_VER_CURRENT) {
//        fputs("failed to initialize PAPI\n", stderr);
//        return;
//    }
//    if (PAPI_create_eventset(&event_set) != PAPI_OK) {
//        fputs("unable to create event set\n", stderr);
//        return;
//    }//PAPI_L1_DCM  PAPI_L1_LDM
//    if ((ret_val = PAPI_add_event(event_set, PAPI_L1_DCM)) != PAPI_OK) {
//        fputs("can't add event\n", stderr);
//        handle_error(ret_val);
//        return;
//    }
//    if (PAPI_start(event_set) != PAPI_OK) {
//        fputs("failed to start counters\n", stderr);
//        return;
//    }


    struct timespec mt1, mt2;
    clock_gettime(CLOCK_REALTIME, &mt1);

    long long i;
    int cur_min, key,
            prev_key = N - 1;
    long long miss_count = 0;
    long long time_spent;
    int interval = 60;//in seconds
    for (cur_min = 0; cur_min < duration; cur_min++) {
        for (i = 0; i < iterNum; i++) {
            key = getNewKey(prev_key, N, l1_dcache_line_size);
            A[key] = B[key] * C[key];
            miss_count += 3;

            prev_key = key;
        }
        clock_gettime(CLOCK_REALTIME, &mt2);
        time_spent = mt2.tv_sec - mt1.tv_sec;
        printf("Time spent: %lld s for %lld iterations\n", time_spent, iterNum);
        if (time_spent < interval * (cur_min + 1)) {
            printf("Sleep for %lld s\n", interval * (cur_min + 1) - time_spent);
            sleep((interval * (cur_min + 1) - time_spent));
        }
    }

//    clock_gettime(CLOCK_REALTIME, &mt2);
//    time_spent = 1000000000 * (mt2.tv_sec - mt1.tv_sec) + (mt2.tv_nsec - mt1.tv_nsec);
//    printf("Elapsed time: %f s\n", (float) time_spent / 1000000000);


//    if (PAPI_stop(event_set, &cm) != PAPI_OK) {
//        fputs("error in stop counters 1\n", stderr);
//        return;
//    }
//    printf("Cache misses = %lld\n", cm);


    printf("Expected total number of L1 cache misses: %lld\n", miss_count);

    int sum = arraySum(N, A);
    printf("Total sum: %d", sum);
    printf("\33[2K\r");//clear line
}

void help() {
    printf("The program generates L1 cache misses. Pass the number of iterations\n"
           "per minute as the first argument (Each iteration equals 3 misses). The second\n"
           "argument is the number of minutes to the program to work. And the third argument\n"
           "is optional and stands for additional output.\n"
           "Execution:\n"
           "./L1Cache {number of iterations per minute} {duration time in minutes}\n");
}

int main(int argc, char *argv[]) {
    if (argc < 3) {
        help();
        return 0;
    }
    long long iterNum = atoi(argv[1]);
    int duration = atoi(argv[2]);

    makeMiss(iterNum, duration);

    return 0;
}
