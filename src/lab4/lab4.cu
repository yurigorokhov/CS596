/**
 * Yuri Gorokhov
 * lab 4 - Rows vs Columns
 */

#include <stdio.h>
#include <cuda.h>

#define ARRAY_SIZE 256

__global__ void kernel_row();
__global__ void kernel_col();

int main (void) {
	cudaEvent_t start, stop;
	float elapsedTime;
	
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	
	cudaEventRecord(start,0);
	kernel_row<<<1,ARRAY_SIZE>>>();
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&elapsedTime, start, stop);
	printf("kernel row time: %f\n", elapsedTime);

	cudaEventRecord(start,0);
	kernel_col<<<1,ARRAY_SIZE>>>();
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&elapsedTime, start, stop);
	printf("kernel col time: %f\n", elapsedTime);
	return 0;
}

__global__ void kernel_row() {
	__shared__ float A[ARRAY_SIZE][ARRAY_SIZE];
	int sum = 0;
	for(int i = 0; i < ARRAY_SIZE-1; i++) {
		sum += A[threadIdx.x][i];
	}
	__syncthreads();
}

__global__ void kernel_col() {
	__shared__ float A[ARRAY_SIZE][ARRAY_SIZE];
	int sum = 0;
	for(int i = 0; i < ARRAY_SIZE-1; i++) {
		sum += A[i][threadIdx.x];
	}
	__syncthreads();
}

