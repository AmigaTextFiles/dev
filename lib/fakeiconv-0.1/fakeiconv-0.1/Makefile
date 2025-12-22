#
# fakeiconv - simulates libiconv API
# version 0.1 by megacz@usa.com
#

CC = gcc
CFLAGS = -O2 -Wall -msoft-float -c

OBJ = fakeiconv

all: lib/lib$(OBJ).a lib/libb/lib$(OBJ).a lib/libb32/libm020/lib$(OBJ).a

lib/lib$(OBJ).a:
	$(CC) $(CFLAGS) -m68000 $(OBJ).c
	ar cru $@ $(OBJ).o
	ranlib $@

lib/libb/lib$(OBJ).a:
	$(CC) $(CFLAGS) -m68000 -resident $(OBJ).c
	ar cru $@ $(OBJ).o
	ranlib $@

lib/libb32/libm020/lib$(OBJ).a:
	$(CC) $(CFLAGS) -m68020 -resident32 $(OBJ).c
	ar cru $@ $(OBJ).o
	ranlib $@

clean:
	-rm -f *.o
	-rm -f lib/*.a
	-rm -f lib/libb/*.a
	-rm -f lib/libb32/libm020/*.a
