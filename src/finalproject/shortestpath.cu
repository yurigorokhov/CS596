/**
 * Yuri Gorokhov
 * final project - Shortest path
 */

#include <stdio.h>
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

int shortest_path_cpu(Matrix*, Stack*);

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
  
  // Compute shortest path with cpu
  shortest_path_cpu(&mat, &result);
  
  // Print path taken 
  printf("\nShortest Path: ");
  while(!is_empty(&result)) {
    printf("%i, ", pop(&result));
  }
  
  return 0;
}

/*
 * Path is returned as 1 for right, 0 for down
 * @return - int shortest path
 */
int shortest_path_cpu(Matrix * mat, Stack *result) {
  
  // Create temp matrix to store the path sums
  Matrix sum_matrix;
  mat.columns = mat->columns;
  mat.array = (int*)malloc(mat->columns * mat->columns * sizeof(int)));
  for(int i = 0; i < MAT_SIZE * MAT_SIZE; i++)
    mat.array[i] = 0;
  
  // Calculate shortest path
  for(int i = 0; i < mat->columns-1; i++) {
    
  }
}



