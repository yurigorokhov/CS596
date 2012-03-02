CC=nvcc
CFLAGS=-c -g
LDFLAGS=-L/usr/lib/nvidia-current

lab4: lab4.o
	$(CC) $(LDFLAGS) lab4.o -o lab4.exe
    
lab4.o: lab4.cu
	$(CC) $(CFLAGS) lab4.cu
    
clean:
	rm -rf lab4 lab4.o

