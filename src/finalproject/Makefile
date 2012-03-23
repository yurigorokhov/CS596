CC = nvcc
LDFLAGS = -L/usr/lib/nvidia-current
CCFLAGS = -g
OBJS = shortestpath.o stack.o 
TARGET = shortestpath.exe

shortestpath: $(OBJS)
	$(CC) $(CCFLAGS) $(LDFLAGS) -o $(TARGET) $(OBJS)

shortestpath.o:	shortestpath.cu
		$(CC) $(CCFLAGS) $(LDFLAGS) -c shortestpath.cu

stack.o:	stack.cu stack.h
		$(CC) $(CCFLAGS) $(LDFLAGS) -c stack.cu

clean:
		rm -f $(OBJS) $(TARGET)
