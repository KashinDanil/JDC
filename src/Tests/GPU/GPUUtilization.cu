#include <iostream>
#include <cuda_runtime.h>
#include <sys/time.h>
#include <cmath>
#include <unistd.h>
#include <chrono>
#include <thread>

double cpuSecond(){
    struct timeval tp;
    gettimeofday(&tp,NULL);
    return ((double)tp.tv_sec + (double)tp.tv_usec*1.e-6);

}


template <class T>
class ArrayHost{
    T * values;
    long elem_numb;
public:
    explicit ArrayHost(long n):elem_numb(n) {
        values = new T[elem_numb];
    }
    void Init(void){
        time_t t;
        srand((unsigned) time(&t));
        for (int i = 0; i < elem_numb; i++) {
            values[i] = (T) (rand() & 0xFF) / 10.0f;
        }
    }
    T* get_values(void){
        return values;
    }
    long get_size(){
        return sizeof(T)*elem_numb;
    }
    ~ArrayHost(){
        delete []values;
    }
};


template <class T>
class ArrayDevice{
    T * values;
    long elem_numb;
public:
    explicit ArrayDevice(long n):elem_numb(n){
        cudaMalloc((T**)&values,elem_numb*sizeof(T));


    };
    T* get_values(void){
        return values;
    }
    ~ArrayDevice(){
        cudaFree(values);
    }
};


template <typename type>
void checkResult(type *host_array,type *device_array,const long array_size){
    double epsilon  = 0.1;
    for (long i=0;i<array_size;i++){
        if(abs(device_array[i] - host_array[i]) > epsilon){
            std::cout<<"ERROR in position"<<i;
            break;
        }
    }
    std::cout<<"SUCCESS\n";
}

template <typename type>
void sum_on_host(type *A,type *B, type *C, long N, int iter_limit){
    for(long i =0;i<N;i++){
        C[i] = A[i] + iter_limit* B[i];
    }
}

template <typename type>
__global__ void sum_on_device(type *A, type *B, type *C) {
    int i = threadIdx.x  + blockIdx.x*blockDim.x;
    C[i] = A[i] + B[i];
}


int main(int argc, char** argv){

    using namespace std;
    
    long values_num = static_cast<long>(pow(2, 29)) * 1.5;
    if (argc < 3) {
        printf("Pass wished utilization in the first argument and iterations limit in the second argument\n");
    }
    int wished_util = atoi(argv[1]);
    int iter_limit = atoi(argv[2]);

    ArrayHost<int> A_h (values_num);
    ArrayHost<int> B_h (values_num);

    A_h.Init();
    B_h.Init();

    ArrayHost<int> HostSum(values_num);
    ArrayHost<int> Device_to_HostSum(values_num);

    int max_threads_for_block = 1024;
    dim3 block(max_threads_for_block);
    dim3 grid ((values_num + max_threads_for_block - 1)/ max_threads_for_block);

    double start_on_host = cpuSecond();
    sum_on_host<int>(A_h.get_values(),B_h.get_values(),HostSum.get_values(),values_num, iter_limit);
    double end_on_host = cpuSecond();


    std::cout << "Trying to allocate " << values_num * 3 * sizeof(int) / pow(10, 9) << " GB on device" << std::endl;
    ArrayDevice<int> A_d(values_num);
    ArrayDevice<int> B_d(values_num);
    ArrayDevice<int> C_d(values_num);

    cudaMemcpy(A_d.get_values(),A_h.get_values(),A_h.get_size(),cudaMemcpyHostToDevice);
    cudaMemcpy(B_d.get_values(),B_h.get_values(),B_h.get_size(),cudaMemcpyHostToDevice);
    cudaDeviceSynchronize();

    std::cout << "Starting gpuload with utilization:" << wished_util << "%" << std::endl;
    for (int iter = 0; iter < iter_limit; iter++) {

        auto start = chrono::steady_clock::now();
        sum_on_device <int> <<<grid,block>>>(A_d.get_values(),B_d.get_values(),A_d.get_values());
        cudaDeviceSynchronize();
        auto end = chrono::steady_clock::now();


        auto ms = chrono::duration_cast<chrono::milliseconds>(end - start).count();

        double time_diff = static_cast<double>(100 - wished_util)/static_cast<double>(wished_util);
        int time_sleep = static_cast<int>(ms * time_diff);
        auto start1 = chrono::steady_clock::now();
        std::this_thread::sleep_for(std::chrono::milliseconds(time_sleep));
        auto end1 = chrono::steady_clock::now();

//        std::cout << "Kernel time: " << ms << " , Sleep time: " << chrono::duration_cast<chrono::milliseconds>(end1 - start1).count() << std::endl;
    }

    cudaMemcpy(Device_to_HostSum.get_values(),A_d.get_values(),A_h.get_size(),cudaMemcpyDeviceToHost);

    checkResult(HostSum.get_values(),Device_to_HostSum.get_values(),values_num);
};