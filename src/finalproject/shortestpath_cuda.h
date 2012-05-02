/**
 * Yuri Gorokhov
 * final project - Shortest path
 */

/*
 * Path is returned as 1 for right, 0 for down
 * Note: this algorithm goes from top left to bottom right corner
 */
__global__ void shortest_path_cuda(int * mat, int * shortestpath, int * result) {
  
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
  
  
  // Record path
  if(threadIdx.x == 0) {
    *shortestpath = matrix[MAT_SIZE * MAT_SIZE - 1];
  }/*  
    // Put shortest path onto stack
    int j = MAT_SIZE-1, k = MAT_SIZE-1;
    int index = 0;
    while(j > 0 || k > 0) {
      if(j == 0) {
	k--;
	result[index++] = 0;
      } else if(k == 0) {
	j--;
	result[index++] = 1;
      } else {
	int path1 = matrix[MAT_SIZE * (k-1) + j];
	int path2 = matrix[MAT_SIZE * k + j-1];
	if(path1 < path2) {
	  k--;
	  result[index++] = 0;
	} else {
	  j--;
	  result[index++] = 1;
	}
      }
    }
    
    // Terminate array
    result[index] = -1;
    
  }
  */
  __syncthreads(); 
}
