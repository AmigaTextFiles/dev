#***************************************************************************
#==========================================================================*
#=																		  =*
#=					Profyler v1.0 © 2022 by Mike Steed					  =*
#=																		  =*
#==========================================================================*
#==========================================================================*
#=																		  =*
#=	Makefile for LibProfyle						Last modified 13-Jan-22	  =*
#=																		  =*
#==========================================================================*
#***************************************************************************

### Build-time options

# Define this to override default of 100. See definition in code for details.
#QUANTUM = -DCALL_STACK_QUANTUM=200

### C library to be used

LIB = -mcrt=newlib
#LIB = -mcrt=clib2

### Compiler and options

CC = gcc
CFLAGS = -Wfatal-errors -Wall -O3 -fPIC -fno-strict-aliasing $(LIB)

### Librarian

AR = ar -r

### Build the library

libprofyle.a: Profyle.o
	$(AR) $@ $^

### Build the component object files

Profyle.o: Profyle.c ProfyleData.h Makefile
	$(CC) $(CFLAGS) $(QUANTUM) -c $< -o $@

