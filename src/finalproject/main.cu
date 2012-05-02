#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <math.h>
#include <sys/time.h>

#define MAT_SIZE 10240
#define BLOCK_SIZE 512
#define MAX_ELEMENT 12

#include "stack.h"
#include "../include/cuda_util.h"

// Matrix to be represented as single array
typedef struct {
  int * array;
  int columns;
} Matrix;


#include "shortestpath_cuda.h"
#include "shortestpath.h"

int main(int argc, char**argv) {
  
  printf("\nSHORTEST PATH: %i x %i\n\n", MAT_SIZE, MAT_SIZE);
  
  cudaEvent_t start, stop;
  float elapsedTime, elapsedTime2;
  
  // Create a matrix and populate it with random data
  Matrix mat;
  mat.array = (int*)malloc(MAT_SIZE * MAT_SIZE * sizeof(int));
  mat.columns = MAT_SIZE;
  srand ( time(NULL) );
  for(int i = 0; i < MAT_SIZE * MAT_SIZE; i++) {
    mat.array[i] = rand() % MAX_ELEMENT;
  }
  
  // ######### CUDA #########
  printf("CUDA Implementation: ");
  
  cudaEventCreate(&start);
  cudaEventCreate(&stop);
  
  // Copy matrix to global memory
  int *DevMat, *dev_shortest_path, *dev_result_stack, *dev_calc_matrix;
  cudasafe( cudaMalloc((void**)&dev_shortest_path, sizeof(int)), "cudaMalloc" );
  cudasafe( cudaMalloc((void**)&DevMat, MAT_SIZE * MAT_SIZE * sizeof(int)), "cudaMalloc" );
  cudasafe( cudaMalloc((void**)&dev_result_stack, MAT_SIZE * 2 * sizeof(int)), "cudaMalloc" );
  cudasafe( cudaMemcpy(DevMat, mat.array, MAT_SIZE * MAT_SIZE * sizeof(int), cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMalloc((void**)&dev_calc_matrix, MAT_SIZE * MAT_SIZE * sizeof(int)), "cudaMalloc" );
  
  // Compute shortest path with cpu
  int shortestpath = 0;
  int *result_stack = (int*)malloc(MAT_SIZE * 2 * sizeof(int));
  cudaEventRecord(start,0);
  dim3 threadsPerBlock(BLOCK_SIZE);
  for(int i = 1; i < MAT_SIZE; i++) {
    dim3 blocks((int)ceil((float)(i+1) / (float)threadsPerBlock.x));
    shortest_path_cuda<<<blocks,threadsPerBlock>>>(DevMat, dev_shortest_path, dev_result_stack, dev_calc_matrix, i);
  }
  for(int i = 1; i < MAT_SIZE; i++) {    
    dim3 blocks((int)ceil((float)(MAT_SIZE-i) / (float)threadsPerBlock.x));
    shortest_path_cuda_2<<<blocks,threadsPerBlock>>>(DevMat, dev_shortest_path, dev_result_stack, dev_calc_matrix, i);
  }
  if(argc > 1)
    shortest_path_cuda_3<<<1,1>>>(DevMat, dev_shortest_path, dev_result_stack, dev_calc_matrix);
  cudaEventRecord(stop, 0);
  cudaEventSynchronize(stop);
  cudaEventElapsedTime(&elapsedTime, start, stop);
  cudasafe( cudaMemcpy(&shortestpath, dev_shortest_path, sizeof(int), cudaMemcpyDeviceToHost) ,"cudaMemcpy");
  cudasafe( cudaMemcpy(result_stack, dev_result_stack, MAT_SIZE * 2 * sizeof(int), cudaMemcpyDeviceToHost) ,"cudaMemcpy");
  cudasafe( cudaFree(DevMat), "cudaFree" );
  cudasafe( cudaFree(dev_result_stack), "cudaFree" );
  cudasafe( cudaFree(dev_shortest_path), "cudaFree" );
  cudasafe( cudaFree(dev_calc_matrix), "cudaFree" );
  
  // Print path taken 
  printf("\nelapsed time: %f\n", elapsedTime);
  printf("\nShortest Path: %i -> ", shortestpath);
  
  if(argc > 1) {
    int i = -1; 
    while(result_stack[++i] >= 0);
    for(i--; i >= 0; i--) {
      printf("%i,", result_stack[i]);
    }
    printf("\n");
  }
  // ######### CPU Implementation #########
  printf("\n\nCPU Implementation: ");
  
  // Create a result stack
  Stack result;
  stack_init(&result, MAT_SIZE*2);
  
  // Compute shortest path with cpu
  cudaEventRecord(start,0);
  shortestpath = shortest_path_cpu(&mat, &result);
  cudaEventRecord(stop, 0);
  cudaEventSynchronize(stop);
  cudaEventElapsedTime(&elapsedTime2, start, stop);
  
  // Print path taken 
  printf("\nelapsed time: %f\n", elapsedTime2);
  printf("\nShortest Path: %i -> ", shortestpath);
  if(argc > 1) {
    while(!is_empty(&result)) {
      printf("%i,", pop(&result));
    }
    printf("\n");
  }
  printf("\nSpeedup: %f\n", elapsedTime2/elapsedTime);
  
  return 0;
}