/**
 * Yuri Gorokhov
 * lab 9 - Matrix Multiplication
 */

#include <stdio.h>
#include <cuda.h>
#include <math.h>

#include "../include/cuda_util.h"

#define MAT_SIZE 16
#define BLOCKS 4
#define BLOCK_SIZE MAT_SIZE/BLOCKS
#define THREADS_PER_BLOCK (MAT_SIZE/BLOCKS)*(MAT_SIZE/BLOCKS)

__global__ void matrix_mult_int(int*, int*, int*, int);
__global__ void matrix_mult_float(float*, float*, float*, int);

int main(void) {
  cudaEvent_t start, stop;
  float elapsedTime;
  
  // Alocate matrices
  int *mat1, *mat2, *result, *dev_mat1, *dev_mat2, *dev_result_mat;
  mat1 = (int*)malloc(sizeof(int) * MAT_SIZE * MAT_SIZE);
  mat2 = (int*)malloc(sizeof(int) * MAT_SIZE * MAT_SIZE);
  result = (int*)malloc(sizeof(int) * MAT_SIZE * MAT_SIZE);
  
  // Copy matrices to device
  cudasafe( cudaMalloc((void**)&dev_mat1, sizeof(int) * MAT_SIZE * MAT_SIZE), "cudaMalloc" );
  cudasafe( cudaMalloc((void**)&dev_mat2, sizeof(int) * MAT_SIZE * MAT_SIZE), "cudaMalloc" );
  cudasafe( cudaMalloc((void**)&dev_result_mat, sizeof(int) * MAT_SIZE * MAT_SIZE), "cudaMalloc" );
  cudasafe( cudaMemcpy(dev_mat1, mat1, sizeof(int) * MAT_SIZE * MAT_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(dev_mat2, mat2, sizeof(int) * MAT_SIZE * MAT_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  
  // Start the kernel
  cudaEventCreate(&start);
  cudaEventCreate(&stop);
  dim3 threadsPerBlock(THREADS_PER_BLOCK, THREADS_PER_BLOCK);
  dim3 blocks(MAT_SIZE / threadsPerBlock.x, MAT_SIZE / threadsPerBlock.y);
  cudaEventRecord(start,0);
  matrix_mult_int<<<blocks, threadsPerBlock>>>(dev_mat1, dev_mat2, dev_result_mat, MAT_SIZE);
  cudaEventRecord(stop, 0);
  cudaEventSynchronize(stop);
  cudaEventElapsedTime(&elapsedTime, start, stop);
  printf("Time elapsed (int): %f\n", elapsedTime);
  
  // Copy the result matrix
  cudasafe( cudaMemcpy(result, dev_result_mat, sizeof(int) * MAT_SIZE * MAT_SIZE, cudaMemcpyDeviceToHost), "cudaMemcpy" );
  cudasafe( cudaFree(dev_mat1) ,"cudaFree");
  cudasafe( cudaFree(dev_mat2) ,"cudaFree");
  cudasafe( cudaFree(dev_result_mat) ,"cudaFree");
  
  // Alocate matrices
  float *mat1_f, *mat2_f, *result_f, *dev_mat1_f, *dev_mat2_f, *dev_result_mat_f;
  mat1_f = (float*)malloc(sizeof(float) * MAT_SIZE * MAT_SIZE);
  mat2_f = (float*)malloc(sizeof(float) * MAT_SIZE * MAT_SIZE);
  result_f = (float*)malloc(sizeof(float) * MAT_SIZE * MAT_SIZE);
  
  // Copy matrices to device
  cudasafe( cudaMalloc((void**)&dev_mat1_f, sizeof(float) * MAT_SIZE * MAT_SIZE), "cudaMalloc" );
  cudasafe( cudaMalloc((void**)&dev_mat2_f, sizeof(float) * MAT_SIZE * MAT_SIZE), "cudaMalloc" );
  cudasafe( cudaMalloc((void**)&dev_result_mat_f, sizeof(float) * MAT_SIZE * MAT_SIZE), "cudaMalloc" );
  cudasafe( cudaMemcpy(dev_mat1_f, mat1_f, sizeof(float) * MAT_SIZE * MAT_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  cudasafe( cudaMemcpy(dev_mat2_f, mat2_f, sizeof(float) * MAT_SIZE * MAT_SIZE, cudaMemcpyHostToDevice), "cudaMemcpy" );
  
  // Start the kernel
  cudaEventCreate(&start);
  cudaEventCreate(&stop);
  cudaEventRecord(start,0);
  matrix_mult_float<<<blocks, threadsPerBlock>>>(dev_mat1_f, dev_mat2_f, dev_result_mat_f, MAT_SIZE);
  cudaEventRecord(stop, 0);
  cudaEventSynchronize(stop);
  cudaEventElapsedTime(&elapsedTime, start, stop);
  printf("Time elapsed (float): %f\n", elapsedTime);
  
  // Copy the result matrix
  cudasafe( cudaMemcpy(result_f, dev_result_mat_f, sizeof(float) * MAT_SIZE * MAT_SIZE, cudaMemcpyDeviceToHost), "cudaMemcpy" );
  cudasafe( cudaFree(dev_mat1_f) ,"cudaFree");
  cudasafe( cudaFree(dev_mat2_f) ,"cudaFree");
  cudasafe( cudaFree(dev_result_mat_f) ,"cudaFree");
}

__global__ void matrix_mult_int(int *matrix1, int *matrix2, int *result, int size) {
  int col = blockIdx.x * BLOCK_SIZE + threadIdx.x;
  int row = blockIdx.y * BLOCK_SIZE + threadIdx.y;
  
  int sum = 0;
  for(int i = 0; i < size; i++) {
    sum += matrix1[row*size+i]*matrix2[col+size*i];
  }
  result[row*size + col] = sum;
  __syncthreads();
}

__global__ void matrix_mult_float(float *matrix1, float *matrix2, float *result, int size) {
  int col = blockIdx.x * BLOCK_SIZE + threadIdx.x;
  int row = blockIdx.y * BLOCK_SIZE + threadIdx.y;
  
  float sum = 0;
  for(int i = 0; i < size; i++) {
    sum += matrix1[row*size+i]*matrix2[col+size*i];
  }
  result[row*size + col] = sum;
  __syncthreads();
}