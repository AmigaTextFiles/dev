########################################################
# :ts=8
# Makefile for example. Target: AOS68K kickstart v33/34
# using GNU make 3.81 (SAS/C compiled)
#
#----------------------------------------------------
# To compile the source using this makefile, run a:
#   AmigaDOS shell (sh etc. not required to start this)
# Type:
#   cd dosgv
#   stack 81920
#   make [clean]
#----------------------------------------------------
# $Id: makefile, v1.0 2018/30/5 23:12:04 -=ONIX=- Exp $
########################################################

######## Setup ########

# Target will be created inside sources tree
PGMNAME		= example
EXTENSION	=

# Target's name
TARGET	= $(PGMNAME)$(EXTENSION)

# Additional commands used
MKDIR		= MakeDir
RM		= Delete
RMOPTS		= ALL QUIET

# The strip command
STRIP = strip

# We are using the compiler for 16 bit targets!!!
CC = vbccm68ks

# Compiler runs w/o config file, thus we have to specify the low-level
# flags for optimisations on our own!
CFLAGS = -quiet -c99 -Ivincludeos1: -I"" -cpu=68000 -O=991 -sc -sd

# The linker used to produce the executable (linkage)
LNK = vlink

# The required linker flags we have to use (again, no config file!)
LNKFLAGS  = -nostdlib -bamigahunk -s -x -Bstatic -Cvbcc -Z -Lvlibos1: -lamigas -lvcs

#Assembler
AS = vasmm68k_mot

#Assembler flags
ASFLAGS	= -quiet -Fhunk -kick1hunks -phxass


# NOTE: The two lonely objects
######## Object files for the linker to be created ########
######## Link order is important as we use no startup-code!
OBJS =	example.o	\
	dosgv.o

######## Executeable file to be created ########
all:	$(TARGET)

$(TARGET):	$(OBJS)
	$(LNK)  $(LNKFLAGS) -o $(TARGET) $(OBJS)

######## Clean up ########
# Don't know whether .PHONY is supported...
clean: FORCE
	-@$(RM) $(RMOPTS) example.a
	-@$(RM) $(RMOPTS) $(OBJS)
FORCE:

######## Not really required - strip executable ########
strip: FORCE
	-@$(STRIP) --strip-unneeded -R.comment $(TARGET)
FORCE:

######## Dependencies ########
# NOTE: Because we are going to ignore the frontend (vc), we have to specify
#	both, the compiler generated (.a) and assembler (.o) object files.
example.a:	example.c	gvo.h
	$(CC) $(CFLAGS) -o=$@ $<
example.o:	example.a
	$(AS) $(ASFLAGS) -o $@ $<
dosgv.o:	dosgv.a
	$(AS) $(ASFLAGS) -o $@ $<
