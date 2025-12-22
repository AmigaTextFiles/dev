
CFLAGS = 


all:		caz cazmne.o calc.o # cmddbg

clean:		*.o

.c.o:
	dcc $(CFLAGS) -o $*.o -c $*.c

caz:	caz.o cazmne.o calc.o
		dcc $(CFLAGS) -o caz caz.o cazmne.o calc.o

caz.o:		caz.c defs.h caz.h cazerrors.h
cazmne.o:   cazmne.c defs.h caz.h
calc.o:		calc.c calc.h

caz.lha: caz.c caz.h defs.h cazmne.c calc.c calc.h makefile cazerrors.h
		lha a caz.lha caz.c caz.h defs.h cazerrors.h cazmne.c calc.c calc.h makefile caz.dok cmddbg.c error.dok intelhex makefile testsrc.* testlab.*
