/**
 * Yuri Gorokhov
 * lab 10 - Cuda Host Alloc
 */

#include <stdio.h>
#include <cuda.h>
#include <math.h>

#include "../include/cuda_util.h"

#define SIZE 10*1024*1024
#define ITERATIONS 100

float cuda_malloc_test(int size, bool up);
float cuda_host_alloc_test(int size, bool up);

int main(void) {
  float elapsedTime;
  elapsedTime = cuda_malloc_test(SIZE, true);
  printf("Time using cudaMalloc (copy up): %f\n", elapsedTime);
  elapsedTime = cuda_malloc_test(SIZE, false);
  printf("Time using cudaMalloc (copy down): %f\n", elapsedTime);
  
  elapsedTime = cuda_host_alloc_test(SIZE, true);
  printf("Time using cudaHostAlloc (copy up): %f\n", elapsedTime);
    elapsedTime = cuda_host_alloc_test(SIZE, false);
  printf("Time using cudaHostAlloc (copy down): %f\n", elapsedTime);
}

float cuda_malloc_test(int size, bool up) {
  cudaEvent_t start, stop;
  int *a, *dev_a;
  float elapsedTime;
  
  cudaEventCreate(&start);
  cudaEventCreate(&stop);
  
  a = (int*)malloc(size*sizeof(*a));
  cudaMalloc((void**)&dev_a, size * sizeof(*dev_a));
  cudaEventRecord(start, 0);
  for(int i = 0; i < ITERATIONS; i++) {
    if (up)
      cudaMemcpy( dev_a, a, size * sizeof( *dev_a ), cudaMemcpyHostToDevice );
    else
      cudaMemcpy( a, dev_a, size * sizeof( *dev_a ), cudaMemcpyDeviceToHost );
  }
  cudaEventRecord(stop, 0);
  cudaEventSynchronize(stop);
  cudaEventElapsedTime(&elapsedTime, start, stop);
  free(a);
  cudaFree(dev_a);
  cudaEventDestroy(start);
  cudaEventDestroy(stop);
  return elapsedTime;
}

float cuda_host_alloc_test(int size, bool up) {
  cudaEvent_t start, stop;
  int *a, *dev_a;
  float elapsedTime;
  
  cudaEventCreate(&start);
  cudaEventCreate(&stop);
  
  cudaHostAlloc((void**)&a, size * sizeof(*a), cudaHostAllocDefault);
  cudaMalloc((void**)&dev_a, size * sizeof(*dev_a));
  cudaEventRecord(start, 0);
  for(int i = 0; i < ITERATIONS; i++) {
    if (up)
      cudaMemcpy( dev_a, a, size * sizeof( *dev_a ), cudaMemcpyHostToDevice );
    else
      cudaMemcpy( a, dev_a, size * sizeof( *dev_a ), cudaMemcpyDeviceToHost );
  }
  cudaEventRecord(stop, 0);
  cudaEventSynchronize(stop);
  cudaEventElapsedTime(&elapsedTime, start, stop);
  cudaFreeHost(a);
  cudaFree(dev_a);
  cudaEventDestroy(start);
  cudaEventDestroy(stop);
  return elapsedTime;
}