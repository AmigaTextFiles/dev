CFLAGS= -O2 -Wall
LDFLAGS= -noixemul

spatch:

spatch.os4: spatch.c
	vc +aosppc -D__USE_INLINE__ -lauto -o $@ $?


archive:
	-HunkShort spatch.68k T:spatch.68k
	-copy T:spatch.68k spatch.68k
	-strip -R.comment spatch
	-delete spatch.lnk spatch.o
	lha -r u RAM:spatch // spatch
