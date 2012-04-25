/**
 * Yuri Gorokhov
 * lab 9 - Matrix Multiplication
 */

#include <stdio.h>
#include <cuda.h>
#include <math.h>

#include "../include/cuda_util.h"

#define MAT_SIZE 4

__global__ void matrix_mult(int*, int*, int);
__global__ void matrix_mult(float*, float*, int);

int main(void) {
  cudaEvent_t start, stop;
  float elapsedTime;
  
  // Alocate matrices
  int *mat1, *mat2, *dev_mat1, *dev_mat2;
  mat1 = (int*)malloc(sizeof(int) * MAT_SIZE * MAT_SIZE);
  mat2 = (int*)malloc(sizeof(int) * MAT_SIZE * MAT_SIZE);
  
  // Copy matrices to device
  cudasafe( cudaMalloc((void**)&dev_mat1, sizeof(int) * MAT_SIZE * MAT_SIZE), "cudaMalloc" );
  cudasafe( cudaMalloc((void**)&dev_mat2, sizeof(int) * MAT_SIZE * MAT_SIZE), "cudaMalloc" );
  cudasafe( cudaMemcpy(dev_mat1, mat1, sizeof(int) * MAT_SIZE * MAT_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(dev_mat2, mat2, sizeof(int) * MAT_SIZE * MAT_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" )
  
  // Start the kernel
  cudaEventCreate(&start);
  cudaEventCreate(&stop);
  cudaEventRecord(start,0);
  
  
  
  cudaEventRecord(stop, 0);
  cudaEventSynchronize(stop);
  cudaEventElapsedTime(&elapsedTime, start, stop);
}

__global__ void matrix_mult(int *matrix1, int *matrix2, int size) {
}

__global__ void matrix_mult(float *matrix1, float *matrix2, int size) {
}

