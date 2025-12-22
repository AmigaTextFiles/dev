
OBJS = stcc.o
LIBS = -lamiga
CFLAGS = -noixemul -O2 -fbaserel -msmall-code -fomit-frame-pointer
CC=gcc

all:	stcc

stcc:	$(OBJS) makefile
	$(CC) $(CFLAGS) $(OBJS) -o stcc
