CC = gcc -mcrt=newlib
CFLAGS = -O2 -Wall -DNO_DEBUG
OBJS = listarchive.o
APP = listarchive
LIBS = -lunrar -lunix

$(APP): $(OBJS)
	$(CC) -o $@ $^ $(LIBS)
