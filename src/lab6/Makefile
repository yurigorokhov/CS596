CC=nvcc
CFLAGS=-c -g
LDFLAGS=-L/usr/lib/nvidia-current

lab6: lab6.o
	$(CC) $(LDFLAGS) lab6.o -o lab6.exe
    
lab6.o: lab6.cu
	$(CC) $(CFLAGS) lab6.cu
    
clean:
	rm -rf lab6 lab6.o

