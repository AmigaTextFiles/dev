#######################################################################
# Makefile for HEARTBEAT			(C) L. Vanhelsuwé
# ----------------------			-----------------
# 19-MAY-1994
#
#######################################################################

PROGRAM = HB

ASDIR = B:DEVEL/Devpac
ASSEM = $(ASDIR)/Genam

# List all the object modules that are needed to build $(PROGRAM)
# (Order is not important since that's handled by .WTH file passed to BLink)

OBJ = HB.o func.o cload_file.o

.s.o:
	$(ASSEM) $* -VP=68030 -D -L -Iinclude: -H$(ASDIR)/system2.gs
.c.o:
	SC:C/sc $*.c 

$(PROGRAM):  $(OBJ) 
	SC:C/slink WITH HB.wth

# First of all the dependencies of the program modules

func.o:		INCLUDE:std

# Then finally the dependencies for the main module.

HB.o:		SCOPTIONS

cload_file.o:	SCOPTIONS
