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
  int shortestpath = shortest_path_cpu(&mat, &result);
  
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
int shortest_path_cpu(Matrix * mat, Stack *result) {
  
  // Create temp matrix to store the path sums
  Matrix sum_matrix;
  int cols = mat->columns;
  sum_matrix.columns = cols;
  sum_matrix.array = (int*)malloc(cols * cols * sizeof(int));
  for(int i = 0; i < MAT_SIZE * MAT_SIZE; i++)
    sum_matrix.array[i] = 0;
  
  // Initialize corner-most element
  sum_matrix.array[0] = mat->array[0];
  
  // Calculate sum of first half
  for(int i = 1; i < cols; i++) {
    for(int j = i, k = 0; j >= 0; j--, k++) {
      
      // record the shortest path to current node
      if(j == 0) {
	sum_matrix.array[cols * k + j] = sum_matrix.array[cols * (k-1) + j] + mat->array[cols * k + j];
      } else if(k == 0) {
	sum_matrix.array[cols * k + j] = sum_matrix.array[cols * k + j-1] + mat->array[cols * k + j];
      } else {
	int path1 = sum_matrix.array[cols * (k-1) + j];
	int path2 = sum_matrix.array[cols * k + j-1];
	if(path1 <= path2) {
	  sum_matrix.array[cols * k + j] = path1 + mat->array[cols * k + j];
	} else {
	  sum_matrix.array[cols * k + j] = path2 + mat->array[cols * k + j];
	}
      }
    }
  }
  
   // Calculate sum of second half
  for(int i = 1; i < cols; i++) {
    for(int j = i, k = cols-1; j < cols; j++, k--) {
      
      // record the shortest path to current node
	int path1 = sum_matrix.array[cols * (k-1) + j];
	int path2 = sum_matrix.array[cols * k + j-1];
	if(path1 <= path2) {
	  sum_matrix.array[cols * k + j] = path1 + mat->array[cols * k + j];
	} else {
	  sum_matrix.array[cols * k + j] = path2 + mat->array[cols * k + j];
	}
    }
  }
  
  int shortestpath = sum_matrix.array[cols*cols-1];
  
  // Put shortest path onto stack
  int j = cols-1, k = cols-1;
  while(j > 0 || k > 0) {
    if(j == 0) {
      k--;
      push(result, 0);
    } else if(k == 0) {
      j--;
      push(result, 1);
    } else {
      int path1 = sum_matrix.array[cols * (k-1) + j];
      int path2 = sum_matrix.array[cols * k + j-1];
      if(path1 < path2) {
	k--;
	push(result, 0);
      } else {
	j--;
	push(result, 1);
      }
    }
  }
  
  free(sum_matrix.array);
  return shortestpath;
}



