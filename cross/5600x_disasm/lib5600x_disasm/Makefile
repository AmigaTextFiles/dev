#
# Makefile for 5600x_disasm library.
#


SRCL	= 5600x_disasm.c
OBJL	= 5600x_disasm.o

SRC	= test.c
OBJ	= test.o

# for big endian architectures (SGI/Sun/Amiga)
#CFLAGS	= -O -DBIGENDIAN

CFLAGS	= -O

# miscellaneous OS-dependent stuff
#CC	= gcc

# linker
LN	= $(CC)

# file deletion command
RM	= rm -f

# library (.a) file creation command
AR	= ar rc

# second step in .a creation (use "touch" if not needed)
AR2	= ranlib


PROGRAMS = 5600x_disasm.a test

all:	$(PROGRAMS)

5600x_disasm.a:	$(OBJL)
	$(RM) 5600x_disasm.a
	$(AR) 5600x_disasm.a $(OBJL)
	$(AR2) 5600x_disasm.a

test:	$(OBJ) 5600x_disasm.a
	$(LN) -o test $(OBJ) 5600x_disasm.a


clean:
	$(RM) *.o test 5600x_disasm.a

5600x_disasm.o:	5600x_disasm.c 5600x_disasm.h 
test.o:		test.c 5600x_disasm.h
