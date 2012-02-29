/**
 * Yuri Gorokhov
 * lab 1 - Global vs Shared memory speeds
 */

#include <stdio.h>
#include <cuda.h>
#include "../include/cuda_util.h"

#define ARRAY_SIZE 256
#define ITERATIONS 10000000

__global__ void global_mem_kernel(int *array);
__global__ void shared_mem_kernel();

int main() {
	int *dev_array;
	cudaEvent_t start, stop;
	float elapsedTime;
	
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	
	// Global Memory
	cudasafe( cudaMalloc((void**)&dev_array, sizeof(int) * ARRAY_SIZE), "cudaMalloc" );
	cudaEventRecord(start,0);
	global_mem_kernel<<<1, ARRAY_SIZE>>>(dev_array);
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&elapsedTime, start, stop);	
	cudasafe( cudaFree(dev_array), "cudaFree" );
	printf("Global memory: %f\n", elapsedTime);

	// Shared Memory
	cudaEventRecord(start,0);
	shared_mem_kernel<<<1, ARRAY_SIZE>>>();
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&elapsedTime, start, stop);	
	printf("Shared memory: %f\n", elapsedTime);

    return 0;
}

__global__ void global_mem_kernel(int *array) {
	for(int i = 0; i < ITERATIONS; i++) {
		int tmp = array[threadIdx.x];
		array[threadIdx.x] = tmp;
	}
}

__global__ void shared_mem_kernel() {
	int array[ARRAY_SIZE];
	for(int i = 0; i < ITERATIONS; i++) {
		int tmp = array[threadIdx.x];
		array[threadIdx.x] = tmp;
	}
}
