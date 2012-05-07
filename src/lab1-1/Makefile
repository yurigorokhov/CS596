CC=nvcc
CFLAGS=-c -g
LDFLAGS=-L/usr/lib/nvidia-current

lab1-1: lab1-1.o
	$(CC) $(LDFLAGS) lab1-1.o -o lab1-1.exe
    
lab1-1.o: lab1-1.cu
	$(CC) $(CFLAGS) lab1-1.cu
    
clean:
	rm -rf lab1-1.exe lab1-1.o 

