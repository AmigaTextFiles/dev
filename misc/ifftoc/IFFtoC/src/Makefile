# Makefile for IFF2C for GCC-PPC
# created 25-Feb-2004 by Alfred Faust

CFLAGS = -O2
LDFLAGS =

CC = gcc
OBJECTS = unpacker.o ilbmr.o iffr.o iffw.o iff2c.o readpict.o remalloc.o main.o
CCFLAGS = -I. -I$(srcdir)
all: $(OBJECTS)
	gcc  $(LDFLAGS) -o iff2c  $(OBJECTS)

main.o:     main.c
iff2c.o:    iff2c.c
readpict.o: readpict.c
remalloc.o: remalloc.c
iffw.o:     iffw.c
iffr.o:     iffr.c
ilbmr.o:    ilbmr.c
unpacker.o: unpacker.c
