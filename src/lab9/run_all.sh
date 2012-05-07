#!/bin/sh

nvcc lab9.cu -o lab9-1.exe -L/usr/lib/nvidia-current -DMAT_SIZE=16 
nvcc lab9.cu -o lab9-2.exe -L/usr/lib/nvidia-current -DMAT_SIZE=32 
nvcc lab9.cu -o lab9-3.exe -L/usr/lib/nvidia-current -DMAT_SIZE=64 
nvcc lab9.cu -o lab9-4.exe -L/usr/lib/nvidia-current -DMAT_SIZE=128 
nvcc lab9.cu -o lab9-5.exe -L/usr/lib/nvidia-current -DMAT_SIZE=256 


./lab9-1.exe
./lab9-2.exe
./lab9-3.exe
./lab9-4.exe
./lab9-5.exe

