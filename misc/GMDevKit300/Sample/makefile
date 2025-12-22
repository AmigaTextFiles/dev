# Makefile to build the vmem.library example

CFLAGS		= -cfustq -fid -ms -v -rr -O -i/Include/

LFLAGS		= 
LIBS		= LIB:lcr.lib LIB:small.lib
OBJ		= sample.o vmemsupport.o

.c.o:
		lc $(CFLAGS) $*.c

All:		sample

sample:		$(OBJ)
		blink $(LFLAGS) FROM LIB:c.o $(OBJ) TO $* LIB $(LIBS)

$(OBJ):		/include/libraries/vmem.h vmemsupport.h


