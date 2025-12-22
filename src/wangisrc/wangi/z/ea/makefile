#
# Unix Makefile for chunker
#
#

CC = CC
OPTIMISE = -O2

all: dechunk chunker

chunker: chunker.o machine.o bfn.o
	$(CC) $(OPTIMISE) -o $@ chunker.o machine.o bfn.o

dechunk: dechunk.o machine.o bfn.o
	$(CC) $(OPTIMISE) -o $@ dechunk.o machine.o bfn.o

machine.o: machine.c
	$(CC) $(OPTIMISE) -c machine.c

bfn.o: bfn.c
	$(CC) $(OPTIMISE) -c bfn.c

chunker.o: chunker.c
	$(CC) $(OPTIMISE) -c chunker.c

dechunk.c: dechunk.c
	$(CC) $(OPTIMISE) -c dechunk.c

clean:
	rm *.o
