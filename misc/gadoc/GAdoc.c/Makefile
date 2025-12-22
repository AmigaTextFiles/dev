
# 				GAdoc Feb 1995
#
# Makefile for the ``Get AutoDOC'' program (c) by Gerhard Leibrock, 1995
#
# It extracts the autodocs from a given file and generates a texinfo file
# that consists of two parts: "<name>.menu" and "<name>.data"
#

SFLAGS	= -O2 -Wall -pedantic

# Remove this line if you do not compile on an Amiga
AFLAGS  = -noixemul

.c.o:
	gcc $(CFLAGS) $(SFLAGS) -c $*.c


all:	 gadoc

gadoc: main.c
	gcc -o gadoc $(SFLAGS) $(AFLAGS) main.c

clean:
	$(RM) $(OBJ)

