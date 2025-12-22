#
#       makefile for GNU Make
#
# to find Enforcer Hit, compile with -g -gstabs option, make an hit
# then use :  GccFindHit <nom_prog> <offsets>
#

CC = gcc-020

#CFLAGS = -O -m68020 -m68881 -noixemul
#CFLAGS =  -g -gstabs -noixemul
#CFLAGS = -O2 -m68000 -noixemul
#CFLAGS = -O2 -m68040 -m68881 -noixemul
#CFLAGS = -O -m68040 -m68881 -noixemul
#CFLAGS = -s -m68040 -m68881 -noixemul
CFLAGS = -s -m68000 -noixemul
#CFLAGS = -s -O2 -m68000 -noixemul
LDFLAGS =
LDFLAGS2 = -Wl,"-chip"

all: ADocReader

ADocReader: main.o cbio.o xref_gen.o xref_make.o xref_read.o DXListClass.o
	$(CC) $(CFLAGS) $(LDFLAGS) main.o DXListClass.o cbio.o xref_gen.o xref_make.o xref_read.o -o ADocReader

DXListClass.o: DXListClass.c DXListClass.h
	$(CC) $(CFLAGS) $(LDFLAGS) -c DXListClass.c

main.o: main.c cb.h xref_gen.h xref_read.h xref_make.h DXListClass.h
	$(CC) $(CFLAGS) $(LDFLAGS) -c main.c

cbio.o: cbio.c cb.h
	$(CC) $(CFLAGS) $(LDFLAGS) -c cbio.c

xref_gen.o: xref_gen.h
	$(CC) -O2 $(CFLAGS) $(LDFLAGS) -c xref_gen.c

xref_make.o: xref_make.c xref_make.h xref_gen.h
	$(CC) $(CFLAGS) $(LDFLAGS) -c xref_make.c

xref_read.o: xref_read.c xref_read.h xref_gen.h
	$(CC) $(CFLAGS) $(LDFLAGS) -c xref_read.c

clean:
	delete *.run *.o

