#
#        Makefile for FarPrint (Aztec C v5.2a)
#
# Macros
#
SYMBOLS    =ram:farprint.pre
CFLAGS_PRE =-a -ps -ho $(SYMBOLS)
CFLAGS     =-ms -pcs -so -wdelopqw -hi $(SYMBOLS)
LFLAGS     =-m +q
LOBJECTS   =farcom1.o farcom2.o
POBJECTS   =main.o msg.o serial.o req.o
LIBRARIES  =arpdetach16.o -larp16 -lc16
#
# Dependancy entries
#
all:	$(SYMBOLS) farprint.lib farprint fartest1 fartest2 clear
#
$(SYMBOLS):	farprint.pre
	copy farprint.pre $@ clone
#
farprint.pre:	includes.h
	cc $(CFLAGS_PRE) -o nil: includes.h
	copy ram:$@ $@ clone
#
farprint.lib:	$(LOBJECTS)
	lb $@ $(LOBJECTS)
#
farprint:	$(POBJECTS)
	ln $(LFLAGS) -o $@ $(POBJECTS) $(LIBRARIES)
#
fartest1:	fartest1.o
	ln $(LFLAGS) -o $@ $*.o -lfarprint -lc16

fartest2:	fartest2.o
	ln $(LFLAGS) -o $@ $*.o -lfarprint -lc16
#
cleanup:
	Copy farprint.lib sys:aztecc/lib/
	Copy farprint.lib sys:aztecc/lib/farprint16.lib
	Copy farprint.h sys:aztecc/include/libraries/
	Copy FarPrint c:
	Delete (#?.pre|#?.o)
#
clear:
	Delete $(SYMBOLS)
#
