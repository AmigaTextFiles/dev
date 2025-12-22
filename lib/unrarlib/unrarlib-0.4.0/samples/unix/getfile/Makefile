CC = gcc -mcrt=newlib
CFLAGS = -O2 -Wall -DNO_DEBUG
OBJS = getfile.o
APP = getfile
LIBS = -lunrar -lunix

$(APP): $(OBJS)
	$(CC) -o $@ $^ $(LIBS)
