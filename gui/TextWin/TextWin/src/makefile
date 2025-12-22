#
# Makefile for 
#
# $Id$
# 
# IMPORTANT:  To create dependencies  -->  make depend
#
# Makefile for use with Aztec v5 and beyond.  Uses 32-bit ints
#
# $Log$
#

.SUFFIXES:	# Tell make to forget the suffixes it alreay knows

.SUFFIXES: .c .o .h

# Uncomment out this line if you want make to run quiet
#.SILENT:
.PHONY: .depend functions.h

CC = acc 
AS = as
LD = ald
MKDEP = makemake >.depend -M

#
# Set things up so we get .o files built correctly....
# (must be configured for each user)
#

#
# the usual stuff ..............
#
MODNAME= textwin
AOUT= $(MODNAME) 

CCOPTS = -wqs

INCLUDES =
CFLAGS = -bs
AFLAGS =
LFLAGS = -g
#LIBS = -lmui -lm -lc
LIBS = -lmui -lreqtools -lc

#
# Names of the directories where we find sources....
#
AMIGA =

#
# and objects....
#
LIBOBJ = +L -lamiga

#
# List of source files 
#
SRC1 = textwin.c
 
SRC2 =

SRCn = main.c

SRC  = $(SRC1) $(SRC2) $(SRCn)

#
# List of object files
#
OBJ1 = textwin.o

OBJ2 =

OBJn = main.o

OBJ = $(OBJ1) $(OBJ2) $(OBJn)

#
# THE PROGRAM (AOUT)
#

$(AOUT) : init $(OBJ)
	$(LD) $(LFLAGS) -o $(AOUT) $(OBJ) $(LIBS) $(LIBOBJ)


#
# Clean things up a little ...
#
clean:
	-delete #?.o

clobber: clean
	-delete $(AOUT)

# 
# Initilize compiler options
#
init:
	mset ccopts=$(CCOPTS)

#
# Generate prototypes
#
# We do this in multiple passes so to avoid problems with the long
# command line generate when you slap all the sources together.
#
functions.h:
	mkproto >functions.h $(SRC)

#
# Build the dependency list for the .h files used by all sources.
#
# We do this in multiple passes so to avoid problems with the long
# command line generate when you slap all the sources together.
#

.depend:
	$(MKDEP) $(INCLUDES) $(SRC)

# This is a bit of a hack for the benifit of GNU Make version 3.58.
include .depend

# File dependencies will no longer be appended after this line by
# "make depend" see above.
