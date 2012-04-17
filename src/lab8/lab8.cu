/**
 * Yuri Gorokhov
 * lab 8 - grid configurations continued
 */

#include <stdio.h>
#include <cuda.h>
#include <math.h>

#include "../include/cuda_util.h"

#define PROX 48
#define SHARED_MEM_PER_BLOCK 4000
#define THREADS 2048

#ifndef GRID_Y
#define GRID_Y 4
#endif

#ifndef ARRAY_SIZE
#define ARRAY_SIZE 3 * SHARED_MEM_PER_BLOCK / 4
#endif

__global__ void sum_kernel();

int main(void) {
  cudaEvent_t start, stop;
  float elapsedTime;
  
  cudaEventCreate(&start);
  cudaEventCreate(&stop);
  
  cudaEventRecord(start,0);
  
  dim3 grid(1,GRID_Y);
  sum_kernel<<<grid, THREADS / GRID_Y>>>();
  cudaEventRecord(stop, 0);
  cudaEventSynchronize(stop);
  cudaEventElapsedTime(&elapsedTime, start, stop);
  printf("\nProcessors: %i\nShared mem per block: %i", PROX, SHARED_MEM_PER_BLOCK);
  printf("\nGrid: 1x%i array of blocks, %i threads per block, S=%i -> %f\n", GRID_Y, THREADS / GRID_Y, ARRAY_SIZE, elapsedTime);
}

__global__ void sum_kernel() {
    __shared__ int filler[ARRAY_SIZE];
    filler[threadIdx.x % 16] = 0;
    int result = 0;
    for(int i = 1; i <= 1000; i++) {
      result += i;
    }
    __syncthreads();
}

