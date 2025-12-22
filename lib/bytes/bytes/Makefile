
CC = /opt/amiga/bin/m68k-amigaos-gcc
CFLAGS = -O0 -DUSE_VSTRING -mcrt=clib2 -I. -Wall -Wextra
SRC = bytes.c strtoll.c
OBJS = $(SRC:.c=.o)

test: test.o $(OBJS)
	@$(CC) $^ -o $@ $(CFLAGS)

%.o: %.c
	@$(CC) $< -c -o $@ $(CFLAGS)

clean:
	rm -f *.o

.PHONY: test clean
