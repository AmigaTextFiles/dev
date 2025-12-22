# makefile for Aztec C
# NOTE: You _must_ create the file header.h in the EzLib source directory
# as these files depend on a pre-compiled header file that exists there.

CFLAGS = -hi/src/header.h

all : Screens Windows BoolGadget StringGadget  Demo Gadgets

Screens : screens.o
	ln +Q Screens /src/ez.lib -lc

screens.o : screens.c
	cc $(CFLAGS) screens


Windows : windows.o
	ln +Q Windows /src/ez.lib -lc

windows.o : windows.c
	  cc $(CFLAGS) windows

BoolGadget : boolgadget.o
	   ln +Q BoolGadget.o /src/ez.lib -lc

boolgadget.o : boolgadget.c
	     cc $(CFLAGS) boolgadget

StringGadget : stringgadget.o
	     ln +Q StringGadget /src/ez.lib -lc

stringgadget.o : stringgadget.c
	       cc $(CFLAGS) stringgadget.c

Demo : demo.o
	 ln +Q Demo /src/ez.lib -lc

demo.o : demo.c
	 cc $(CFLAGS) demo.c

# gadgets has some imagery that needs to be in Chip Ram, hence the
# +cdb arguments (put initialized data in chip memory)
Gadgets : Gadgets.o
	 ln +Q +cdb Gadgets /src/ez.lib -lc

Gadgets.o : Gadgets.c
	  cc $(CFLAGS) gadgets.c

