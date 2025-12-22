# :ts=8
#
#

CFLAGS = -m68030 -Wall -O3 -noixemul -s

all:			mref FastCXRef

date:
			ver FastCXRef

rev:
			ver FastCXRef -r

mref:			mref.o dirwalker.o head.o stack.o
			gcc $(CFLAGS) -o mref mref.o dirwalker.o head.o stack.o -lfl

FastCXRef:		xref.o cxref.o FastCXRef_ver.o
			gcc $(CFLAGS) -o FastCXRef xref.o cxref.o FastCXRef_ver.o

xref.o:			xref.c cxref_rxcl.c xref_loc.c
			gcc $(CFLAGS) -c xref.c

FastCXRef_ver.c:
			ver FastCXRef

FastCXRef_ver.o:	FastCXRef_ver.c
			gcc $(CFLAGS) -c FastCXRef_ver.c

cxref.o:		cxref.c cxref.h
			gcc $(CFLAGS) -c cxref.c

mref.o:			mref.c
			gcc $(CFLAGS) -c mref.c

dirwalker.o:		dirwalker.c dirwalker.h
			gcc $(CFLAGS) -c dirwalker.c

head.c:			head.l
			flex -t head.l >head.c

head.o:			head.c
			gcc $(CFLAGS) -c head.c

stack.o:		stack.c stack.h
			gcc $(CFLAGS) -c stack.c
