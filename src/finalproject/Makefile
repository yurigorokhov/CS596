CC = nvcc
LDFLAGS = -L/usr/lib/nvidia-current
CCFLAGS = -g
OBJS = shortestpath.o stack.o 
TARGET = shortestpath.exe

shortestpath: $(OBJS)
	$(CC) $(CCFLAGS) $(LDFLAGS) -o $(TARGET) $(OBJS)

shortestpath.o:	shortestpath_cuda.cu
		$(CC) $(CCFLAGS) $(LDFLAGS) -c shortestpath_cuda.cu -o shortestpath.o

stack.o:	stack.cu stack.h
		$(CC) $(CCFLAGS) $(LDFLAGS) -c stack.cu -o stack.o

clean:
		rm -f $(OBJS) $(TARGET)
