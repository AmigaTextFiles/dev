CC =		lc
LD =		blink

OBJ =		p2c.o doalloc.o proc.o

.c.o:
		$(CC) $(CFLAGS) -o$@ $*.c

p2c :		$(OBJ)
		$(LD) with link.cmd
