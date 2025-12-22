# makefile for Lattice/SAS C
#
#  Just type make to build all of the example programs in this directory.
#

# want any optimizations?  turn them on here...
CFLAGS =

all : Screens Windows BoolGadget StringGadget  Demo Gadgets

Screens : screens.o
	blink lib:c.o Screens.o /src/ez.lib LIB lib:lc.lib lib:amiga.lib

screens.o : screens.c
	lc $(CFLAGS) screens.c


Windows : windows.o
	blink lib:c.o Windows.o /src/ez.lib LIB lib:lc.lib lib:amiga.lib

windows.o : windows.c
	  lc $(CFLAGS) windows.c

BoolGadget : boolgadget.o
	   blink lib:c.o BoolGadget.o /src/ez.lib LIB lib:lc.lib lib:amiga.lib

boolgadget.o : boolgadget.c
	     lc $(CFLAGS) boolgadget.c

StringGadget : stringgadget.o
	     blink lib:c.o StringGadget.o /src/ez.lib LIB lib:lc.lib lib:amiga.lib

stringgadget.o : stringgadget.c
	       lc $(CFLAGS) stringgadget.c

Demo : demo.o
	 blink lib:c.o Demo.o /src/ez.lib LIB lib:lc.lib lib:amiga.lib

demo.o : demo.c
	 lc $(CFLAGS) demo.c

Gadgets : Gadgets.o
	 blink lib:c.o Gadgets.o /src/ez.lib LIB lib:lc.lib lib:amiga.lib

Gadgets.o : Gadgets.c
	  lc $(CFLAGS) gadgets.c

