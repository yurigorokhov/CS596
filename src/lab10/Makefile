CC=nvcc
CFLAGS=-c -g
LDFLAGS=-L/usr/lib/nvidia-current

lab10: lab10.o
	$(CC) $(LDFLAGS) lab10.o -o lab10.exe
    
lab10.o: lab10.cu
	$(CC) $(CFLAGS) lab10.cu
    
clean:
	rm -rf lab10 lab10.o *.exe

