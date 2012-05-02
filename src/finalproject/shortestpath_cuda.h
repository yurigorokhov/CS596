/**
 * Yuri Gorokhov
 * final project - Shortest path
 */

/*
 * Path is returned as 1 for right, 0 for down
 * Note: this algorithm goes from top left to bottom right corner
 */
__global__ void shortest_path_cuda(int * mat, int * shortestpath, int * result, int * matrix, int i) {
  
  int x = blockIdx.x * BLOCK_SIZE + threadIdx.x;
  if(x == 0 && i == 1) {
    matrix[0] = mat[0];
  }
    
    // only use the threads we need
    if(x <= i) {
      int idx = x * MAT_SIZE + i - x;
      if(x == 0) {
	matrix[idx] = matrix[idx-1] + mat[idx];
      } else if(i - x == 0) {
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

__global__ void shortest_path_cuda_2(int * mat, int * shortestpath, int * result, int * matrix, int i) { 
    int x = blockIdx.x * BLOCK_SIZE + threadIdx.x;
    
    // only use the threads we need
    if(x < MAT_SIZE - i) {
      int idx = (MAT_SIZE - x - 1) + (x + i) * MAT_SIZE;
      int path1 = idx - 1;
      int path2 = idx - MAT_SIZE;
      matrix[idx] = matrix[path1] < matrix[path2] 
		    ? matrix[path1] + mat[idx] 
		    : matrix[path2] + mat[idx];
    }
    if(threadIdx.x == 0 && i == MAT_SIZE-1) {
      *shortestpath = matrix[MAT_SIZE * MAT_SIZE - 1];
    }
}

__global__ void shortest_path_cuda_3(int * mat, int * shortestpath, int * result, int * matrix) {
  if(threadIdx.x == 0) {
    //*shortestpath = matrix[MAT_SIZE * MAT_SIZE - 1];

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
}