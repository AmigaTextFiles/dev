CC = gcc
PROGS = libdl.a
CFLAGS = -Wall
LDFLAGS = -s

all:	$(PROGS)

clean:
	rm -f $(PROGS) *.o

libdl.a: libdl.o
	ar rc libdl.a libdl.o
	ranlib libdl.a
	
libdl.o: libdl.c
	$(CC) -c libdl.c -o libdl.o $(CFLAGS)

