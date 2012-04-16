/**
 * Yuri Gorokhov
 * lab 4-2 - Constant memory test
 */

#include <stdio.h>
#include <cuda.h>
#include <math.h>

#include "../include/cuda_util.h"

#define SIZE 2048
#define ITERATIONS 5000

__constant__ int array[SIZE];

__global__ void read_kernel(int);

int main(void) {
  cudaEvent_t start, stop;
  float elapsedTime;
  
  // Initialize Array
  int* hostArray = (int*)malloc(SIZE * sizeof(int));
  for(int i = 0; i < SIZE; i++)
    hostArray[i] = i;
  
  // Copy Array
  cudasafe( cudaMemcpyToSymbol(array, hostArray, SIZE * sizeof(int), 0, cudaMemcpyHostToDevice), "cudaMemcpyToSymbol" );
  
  for(int n = 1; n <= 16; n++) {
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    
    cudaEventRecord(start,0);
  
    read_kernel<<<1,256>>>(n);
    
    cudaEventRecord(stop, 0);
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&elapsedTime, start, stop);
    printf("\nN = %i -> %f", n, elapsedTime);
  }
}

__global__ void read_kernel(int n) {
    int a;
    for(int i = 0; i < ITERATIONS; i++) {
      a = array[128*(threadIdx.x % n)];
    }
    __syncthreads();
}

