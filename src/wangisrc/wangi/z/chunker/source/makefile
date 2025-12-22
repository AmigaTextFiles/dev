#
# Unix Makefile for chunker
#
#

# CC - Compiler command, CC by default but often gcc is a better choice.
CC = CC
#CC = gcc

# LINKER - Linker command
LINKER = $(CC)

# COMPILEOPTS - Options to pass to the compiler
COMPILEOPTS = -c

# LINKOPTS - options to pass when linking
LINKOPTS = 

OPTIMISE = -O2

all: dechunk chunker

chunker: chunker.o machine.o bfn.o
	$(LINKER) $(LINKOPTS) $(OPTIMISE) -o $@ chunker.o machine.o bfn.o

dechunk: dechunk.o machine.o bfn.o
	$(LINKER) $(LINKOPTS) $(OPTIMISE) -o $@ dechunk.o machine.o bfn.o

machine.o: machine.c
	$(CC) $(COMPILEOPTS) $(OPTIMISE) -c machine.c

bfn.o: bfn.c
	$(CC) $(COMPILEOPTS) $(OPTIMISE) -c bfn.c

chunker.o: chunker.c
	$(CC) $(COMPILEOPTS) $(OPTIMISE) -c chunker.c

dechunk.o: dechunk.c
	$(CC) $(COMPILEOPTS) $(OPTIMISE) -c dechunk.c

clean:
	rm *.o
