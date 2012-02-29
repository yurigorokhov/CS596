CC=nvcc
CFLAGS=-c -g
LDFLAGS=-L/usr/lib/nvidia-current

lab2: lab2.o
	$(CC) $(LDFLAGS) lab2.o -o lab2.exe
    
lab2.o: lab2.cu
	$(CC) $(CFLAGS) lab2.cu
    
clean:
	rm -rf lab2 lab2.o

