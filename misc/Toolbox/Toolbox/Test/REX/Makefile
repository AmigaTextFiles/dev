# Makefile for bmake 1.4 from Beng Eng

TOOLBOX = toolbox:
TOOL = $(TOOLBOX)bin
REUSE = $(TOOLBOX)lib
INCLUDE = $(REUSE)/include
OP = -I$(INCLUDE)
CC = gcc $(OP)

all: scanner


# Scanner
##############################################################
scanner:	Scanner.o Source.o ScannerDrv.o
	$(CC) -o scanner Scanner.o Source.o ScannerDrv.o -L$(INCLUDE) -lreuse

Scanner.c:	modula.c
	$(TOOL)/rex -csd modula.c

Scanner.o Source.o ScannerDrv.o: $*.c
	$(CC) -c $*.c

clean:
	-rm s#? #?.info
