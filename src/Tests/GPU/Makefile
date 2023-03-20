all: GPUUtilization

GPUUtilization: GPUUtilization.cu
	nvcc -O0 -std=c++11 ./GPUUtilization.cu -gencode arch=compute_35,code=sm_35 -o GPUUtilization
clean:
	rm -rf GPUUtilization
