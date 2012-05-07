CC=nvcc
CFLAGS=-c -g
LDFLAGS=-L/usr/lib/nvidia-current

lab3-1: lab3-1.o
	$(CC) $(LDFLAGS) lab3-1.o -o lab3-1.exe
    
lab3-1.o: lab3-1.cu
	$(CC) $(CFLAGS) lab3-1.cu
    
clean:
	rm -rf lab3-1 lab3-1.o lab3-1.exe

