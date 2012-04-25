CC=nvcc
CFLAGS=-c -g
LDFLAGS=-L/usr/lib/nvidia-current

lab9: lab9.o
	$(CC) $(LDFLAGS) lab9.o -o lab9.exe
    
lab9.o: lab9.cu
	$(CC) $(CFLAGS) lab9.cu
    
clean:
	rm -rf lab9 lab9.o *.exe

