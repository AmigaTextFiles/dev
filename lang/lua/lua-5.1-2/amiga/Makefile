#
# Makefile for AmigaOS Lua dynamic loading test
#

.PHONY: clean

CFLAGS := -Wall -mcrt=clib2-ts -I../src
BEGIN  := /SDK/clib2/lib.threadsafe/crtbegin.o
END    := /SDK/clib2/lib.threadsafe/crtend.o
LIBS   := -llua -lm -lc -lunix -lgcc

OBJS   := amigalua_lib.o amigalua_lua.o

amigalua.library: $(OBJS)
	gcc $(CFLAGS) -nostartfiles -nostdlib -o $@ \
		-L../src $(BEGIN) $(OBJS) $(LIBS) $(END)
	strip -R.comment $@
	avail flush >NIL:

clean:
	-delete $(OBJS)

%.o: %.c
	gcc $(CFLAGS) -c $^
