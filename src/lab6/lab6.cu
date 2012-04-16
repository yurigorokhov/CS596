/**
 * Yuri Gorokhov
 * lab 6 - memcpy
 */

#include <stdio.h>
#include <cuda.h>
#include <math.h>

#include "../include/cuda_util.h"

#define ARRAY_SIZE 100 * 100
#define NUM_ARRAYS 16

__global__ void batched_kernel(int*);
__global__ void dummy_kernel(int*, int*, int*, int*, int*, int*, int*, int*,
			     int*, int*, int*, int*, int*, int*, int*, int* );

int main(void) {
  
  cudaEvent_t start, stop;
  float elapsedTime, elapsedTimeBatch;
  
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  // Allocate host arrays
  int *hostArray0, *hostArray1, *hostArray2, *hostArray3,
      *hostArray4, *hostArray5, *hostArray6, *hostArray7,
      *hostArray8, *hostArray9, *hostArray10, *hostArray11,
      *hostArray12, *hostArray13, *hostArray14, *hostArray15;
  int *devArray0, *devArray1, *devArray2, *devArray3,
      *devArray4, *devArray5, *devArray6, *devArray7,
      *devArray8, *devArray9, *devArray10, *devArray11,
      *devArray12, *devArray13, *devArray14, *devArray15;
      
  hostArray0 = (int*)malloc(ARRAY_SIZE * sizeof(int));
  hostArray1 = (int*)malloc(ARRAY_SIZE * sizeof(int));
  hostArray2 = (int*)malloc(ARRAY_SIZE * sizeof(int));
  hostArray3 = (int*)malloc(ARRAY_SIZE * sizeof(int));
  hostArray4 = (int*)malloc(ARRAY_SIZE * sizeof(int));
  hostArray5 = (int*)malloc(ARRAY_SIZE * sizeof(int));
  hostArray6 = (int*)malloc(ARRAY_SIZE * sizeof(int));
  hostArray7 = (int*)malloc(ARRAY_SIZE * sizeof(int));
  hostArray8 = (int*)malloc(ARRAY_SIZE * sizeof(int));
  hostArray9 = (int*)malloc(ARRAY_SIZE * sizeof(int));
  hostArray10 = (int*)malloc(ARRAY_SIZE * sizeof(int));
  hostArray11 = (int*)malloc(ARRAY_SIZE * sizeof(int));
  hostArray12 = (int*)malloc(ARRAY_SIZE * sizeof(int));
  hostArray13 = (int*)malloc(ARRAY_SIZE * sizeof(int));
  hostArray14 = (int*)malloc(ARRAY_SIZE * sizeof(int));
  hostArray15 = (int*)malloc(ARRAY_SIZE * sizeof(int));
  
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
  cudasafe( cudaMalloc((void**)&devArray8, sizeof(int) * ARRAY_SIZE), "cudaMalloc" );
  cudasafe( cudaMalloc((void**)&devArray9, sizeof(int) * ARRAY_SIZE), "cudaMalloc" );
  cudasafe( cudaMalloc((void**)&devArray10, sizeof(int) * ARRAY_SIZE), "cudaMalloc" );
  cudasafe( cudaMalloc((void**)&devArray11, sizeof(int) * ARRAY_SIZE), "cudaMalloc" );
  cudasafe( cudaMalloc((void**)&devArray12, sizeof(int) * ARRAY_SIZE), "cudaMalloc" );
  cudasafe( cudaMalloc((void**)&devArray13, sizeof(int) * ARRAY_SIZE), "cudaMalloc" );
  cudasafe( cudaMalloc((void**)&devArray14, sizeof(int) * ARRAY_SIZE), "cudaMalloc" );
  cudasafe( cudaMalloc((void**)&devArray15, sizeof(int) * ARRAY_SIZE), "cudaMalloc" );
  
  cudasafe( cudaMemcpy(devArray0, hostArray0, sizeof(int) * ARRAY_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(devArray1, hostArray1, sizeof(int) * ARRAY_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(devArray2, hostArray2, sizeof(int) * ARRAY_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(devArray3, hostArray3, sizeof(int) * ARRAY_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(devArray4, hostArray4, sizeof(int) * ARRAY_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(devArray5, hostArray5, sizeof(int) * ARRAY_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(devArray6, hostArray6, sizeof(int) * ARRAY_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(devArray7, hostArray7, sizeof(int) * ARRAY_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(devArray0, hostArray8, sizeof(int) * ARRAY_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(devArray1, hostArray9, sizeof(int) * ARRAY_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(devArray2, hostArray10, sizeof(int) * ARRAY_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(devArray3, hostArray11, sizeof(int) * ARRAY_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(devArray4, hostArray12, sizeof(int) * ARRAY_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(devArray5, hostArray13, sizeof(int) * ARRAY_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(devArray6, hostArray14, sizeof(int) * ARRAY_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(devArray7, hostArray15, sizeof(int) * ARRAY_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  
  dummy_kernel<<<1,1>>>(devArray0, devArray1, devArray2, devArray3,
			devArray4, devArray5, devArray6, devArray7,
			devArray8, devArray9, devArray10, devArray11,
			devArray12, devArray13, devArray14, devArray15
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
  cudasafe( cudaFree(devArray8), "cudaFree" );
  cudasafe( cudaFree(devArray9), "cudaFree" );
  cudasafe( cudaFree(devArray10), "cudaFree" );
  cudasafe( cudaFree(devArray11), "cudaFree" );
  cudasafe( cudaFree(devArray12), "cudaFree" );
  cudasafe( cudaFree(devArray13), "cudaFree" );
  cudasafe( cudaFree(devArray14), "cudaFree" );
  cudasafe( cudaFree(devArray15), "cudaFree" );
  
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
  memcpy(batchedArray+8*ARRAY_SIZE, hostArray8, ARRAY_SIZE * sizeof(int));
  memcpy(batchedArray+9*ARRAY_SIZE, hostArray9, ARRAY_SIZE * sizeof(int));
  memcpy(batchedArray+10*ARRAY_SIZE, hostArray10, ARRAY_SIZE * sizeof(int));
  memcpy(batchedArray+11*ARRAY_SIZE, hostArray11, ARRAY_SIZE * sizeof(int));
  memcpy(batchedArray+12*ARRAY_SIZE, hostArray12, ARRAY_SIZE * sizeof(int));
  memcpy(batchedArray+13*ARRAY_SIZE, hostArray13, ARRAY_SIZE * sizeof(int));
  memcpy(batchedArray+14*ARRAY_SIZE, hostArray14, ARRAY_SIZE * sizeof(int));
  memcpy(batchedArray+15*ARRAY_SIZE, hostArray15, ARRAY_SIZE * sizeof(int));
  
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

__global__ void dummy_kernel(int* a, int* b, int* c, int* d, int* e, int* f, int* g, int* h,
			     int* i, int* j, int* k, int* l, int* m, int* n, int* o, int* p ) 
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
    int * devArray8 = batchArray + 8*ARRAY_SIZE;
    int * devArray9 = batchArray + 9*ARRAY_SIZE;
    int * devArray10 = batchArray + 10*ARRAY_SIZE;
    int * devArray11 = batchArray + 11*ARRAY_SIZE;
    int * devArray12 = batchArray + 12*ARRAY_SIZE;
    int * devArray13 = batchArray + 13*ARRAY_SIZE;
    int * devArray14 = batchArray + 14*ARRAY_SIZE;
    int * devArray15 = batchArray + 15*ARRAY_SIZE;
    __syncthreads();
}

