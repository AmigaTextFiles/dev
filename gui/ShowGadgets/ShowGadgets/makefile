#
# Compiler flags and linker flags
#
cf =
lf =
#
# The real make stuff
#
ShowGadgets: ShowGadgets.o
	blink ShowGadgets.o to ShowGadgets lib lib:amiga.lib
ShowGadgets.o: ShowGadgets.c
	lc $(cf) -v -cms ShowGadgets
