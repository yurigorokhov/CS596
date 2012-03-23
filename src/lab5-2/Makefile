CC=nvcc
CFLAGS=-c -g
LDFLAGS=-L/usr/lib/nvidia-current

lab5-2: lab5-2.o
	$(CC) $(LDFLAGS) lab5-2.o -o lab5-2.exe
    
lab5-2.o: lab5-2.cu
	$(CC) $(CFLAGS) lab5-2.cu
    
clean:
	rm -rf lab5-2 lab5-2.o

