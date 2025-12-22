# Some mcc/mcp GLArea
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


all: GLArea.mcc GLArea.mcp
	c:avail flush

GLArea.mcp: GLArea_mcp.o GLArea_mcp_lib.h
	$(CC) -nostartfiles $(CPU) $(CFLAGS) -s -o GLArea.mcp GLArea_mcp.o $(LOPT) $(LIB)

GLArea.mcc: GLArea_mcc.o GLArea_mcc_lib.h GLArea_GLFunc.o GLArea_Subtask.o
	$(CC) -nostartfiles $(CPU) $(CFLAGS) -s -o GLArea.mcc GLArea_mcc.o GLArea_GLFunc.o GLArea_Subtask.o $(LOPT) $(LIB)

GLArea_mcp.o: GLArea_mcp.c GLArea_mcp.h
	$(CC) $(CPU) $(CFLAGS) -c GLArea_mcp.c

GLArea_mcc.o: GLArea_mcc.c GLArea.h
	$(CC) $(CPU) $(CFLAGS) -c GLArea_mcc.c

GLArea_GLFunc.o: GLArea_GLFunc.c
	$(CC) $(CPU) -c GLArea_GLFunc.c

GLArea_Subtask.o: GLArea_Subtask.c
	$(CC) $(CPU) $(CFLAGS) -c GLArea_Subtask.c

install: GLArea.mcc
	cp GLArea.mcp MUI:libs/MUI/GLArea.mcp
	cp GLArea.mcc MUI:libs/MUI/GLArea.mcc
	c:avail flush

clean:
	rm -f MUI:libs/MUI/GLArea.mcp
	rm -f MUI:libs/MUI/GLArea.mcc
	c:avail flush
	rm -f *.o
	rm -f GLArea.mcc GLArea.mcp
