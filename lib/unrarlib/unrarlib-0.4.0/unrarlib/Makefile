CC=gcc -mcrt=newlib
CFLAGS=-O2 -g -Wall
TARGET=libunrar.a
OBJS=unrarlib.o

$(TARGET): $(OBJS)
	ar -crv $@ $^

clean:
	delete $(OBJS)
