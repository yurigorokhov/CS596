/**
 * Yuri Gorokhov
 * lab 2 - Conditional statements vs without
 */

#include <stdio.h>
#include <cuda.h>
#include "../include/cuda_util.h"

#define ITERATIONS 10000000
#define NUM_THREADS 256

__global__ void kernel_with_conditionals();
__global__ void kernel_without_conditionals();

int main() {
	cudaEvent_t start, stop;
	float elapsedTime;
	
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	
	// with conditionals
	cudaEventRecord(start,0);
	kernel_with_conditionals<<<1, NUM_THREADS>>>();
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&elapsedTime, start, stop);	
	printf("Time with conditionals: %f\n", elapsedTime);

	// without conditionals
	cudaEventRecord(start,0);
	kernel_without_conditionals<<<1,NUM_THREADS>>>();
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&elapsedTime, start, stop);	
	printf("Time without conditionals: %f\n", elapsedTime);

    return 0;
}

__global__ void kernel_with_conditionals() {
	int temp = 0;
	for(int i=0; i < ITERATIONS; i++) {
		if(threadIdx.x % 2 == 0)
			temp += 1;
		else
			temp -= 1;
	}
	__syncthreads();
}

__global__ void kernel_without_conditionals() {
	int temp = 0;
	for(int i=0; i < ITERATIONS; i++) {
		temp += (-threadIdx.x%2) + (1 - threadIdx.x%2);
	}
	__syncthreads();
}

