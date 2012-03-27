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

__global__ void shortest_path_cuda(int*);

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
  int *DevMat;
  cudasafe( cudaMalloc((void**)&DevMat, sizeof(MAT_SIZE * MAT_SIZE * sizeof(int))), "cudaMalloc" );
  cudasafe( cudaMemcpy(DevMat, mat.array, sizeof(MAT_SIZE * MAT_SIZE * sizeof(int)) , cudaMemcpyHostToDevice), "cudaMemcpy" );
  
  // Compute shortest path with cpu
  int shortestpath = 0;
  shortest_path_cuda<<<1,MAT_SIZE>>>(DevMat);
  
  
  cudasafe( cudaFree(DevMat), "cudaFree" );
  
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
 * @return - int shortest path
 */
__global__ void shortest_path_cuda(int * mat) {
  
  // Copy Mat to shared memory
  __shared__ int matrix[MAT_SIZE * MAT_SIZE];
  for(int i = 0; i < MAT_SIZE-1; i++) {
    int idx = i * MAT_SIZE + threadIdx.x;
    matrix[idx] = mat[idx];
  }
  
  // Compute shortest path
  
  
  __syncthreads();
}



