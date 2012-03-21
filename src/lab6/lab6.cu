/**
 * Yuri Gorokhov
 * lab 6 - Integration
 */

#include <stdio.h>
#include <cuda.h>
#include <math.h>

#include "../include/cuda_util.h"

#define PARTITIONS 1024 // Number of partitions to divide area into, must be even
#define THREAD_PER_BLOCK 512 

float function(float);
float integrate(float (*)(float), float, float);
void error(char *);
__global__ void sum_kernel(float*, int);

int main() {
	float result;
	result = integrate(function, 0.0, 10.0);		
	printf("\nResult = %f\n\n", result);
	return 0;
}

float integrate(float (*func)(float), float lower, float upper) {
	// Create an array to store the area
	float *area_array;
	area_array = (float*)malloc(sizeof(float) * PARTITIONS);
	if(area_array == NULL)
		error("malloc failed");

	float step = (upper-lower)/PARTITIONS;
	
	// Populate the area_array by computing the Rieman Sum
	for(int i = 0; i < PARTITIONS; i++) {
		area_array[i] = func(lower + i * step) * step;
	}

	// Copy the array to the device
	float * dev_array;
	float result;
	cudasafe( cudaMalloc((void**)&dev_array, sizeof(float) * PARTITIONS), "cudaMalloc" );
	cudasafe( cudaMemcpy(dev_array, area_array, sizeof(float) * PARTITIONS, cudaMemcpyHostToDevice), "cudaMemcpy" );
	free(area_array);

	// Sum up the array
	sum_kernel<<<1, PARTITIONS/2>>>(dev_array, PARTITIONS);
	cudasafe( cudaMemcpy(&result, dev_array, sizeof(float), cudaMemcpyDeviceToHost), "cudaMemcpy" );
	cudasafe( cudaFree(dev_array), "cudaFree" );
	return result;
}

float function(float x) {
	return pow(x,2);
}

void error(char * msg) {
	printf("\n%s\n\n", msg);
	exit(1);
}

__global__ void sum_kernel(float * array, int length) {
	int offset = 1;
	int thread = threadIdx.x;
	for(int d = length>>1; d > 0; d >>= 1) {
		__syncthreads();
		if(thread < d) {
			int ai = offset * (2*thread + 1) -1;
			int bi = offset * (2*thread + 2) -1;
		
			array[bi] += array[ai];
		}
		offset <<= 1;
	}

	// Copy result to beginning of array
	if(thread == 0) {
		array[0] = array[length-1];
	}
	__syncthreads();
}

