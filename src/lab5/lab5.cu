/**
 * Yuri Gorokhov
 * lab 5 - Modulus power of two
 */

#include <stdio.h>
#include <cuda.h>
#include <math.h>

#define ITERATIONS 100000
#define THREADS 32
#define POW 30

__global__ void kernel_mod(int);

int main (void) {
	cudaEvent_t start, stop;
	int input[POW];	
	float output[POW];
	
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	
	for(int i = 0; i < POW; i++) {
		input[i] = pow(2,i);
		cudaEventRecord(start,0);
		kernel_mod<<<1,THREADS>>>(pow(2,i));
		cudaEventRecord(stop, 0);
		cudaEventSynchronize(stop);
		cudaEventElapsedTime(&output[i], start, stop);
	}
	printf("[");
	for(int i = 0; i < POW; i++) {
		printf("%i, ", input[i]);
	}
	printf("\n[");
	for(int i = 0; i < POW; i++) {
		printf("%f, ", output[i]);
	}
	return 0;
}

__global__ void kernel_mod(int mod) {
	__shared__ float A[THREADS];
	int temp;
	int target = threadIdx.x % mod;
	for(int i = 1; i <= ITERATIONS; i++) {
		temp = A[target];
	}
	__syncthreads();
}

