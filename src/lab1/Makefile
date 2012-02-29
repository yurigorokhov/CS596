CC=nvcc
CFLAGS=-c -g
LDFLAGS=-L/usr/lib/nvidia-current

lab1: lab1.o
	$(CC) $(LDFLAGS) lab1.o -o lab1.exe
    
lab1.o: lab1.cu
	$(CC) $(CFLAGS) lab1.cu
    
clean:
	rm -rf lab1 lab1.o

