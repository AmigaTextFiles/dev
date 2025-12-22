#
# Makefile for SmartReadArgs
#
# $VER: Makefile 1.0 (1.9.98)
#
# Written by Thomas Aglassinger
#

#
# Type 'gg:bin/make' to compile
#

#
# Sets of compiler options that can be useful. If you don't like a certain set 
# (e.g. because you don't want debug output), comment them out by inserting a
# hash (#) as first character of the line where the symbol is declared.
#

DEBUG	= -DDEBUG_CODE=1
OPTIMIZE= 
WARNINGS= -Wall -ansi

#
# Commands and compiler flags required for compilation
#

RM	= delete quiet
CC	= gcc
CFLAGS	= $(DEBUG) $(OPTIMIZE) $(WARNINGS)
LDFLAGS	= -noixemul -lamiga

OBJECTS	= SmartReadArgs.o test.o
PROGRAM	= test

#
# Default rule to compile everything
#

all : $(PROGRAM)

#
# Compile stuff
#

%.o : %.c
	$(CC) $(CFLAGS) -c $*.c

test : SmartReadArgs.o test.o
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJECTS) -o $(PROGRAM)

clean :
	-$(RM) $(OBJECTS)

sterile : clean
	-$(RM) $(PROGRAM)

rebuild : clean all

#
# Private rules
#

depend :
	MkDepend VERBOSE #?.c

# --- DO NOT MODIFY THIS LINE -- AUTO-DEPENDS FOLLOW ---
SmartReadArgs.o : SmartReadArgs.h debug.h

test.o : SmartReadArgs.h debug.h

# --- DO NOT MODIFY THIS LINE -- AUTO-DEPENDS PRECEDE ---
