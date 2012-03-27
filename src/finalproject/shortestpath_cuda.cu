/**
 * Yuri Gorokhov
 * final project - Shortest path
 */

#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <math.h>
#include <time.h>

#include "stack.h"
#include "../include/cuda_util.h"

#define MAT_SIZE 16
#define MAX_ELEMENT 1024

// Matrix to be represented as single array
typedef struct {
  int * array;
  int columns;
} Matrix;

__global__ void shortest_path_cuda(int*, int*);

int main() {
  
  // Create a matrix and populate it with random data
  Matrix mat;
  mat.array = (int*)malloc(MAT_SIZE * MAT_SIZE * sizeof(int));
  mat.columns = MAT_SIZE;
  srand ( time(NULL) );
  for(int i = 0; i < MAT_SIZE * MAT_SIZE; i++) {
    mat.array[i] = rand() % MAX_ELEMENT;
  }
  
  // Create a result stack
  Stack result;
  stack_init(&result, MAT_SIZE*2);
  
  // Copy matrix to global memory
  int *DevMat, *dev_shortest_path;
  cudasafe( cudaMalloc((void**)&dev_shortest_path, sizeof(int)), "cudaMalloc" );
  cudasafe( cudaMalloc((void**)&DevMat, sizeof(MAT_SIZE * MAT_SIZE * sizeof(int))), "cudaMalloc" );
  cudasafe( cudaMemcpy(DevMat, mat.array, sizeof(MAT_SIZE * MAT_SIZE * sizeof(int)) , cudaMemcpyHostToDevice), "cudaMemcpy" );
  
  // Compute shortest path with cpu
  int shortestpath = 0;
  shortest_path_cuda<<<1,MAT_SIZE>>>(DevMat, dev_shortest_path);
  cudasafe( cudaMemcpy(&shortestpath, dev_shortest_path, sizeof(int), cudaMemcpyDeviceToHost) ,"cudaMemcpy");
  cudasafe( cudaFree(DevMat), "cudaFree" );
  cudasafe( cudaFree(dev_shortest_path), "cudaFree" );
  
  // Print path taken 
  printf("\nShortest Path: %i -> ", shortestpath);
  while(!is_empty(&result)) {
    printf("%i,", pop(&result));
  }
  printf("\n");
  
  return 0;
}

/*
 * Path is returned as 1 for right, 0 for down
 * Note: this algorithm goes from top left to bottom right corner
 */
__global__ void shortest_path_cuda(int * mat, int * shortestpath) {
  
  // Copy Mat to shared memory
  __shared__ int matrix[MAT_SIZE * MAT_SIZE];
  
  if(threadIdx.x == 0) {
    matrix[0] = mat[0];
  }
  
  // Compute shortest path part1
  for(int i = 1; i < MAT_SIZE; i++) {
    __syncthreads();
    
    // only use the threads we need
    if(threadIdx.x <= i) {
      int idx = threadIdx.x * MAT_SIZE + (i - threadIdx.x);
      if(threadIdx.x == 0) {
	matrix[idx] = matrix[idx-1] + mat[idx];
      } else if(i - threadIdx.x == 0) {
	matrix[idx] = matrix[idx - MAT_SIZE] + mat[idx];
      } else {	
	int path1 = idx - 1;
	int path2 = idx - MAT_SIZE;
	matrix[idx] = matrix[path1] < matrix[path2] 
		      ? matrix[path1] + mat[idx] 
		      : matrix[path2] + mat[idx];
      }
    }
  }
  
  // Compute shortest path part2
  for(int i = 1; i < MAT_SIZE; i++) {
    __syncthreads();
    
    // only use the threads we need
    if(threadIdx.x < MAT_SIZE - i) {
      int idx = (MAT_SIZE - threadIdx.x - 1) + (threadIdx.x + i) * MAT_SIZE;
      int path1 = idx - 1;
      int path2 = idx - MAT_SIZE;
      matrix[idx] = matrix[path1] < matrix[path2] 
		    ? matrix[path1] + mat[idx] 
		    : matrix[path2] + mat[idx];
    }
  } 
  
  if(threadIdx.x == 0)
    *shortestpath = matrix[MAT_SIZE * MAT_SIZE - 1];
  __syncthreads();
}



