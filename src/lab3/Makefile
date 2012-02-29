CC=nvcc
CFLAGS=-c -g
LDFLAGS=-L/usr/lib/nvidia-current

lab3: lab3.o
	$(CC) $(LDFLAGS) lab3.o -o lab3.exe
    
lab3.o: lab3.cu
	$(CC) $(CFLAGS) lab3.cu
    
clean:
	rm -rf lab3 lab3.o

