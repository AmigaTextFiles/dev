# :ts=8
#
LMSDIR	=	src	
CFLAGS	=	+l
LIBOBJ	=	l.o
STBOBJ	=	lmss.o

.asm.o	:
	run copy $*.asm LMS:$(LMSDIR)
	as $*.asm

.c.o	:
	run copy $*.c LMS:$(LMSDIR)
	cc $(CFLAGS) $*

asdg-low-mem.library	:	l.o
	ln -o asdg-low-mem.library l.o

lms-trip	:	lms-trip.o
	ln -o lms-trip lms-trip.o -lc32

lms-example	:	lms-example.o $(STBOBJ)
	ln -o lms-example lms-example.o $(STBOBJ) -lc32

l.o	:	l.asm macros.i

