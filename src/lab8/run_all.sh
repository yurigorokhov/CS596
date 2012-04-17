#!/bin/sh

# Program 1
nvcc lab8.cu -o lab8-1.exe -L/usr/lib/nvidia-current -DGRID_Y=4 -DARRAY_SIZE=3*SHARED_MEM_PER_BLOCK/4

# Program 2
nvcc lab8.cu -o lab8-2.exe -L/usr/lib/nvidia-current -DGRID_Y=PROX -DARRAY_SIZE=3*SHARED_MEM_PER_BLOCK/4

# Program 3
nvcc lab8.cu -o lab8-3.exe -L/usr/lib/nvidia-current -DGRID_Y=2*PROX -DARRAY_SIZE=3*SHARED_MEM_PER_BLOCK/4

# Program 4
nvcc lab8.cu -o lab8-4.exe -L/usr/lib/nvidia-current -DGRID_Y=4 -DARRAY_SIZE=SHARED_MEM_PER_BLOCK/2

# Program 5
nvcc lab8.cu -o lab8-5.exe -L/usr/lib/nvidia-current -DGRID_Y=PROX -DARRAY_SIZE=SHARED_MEM_PER_BLOCK/2

# Program 6
nvcc lab8.cu -o lab8-6.exe -L/usr/lib/nvidia-current -DGRID_Y=2*PROX -DARRAY_SIZE=SHARED_MEM_PER_BLOCK/2

# Program 7
nvcc lab8.cu -o lab8-7.exe -L/usr/lib/nvidia-current -DGRID_Y=4 -DARRAY_SIZE=SHARED_MEM_PER_BLOCK/4

# Program 8
nvcc lab8.cu -o lab8-8.exe -L/usr/lib/nvidia-current -DGRID_Y=PROX -DARRAY_SIZE=SHARED_MEM_PER_BLOCK/4

# Program 9
nvcc lab8.cu -o lab8-9.exe -L/usr/lib/nvidia-current -DGRID_Y=2*PROX -DARRAY_SIZE=SHARED_MEM_PER_BLOCK/4

./lab8-1.exe
./lab8-2.exe
./lab8-3.exe
./lab8-4.exe
./lab8-5.exe
./lab8-6.exe
./lab8-7.exe
./lab8-8.exe
./lab8-9.exe

