/**
 * Yuri Gorokhov
 * lab 2 - Conditional statements vs without
 */

#include <stdio.h>
#include <cuda.h>
#include "../include/cuda_util.h"

#define ARRAY_SIZE 256
#define ITERATIONS 10000000

__global__ void kernel1();

int main() {
	int *dev_array;
	cudaEvent_t start, stop;
	float elapsedTime;
	
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	
	// conditionals
	cudaEventRecord(start,0);
	kernel1<<<1, ARRAY_SIZE>>>();
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&elapsedTime, start, stop);	
	printf("Time with conditionals: %f\n", elapsedTime);

	// without conditionals
	cudaEventRecord(start,0);
	//shared_mem_kernel<<<1, ARRAY_SIZE>>>();
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&elapsedTime, start, stop);	
	printf("Shared memory: %f\n", elapsedTime);

    return 0;
}

__global__ void kernel1() {
	int temp = 0;
	for(int i=0; i < ITERATIONS; i++) {
		if(threadIdx.x % 2 == 0)
			temp += 1;
		else
			temp -= 1;
	}
}
