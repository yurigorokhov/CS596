CC=nvcc
CFLAGS=-c -g
LDFLAGS=-L/usr/lib/nvidia-current

lab8: lab8.o
	$(CC) $(LDFLAGS) lab8.o -o lab8.exe
    
lab8.o: lab8.cu
	$(CC) $(CFLAGS) lab8.cu
    
clean:
	rm -rf lab8 lab8.o *.exe

