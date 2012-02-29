void static cudasafe( cudaError_t error, char* message)
{
   if(error!=cudaSuccess) { fprintf(stderr,"ERROR: %s: %i -> %s\n",message,error,cudaGetErrorString(error)); exit(-1); }
}
