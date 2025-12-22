CFLAGS = -cef -v

scanner:	scanner.o
		blink LIB:c.o scanner.o TO scanner LIB LIB:lc.lib \
		LIB:amiga.lib SC SD ND

scanner.o:	scanner.c scanner.h

clean:
		delete scanner.o scanner
