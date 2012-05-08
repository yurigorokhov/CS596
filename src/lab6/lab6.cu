/**
 * Yuri Gorokhov
 * lab 6 - memcpy
 */

#include <stdio.h>
#include <cuda.h>
#include <math.h>

#include "../include/cuda_util.h"

#define ARRAY_SIZE 100 * 100
#define NUM_ARRAYS 8

__global__ void batched_kernel(int*);
__global__ void dummy_kernel(int*, int*, int*, int*, int*, int*, int*, int*);

int main(void) {
  
  cudaEvent_t start, stop;
  float elapsedTime, elapsedTimeBatch;
  
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  // Allocate host arrays
  int *hostArray0, *hostArray1, *hostArray2, *hostArray3,
      *hostArray4, *hostArray5, *hostArray6, *hostArray7;
  int *devArray0, *devArray1, *devArray2, *devArray3,
      *devArray4, *devArray5, *devArray6, *devArray7;
      
  hostArray0 = (int*)malloc(ARRAY_SIZE * sizeof(int));
  hostArray1 = (int*)malloc(ARRAY_SIZE * sizeof(int));
  hostArray2 = (int*)malloc(ARRAY_SIZE * sizeof(int));
  hostArray3 = (int*)malloc(ARRAY_SIZE * sizeof(int));
  hostArray4 = (int*)malloc(ARRAY_SIZE * sizeof(int));
  hostArray5 = (int*)malloc(ARRAY_SIZE * sizeof(int));
  hostArray6 = (int*)malloc(ARRAY_SIZE * sizeof(int));
  hostArray7 = (int*)malloc(ARRAY_SIZE * sizeof(int));
  
  // Copying without batching
  cudaEventRecord(start,0);
  
  cudasafe( cudaMalloc((void**)&devArray0, sizeof(int) * ARRAY_SIZE), "cudaMalloc" );
  cudasafe( cudaMalloc((void**)&devArray1, sizeof(int) * ARRAY_SIZE), "cudaMalloc" );
  cudasafe( cudaMalloc((void**)&devArray2, sizeof(int) * ARRAY_SIZE), "cudaMalloc" );
  cudasafe( cudaMalloc((void**)&devArray3, sizeof(int) * ARRAY_SIZE), "cudaMalloc" );
  cudasafe( cudaMalloc((void**)&devArray4, sizeof(int) * ARRAY_SIZE), "cudaMalloc" );
  cudasafe( cudaMalloc((void**)&devArray5, sizeof(int) * ARRAY_SIZE), "cudaMalloc" );
  cudasafe( cudaMalloc((void**)&devArray6, sizeof(int) * ARRAY_SIZE), "cudaMalloc" );
  cudasafe( cudaMalloc((void**)&devArray7, sizeof(int) * ARRAY_SIZE), "cudaMalloc" );

  cudasafe( cudaMemcpy(devArray0, hostArray0, sizeof(int) * ARRAY_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(devArray1, hostArray1, sizeof(int) * ARRAY_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(devArray2, hostArray2, sizeof(int) * ARRAY_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(devArray3, hostArray3, sizeof(int) * ARRAY_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(devArray4, hostArray4, sizeof(int) * ARRAY_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(devArray5, hostArray5, sizeof(int) * ARRAY_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(devArray6, hostArray6, sizeof(int) * ARRAY_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(devArray7, hostArray7, sizeof(int) * ARRAY_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );

  dummy_kernel<<<1,1>>>(devArray0, devArray1, devArray2, devArray3,
			devArray4, devArray5, devArray6, devArray7
 		      );
  
  cudaEventRecord(stop, 0);
  cudaEventSynchronize(stop);
  cudaEventElapsedTime(&elapsedTime, start, stop);
  printf("\nTime elapsed w/out batching: %f", elapsedTime);
  
  cudasafe( cudaFree(devArray0), "cudaFree" );
  cudasafe( cudaFree(devArray1), "cudaFree" );
  cudasafe( cudaFree(devArray2), "cudaFree" );
  cudasafe( cudaFree(devArray3), "cudaFree" );
  cudasafe( cudaFree(devArray4), "cudaFree" );
  cudasafe( cudaFree(devArray5), "cudaFree" );
  cudasafe( cudaFree(devArray6), "cudaFree" );
  cudasafe( cudaFree(devArray7), "cudaFree" );
  
  cudaEventCreate(&start);
  cudaEventCreate(&stop);
  
  // Let's batch!
  cudaEventRecord(start,0);
  int *batchedArray = (int*)malloc(ARRAY_SIZE * NUM_ARRAYS * sizeof(int));
  int *devBatchedArray;
  memcpy(batchedArray, hostArray0, ARRAY_SIZE * sizeof(int));
  memcpy(batchedArray+ARRAY_SIZE, hostArray1, ARRAY_SIZE * sizeof(int));
  memcpy(batchedArray+2*ARRAY_SIZE, hostArray2, ARRAY_SIZE * sizeof(int));
  memcpy(batchedArray+3*ARRAY_SIZE, hostArray3, ARRAY_SIZE * sizeof(int));
  memcpy(batchedArray+4*ARRAY_SIZE, hostArray4, ARRAY_SIZE * sizeof(int));
  memcpy(batchedArray+5*ARRAY_SIZE, hostArray5, ARRAY_SIZE * sizeof(int));
  memcpy(batchedArray+6*ARRAY_SIZE, hostArray6, ARRAY_SIZE * sizeof(int));
  memcpy(batchedArray+7*ARRAY_SIZE, hostArray7, ARRAY_SIZE * sizeof(int));

  cudasafe( cudaMalloc((void**)&devBatchedArray, sizeof(int) * ARRAY_SIZE * NUM_ARRAYS), "cudaMalloc" );
  cudasafe( cudaMemcpy(devBatchedArray, batchedArray, sizeof(int) * ARRAY_SIZE * NUM_ARRAYS, cudaMemcpyHostToDevice), "cudaMemcpy" );
  
  batched_kernel<<<1,1>>>(devBatchedArray);
  
  cudaEventRecord(stop, 0);
  cudaEventSynchronize(stop);
  cudaEventElapsedTime(&elapsedTimeBatch, start, stop);
  printf("\nTime elapsed with batching: %f", elapsedTimeBatch);
  printf("\nSpeedup: %f\n", elapsedTimeBatch/elapsedTime * 100);
  cudasafe( cudaFree(devBatchedArray), "cudaFree" );
}

__global__ void dummy_kernel(int* a, int* b, int* c, int* d, int* e, int* f, int* g, int* h) 
{__syncthreads();}

__global__ void batched_kernel(int* batchArray) {
    int * devArray0 = batchArray; 
    int * devArray1 = batchArray + ARRAY_SIZE;
    int * devArray2 = batchArray + 2*ARRAY_SIZE;
    int * devArray3 = batchArray + 3*ARRAY_SIZE;
    int * devArray4 = batchArray + 4*ARRAY_SIZE;
    int * devArray5 = batchArray + 5*ARRAY_SIZE;
    int * devArray6 = batchArray + 6*ARRAY_SIZE;
    int * devArray7 = batchArray + 7*ARRAY_SIZE;
    __syncthreads();
}

