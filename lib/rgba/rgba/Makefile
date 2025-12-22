CC = /opt/amiga/bin/m68k-amigaos-gcc
CFLAGS = -O0 -mcrt=clib2 -Wall

test: test.c src/rgba.c
	@$(CC) -std=c99 $^ -o $@ -lm
#	@./test

.PHONY: test