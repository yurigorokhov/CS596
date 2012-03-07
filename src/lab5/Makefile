CC=nvcc
CFLAGS=-c -g
LDFLAGS=-L/usr/lib/nvidia-current

lab5: lab5.o
	$(CC) $(LDFLAGS) lab5.o -o lab5.exe
    
lab5.o: lab5.cu
	$(CC) $(CFLAGS) lab5.cu
    
clean:
	rm -rf lab5 lab5.o

