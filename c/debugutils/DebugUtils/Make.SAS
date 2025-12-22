#  Makefile for compiling and linking the debugging facilities.

CC = lc
LD = blink

CFLAGS   	= -ff 
LDFLAGS  	=  
DBFLAGS		= -dDEBUG

LIBS     	=  lib:lcmffp.lib lib:lc.lib lib:amiga.lib
DEBUGLIBS	=	lib:debug.lib lib:ddebug.lib
TRACELIB		=	trace.lib

PROGS    	=  debug tDB test
LIB			=	trace.lib

all:     $(PROGS) $(LIB)

debug: debug.o
   $(LD) lib:c.o debug.o to debug lib $(LIBS) $(DEBUGLIBS) $(LDFLAGS)

debug.o: debug.c debug.h trace.h
   $(CC) $(CFLAGS) debug.c

tDB: tDB.o
   $(LD) lib:c.o tDB.o to tDB lib $(LIBS) $(LDFLAGS)

tDB.o: tDB.c debug.h trace.h
   $(CC) $(CFLAGS) tDB.c

trace.lib: trace.o
	oml trace.lib r trace.o

trace.o: trace.c debug.h trace.h
	$(CC) $(CFLAGS) trace.c

test: test.o trace.lib
	$(LD) lib:c.o test.o to test lib $(TRACELIB) $(LIBS)

test.o: test.c debug.h
	$(CC) $(CFLAGS) $(DBFLAGS) test.c
