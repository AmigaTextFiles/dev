# -*- makefile -*-
# Makefile for Unix with gcc compiler

CC=g++
# if you use egcs-2.90.* version of GCC please add option -fno-exceptions 
# to reduce code size and increase performance

# Debug version
#CFLAGS = -c -Wall -O0 -g 

# Optimized version
CFLAGS = -S -Wall -O6 -g

# Optimized version with switched off asserts
#CFLAGS = -c -Wall -O6 -g -DNDEBUG

#CFLAGS = -O

LFLAGS=-g

# Directory to place executables
INSTALL_DIR=/usr/local/bin

all: antic jlint

jlint.o: jlint.cpp jlint.h jlint.d jlint.msg
	$(CC) $(CFLAGS) jlint.cpp

antic.o: antic.c
	$(CC) $(CFLAGS) antic.c

antic: antic.o
	$(CC) $(LFLAGS) -o antic antic.o

jlint: jlint.o
	$(CC) $(LFLAGS) -o jlint jlint.o

clean: 
	rm -f  *.o *.exe core *~ *.his *.class jlint antic


tgz: clean
	cd ..; tar cvzf jlint.tgz jlint

copytgz: tgz
	mcopy -o ../jlint.tgz a:

install:	
	cp jlint antic $(INSTALL_DIR)
