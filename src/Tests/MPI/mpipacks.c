#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <limits.h>
#include <mpi.h>


enum {
    first_thread = 0
};

void makeDataExchange(int duration, int rank) {
    unsigned char sendData, recvData;

    sendData = rank + '0';

    clock_t start, stop;
    unsigned long t;
    start = clock();

    int i, timeSpent,
    iterNum = 0,
    cont = 1,
    packetsNumber = 0,
    iterLimit = 100;//must be even number to equal number of sends from each node
    do {
        for (i = 0; i < iterLimit; i++) {
            if ((i + rank) % 2 == 0) {
//              add 1 to sent message counter
                packetsNumber++;
//              synchronized send so we wait until another process receives the message
                MPI_Ssend(&sendData, 1, MPI_CHAR, (rank + 1) % 2, 100, MPI_COMM_WORLD);
            } else {
                MPI_Recv(&recvData, 1, MPI_CHAR, (rank + 1) % 2, 100, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            }
        }
        if (rank == first_thread) {
//          every iterLimit number of exchanges the first process checks if the time has elapsed
            stop = clock();
            timeSpent = (int)((stop - start) / CLOCKS_PER_SEC);
            cont = timeSpent < duration;
            packetsNumber++;
//          send information to the other process whether they should continue the exchange or stop
            MPI_Ssend(&cont, 1, MPI_INT, (rank + 1) % 2, 100, MPI_COMM_WORLD);
        } else {
            MPI_Recv(&cont, 1, MPI_INT, (rank + 1) % 2, 100, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        }
        iterNum++;
    } while (cont);
    if (rank == first_thread) {
        printf("Total number of iterations: %d\n", iterNum);
        printf("Time spent: %d s\n", timeSpent);
        printf("Expected total number of sent packets: %d\n", packetsNumber);
    }
}

void help() {
    printf("The program passes 1 byte between 2 nodes for specific amount of time.\n"
           "Pass the number of seconds in the first argument to run.\n"
           "This test requires exactly two processes."
           "Execution:\n"
           "./mpipackets {duration in seconds}\n");
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        help();
        return 0;
    }
    int duration = atoi(argv[1]);

    MPI_Init(&argc, &argv);
    int np = 0, rank = 0;
    MPI_Comm_size(MPI_COMM_WORLD, &np);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    if (np != 2) {
        if (rank == first_thread) {
            help();
        }
        MPI_Finalize();
        return 0;
    }

    makeDataExchange(duration, rank);

    MPI_Finalize();

    return 0;
}
