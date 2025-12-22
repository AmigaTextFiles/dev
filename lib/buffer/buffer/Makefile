CC = /opt/amiga/bin/m68k-amigaos-gcc
CFLAGS = -O0 -mcrt=clib2 -Wall
LDFLAGS = -mcrt=clib2

test: buffer.c test.c
	@$(CC) $^ -std=c99 -o $@
#	@./test

.PHONY: test
