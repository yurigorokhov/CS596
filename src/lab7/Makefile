CC=nvcc
CFLAGS=-c -g
LDFLAGS=-L/usr/lib/nvidia-current

lab7: lab7.o
	$(CC) $(LDFLAGS) lab7.o -o lab7.exe
    
lab7.o: lab7.cu
	$(CC) $(CFLAGS) lab7.cu
    
clean:
	rm -rf lab7 lab7.o

