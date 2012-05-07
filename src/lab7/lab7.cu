/**
 * Yuri Gorokhov
 * lab 7 - grid configurations
 */

#include <stdio.h>
#include <cuda.h>
#include <math.h>

#include "../include/cuda_util.h"

#define SIZE 10000

__global__ void sum_kernel();

int main(void) {
  cudaEvent_t start, stop;
  float elapsedTime;
  
  cudaEventCreate(&start);
  cudaEventCreate(&stop);
  
  cudaEventRecord(start,0);
  sum_kernel<<<1,512>>>();
  cudaEventRecord(stop, 0);
  cudaEventSynchronize(stop);
  cudaEventElapsedTime(&elapsedTime, start, stop);
  printf("\n1x1, 512 threads per block: %f", elapsedTime);
  
  cudaEventCreate(&start);
  cudaEventCreate(&stop);
  
  dim3 grid(1,2);
  cudaEventRecord(start,0);
  sum_kernel<<<grid,256>>>();
  cudaEventRecord(stop, 0);
  cudaEventSynchronize(stop);
  cudaEventElapsedTime(&elapsedTime, start, stop);
  printf("\n1x2, 256 threads per block: %f", elapsedTime);
  
  cudaEventCreate(&start);
  cudaEventCreate(&stop);
  
  dim3 grid2(1,4);
  cudaEventRecord(start,0);
  sum_kernel<<<grid2,128>>>();
  cudaEventRecord(stop, 0);
  cudaEventSynchronize(stop);
  cudaEventElapsedTime(&elapsedTime, start, stop);
  printf("\n1x4, 128 threads per block: %f", elapsedTime);
  
  cudaEventCreate(&start);
  cudaEventCreate(&stop);
  
  dim3 grid3(1,6);
  cudaEventRecord(start,0);
  sum_kernel<<<grid3,85>>>();
  cudaEventRecord(stop, 0);
  cudaEventSynchronize(stop);
  cudaEventElapsedTime(&elapsedTime, start, stop);
  printf("\n1x8, 64 threads per block: %f", elapsedTime);
  
  cudaEventCreate(&start);
  cudaEventCreate(&stop);
  
  dim3 grid3(1,8);
  cudaEventRecord(start,0);
  sum_kernel<<<grid3,64>>>();
  cudaEventRecord(stop, 0);
  cudaEventSynchronize(stop);
  cudaEventElapsedTime(&elapsedTime, start, stop);
  printf("\n1x8, 64 threads per block: %f", elapsedTime);
}

__global__ void sum_kernel() {
    int result = 0;
    for(int i = 1; i <= SIZE; i++) {
      result += i;
    }
    __syncthreads();
}

