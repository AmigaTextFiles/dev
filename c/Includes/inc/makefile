#
# makefile for includes.c
#
# Bruno Costa - 24 Jan 90 - 24 Jan 90
#

CFLAGS = -cusf -d1
EXE = includes
OBJS = includes.o

.c.o:
	@echo "\e[33;3mCompiling file $*.c\e[31;0m"
	lc $(CFLAGS) $*.c

$(EXE): $(OBJS)
	blink from LIB:c.o $(OBJS) LIBRARY LIB:lc.lib \
 SMALLCODE SMALLDATA NODEBUG TO $(EXE) BATCH MAP $(EXE).map hsflx plain
	@echo "\e[33;1m-- Program is ready --\e[31;0m"

