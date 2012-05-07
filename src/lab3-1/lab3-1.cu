/**
 * Yuri Gorokhov
 * lab 1 - Global vs Shared memory speeds
 */

#include <stdio.h>
#include <cuda.h>
#include "../include/cuda_util.h"

#define ITERATIONS 10000000

__global__ void register_mem_kernel();
__global__ void shared_mem_kernel();

int main() {
	cudaEvent_t start, stop;
	float elapsedTime;
	
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	
	// Register Memory
	cudaEventRecord(start,0);
	register_mem_kernel<<<1, 1>>>();
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&elapsedTime, start, stop);	
	printf("Register memory: %f\n", elapsedTime);

	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	
	// Shared Memory
	cudaEventRecord(start,0);
	shared_mem_kernel<<<1, 1>>>();
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&elapsedTime, start, stop);	
	printf("Shared memory: %f\n", elapsedTime);

    return 0;
}

__global__ void register_mem_kernel() {
	int location;
	for(int i = 0; i < ITERATIONS; i++) {
		int tmp = location >> 1;
		location = tmp;
	}
}

__global__ void shared_mem_kernel() {
	__shared__ int location;
	for(int i = 0; i < ITERATIONS; i++) {
		int tmp = location >> 1;
		location = tmp;
	}
}
