#***************************************************************************
#==========================================================================*
#=																		  =*
#=					Profyler v1.0 © 2022 by Mike Steed					  =*
#=																		  =*
#==========================================================================*
#==========================================================================*
#=																		  =*
#=	Makefile for Profyler						Last modified 23-Nov-21	  =*
#=																		  =*
#==========================================================================*
#***************************************************************************

### Compiler and options

CC = gcc
CFLAGS = -Wfatal-errors -O2 -Wall -gstabs -idirafter SDK:MUIDev/Include \
		-idirafter ../LibProfyle

### Emulate SAS/C's __AMIGADATE__

DATESTR := $(shell Date LFORMAT "(%-d.%-m.%Y)")
AMIGADATE = -D__AMIGADATE__="$(DATESTR)"

### Linker and options

LN = gcc
LNFLAGS = -Wl,-N -Wl,-Map=Profyler.map

### External (non-system) libraries used by the program

LIBS = 

### Object files that make up the program

OBJS = Profyler.o ProfIPC.o ProfDB.o ProfGUI.o

### Files that all object files depend on

STDDEP = Profyler.h Makefile

### Build the executables

Profyler: Profyler.debug
	strip -s Profyler.debug -o Profyler

Profyler.debug: $(OBJS)
	$(LN) $(LNFLAGS) $(OBJS) $(LIBS) -lstdc++ -lamiga -o $@

### Build the object files

Profyler.o: Profyler.c ProfIPC.h ProfDB.h ProfGUI.h $(STDDEP)
	$(CC) $(CFLAGS) $(AMIGADATE) -c $< -o $@

ProfIPC.o: ProfIPC.c ProfIPC.h ProfDB.h ProfGUI.h $(STDDEP)
	$(CC) $(CFLAGS) -c $< -o $@

ProfDB.o: ProfDB.c ProfDB.h ProfGUI.h $(STDDEP)
	$(CC) $(CFLAGS) -c $< -o $@

ProfGUI.o: ProfGUI.c ProfGUI.h ProfIPC.h ProfDB.h $(STDDEP)
	$(CC) $(CFLAGS) -c $< -o $@
