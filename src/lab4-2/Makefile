CC=nvcc
CFLAGS=-c -g
LDFLAGS=-L/usr/lib/nvidia-current

lab4-2: lab4-2.o
	$(CC) $(LDFLAGS) lab4-2.o -o lab4-2.exe
    
lab4-2.o: lab4-2.cu
	$(CC) $(CFLAGS) lab4-2.cu
    
clean:
	rm -rf lab4-2 lab4-2.o

