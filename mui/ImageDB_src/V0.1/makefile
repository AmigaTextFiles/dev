# ImageDB mcc/mcp
#
# GNU:lib/libnix/libnix.a  is needed only for some functions (math, long * and /)
# stdio functions are forbiden anyway   :-(
#
CC = gcc
CPU = -m68040
CFLAGS = -O3
LOPT= -noixemul
LIB = -lgcc -lamiga

.PHONY: all


all: ImageDB.mcc
#       c:avail flush

#GLArea.mcp: GLArea_mcp.c GLArea_mcp_lib.h
#        $(CC) -nostartfiles $(CPU) $(CFLAGS) -s -o GLArea.mcp GLArea_mcp.c $(LOPT) $(LIB)

ImageDB.mcc: ImageDB_mcc.o ImageDB_GUIGFX.o ImageDB_mcc_lib.h
	$(CC) -nostartfiles $(CPU) $(CFLAGS) -s -o ImageDB.mcc ImageDB_mcc.o ImageDB_GUIGFX.o $(LOPT) $(LIB)

ImageDB_mcc.o: ImageDB_mcc.c ImageDB.h
	$(CC) $(CPU) $(CFLAGS) -c ImageDB_mcc.c

ImageDB_GUIGFX.o: ImageDB_GUIGFX.c
	$(CC) $(CPU) $(CFLAGS) -c ImageDB_GUIGFX.c

install: ImageDB.mcc
#       cp GLArea.mcp MUI:libs/MUI/GLArea.mcp
	cp ImageDB.mcc MUI:libs/MUI
	c:avail flush

clean:
	c:avail flush
	rm -f *.o
	rm -f ImageDB.mcc ImageDB.mcp
