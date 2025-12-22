
#
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

.PHONY: .depend functions.h

.SUFFIXES:	# Tell make to forget the suffixes it alreay knows

.SUFFIXES: .c .o .h

# Uncomment out this line if you want make to run quiet
#.SILENT:
 
CC = aztec:bin/cc
AS = aztec:bin/as
LD = aztec:bin/ld

MKDEP = makemake >.depend -M

CCMODE =
CCOPTS = -wqs
CFLAGS = -bs
INCLUDES =
AFLAGS =
LFLAGS =
LIBS = -lc

#============================
 
CC = gcc
AS = gcc
LD = gcc

MKDEP = makemake >.depend

CCMODE =
CCOPTS = -wqs
CFLAGS = -O2
INCLUDES =
AFLAGS =
LFLAGS =
LIBS =

#
# Set things up so we get .o files built correctly....
# (must be configured for each user)
#
 
CC = aztec:bin/acc
AS = aztec:bin/!a
LD = aztec:bin/ald

MKDEP = makemake >.depend  -M

CCMODE =
CCOPTS = -wqs
CFLAGS = -bs
INCLUDES =
AFLAGS =
LFLAGS = -g
LIBS = -lc

#
# the usual stuff ..............
#

#
# Names of the directories where we find sources....
#
AMIGA =

#
# and objects....
#
LIBOBJ = -lreqtools

#
# List of source files 
#
 
SRC1 = rtFontRequest.c rtEZRequest.c rtFileRequest.c rtGetString.c rtGetLong.c rtPaletteRequest.c rtScreenModeRequest.c

SRC2 =

SRCn =

SRC  = $(SRC1) $(SRC2) $(SRCn)

#
# List of object files
#

OBJ1 =

OBJ2 =

OBJn =

OBJ = $(OBJ1) $(OBJ2) $(OBJn)

#
# THE PROGRAM (AOUT)
#

all: rtFontRequest rtEZRequest rtFileRequest rtGetString rtGetLong rtPaletteRequest rtScreenModeRequest

rtLVRequest : rtLVRequest.o
	$(LD) $(LFLAGS) -o $@ $@.o  $(LIBOBJ) $(LIBS)

rtFontRequest : rtFontRequest.o
	$(LD) $(LFLAGS) -o $@ $@.o  $(LIBOBJ) $(LIBS)

rtEZRequest : rtEZRequest.o
	$(LD) $(LFLAGS) -o $@ $@.o  $(LIBOBJ) $(LIBS)

rtFileRequest : rtFileRequest.o
	$(LD) $(LFLAGS) -o $@ $@.o  $(LIBOBJ) $(LIBS)

rtGetString : rtGetString.o
	$(LD) $(LFLAGS) -o $@ $@.o  $(LIBOBJ) $(LIBS)

rtGetLong : rtGetLong.o
	$(LD) $(LFLAGS) -o $@ $@.o  $(LIBOBJ) $(LIBS)

rtPaletteRequest : rtPaletteRequest.o
	$(LD) $(LFLAGS) -o $@ $@.o  $(LIBOBJ) $(LIBS)

rtScreenModeRequest : rtScreenModeRequest.o
	$(LD) $(LFLAGS) -o $@ $@.o  $(LIBOBJ) $(LIBS)

# Initilize compiler options
#
# Do environment variable initilizations here. 
#

init:

	mset ccopts=$(CCOPTS)

#
# Generate prototypes
#
functions.h:
	mkproto >functions.h $(SRC)

#
#
clean:
	-delete #?.o #?.[c|h]^

clobber: clean
	-delete a.out


#
# Build the dependency list for the .h files used by all sources. We do
# this in multiple passes so to avoid problems with the long command line
# generate when you slap all the sources together.
# Note that there are faster, but more environment-dependent, ways to do
# turn the output of the makemake's into an lmkfile. We avoid those
# on purpose.
#

.depend:
	$(MKDEP) $(INCLUDES) $(SRC)

# This is a bit of a hack for the benifit of GNU Make version 3.58.
include .depend

# File dependencies will be appended after this line by "make depend"
