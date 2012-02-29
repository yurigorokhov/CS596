/**
 * Yuri Gorokhov
 * lab 3
 */

#include <stdio.h>
#include <cuda.h>

#define ARRAY_SIZE 512

__global__ void kernel1();
__global__ void kernel2();

int main (void) {
	cudaEvent_t start, stop;
	float elapsedTime;
	
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	
	cudaEventRecord(start,0);
	kernel1<<<1,ARRAY_SIZE>>>();
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&elapsedTime, start, stop);
	printf("kernel1 Time: %f\n", elapsedTime);

	cudaEventRecord(start,0);
	kernel2<<<1,ARRAY_SIZE>>>();
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&elapsedTime, start, stop);
	printf("kernel2 Time: %f\n", elapsedTime);
	return 0;
}

__global__ void kernel1() {
	__shared__ float A[ARRAY_SIZE];
	int t = threadIdx.x;
	for(int i=1; i < ARRAY_SIZE; i *= 2) {
		__syncthreads();
		if(t%(2*i)==0)
			A[t]+=A[t+i];
	}
}

__global__ void kernel2() {
	__shared__ float A[ARRAY_SIZE];
	int t = threadIdx.x;
	for(int i = ARRAY_SIZE; i>0; i >>= 1) {
		__syncthreads();
		if(t<i)
			A[t] += A[t+i];
	}
}
