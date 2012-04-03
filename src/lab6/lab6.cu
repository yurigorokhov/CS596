/**
 * Yuri Gorokhov
 * lab 6 - memcpy
 */

#include <stdio.h>
#include <cuda.h>
#include <math.h>

#define ARRAY_SIZE 10000

//__global__ void kernel_mod(int);

int main(void) {
  
  for(int i = 1; i <= 7; i++) {
    int num_arr = pow(2,i);
    int ** arrays = (int**)malloc(sizeof(int) * num_arr);
    int ** Darrays = (int**)malloc(sizeof(int) * num_arr)
    
    // allocate the arrays
    for(int k = 0; k < num_arr; k++) {
      arrays[k] = (int*)malloc(sizeof(int) * ARRAY_SIZE);
    }

    for(int k = 0; k < num_arr; k++) {
      cudasafe( cudaMemcpy(Darrays[k], arrays[k], sizeof(int) * ARRAY_SIZE, "") , "cudaMemcpy");
    }
    
  }
  return 0;
}

