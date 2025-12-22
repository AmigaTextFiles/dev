
CC = gcc
LCFLAGS = -Wall -g -O2
CFLAGS = $(LCFLAGS) -c
LDFLAGS = -s

#PROT=-lefence -DEFENCE
PROT=

#tobin: tout
#	cp objdir/ncc /home/stan/bin

tout: objdir/ncc
	@echo Salut.

objdir/ncc: objdir/dbstree.o objdir/inttree.o objdir/lex.o objdir/space.o objdir/cexpand.o objdir/cdb.o objdir/parser.o objdir/ccexpr.o objdir/preproc.o objdir/usage.o main.C
	$(CC) $(LCFLAGS) main.C objdir/*.o -o objdir/ncc $(PROT) -Xlinker -s

objdir/cexpand.o: cexpand.C
	$(CC) $(CFLAGS) cexpand.C
	@mv cexpand.o objdir/

objdir/parser.o: parser.C
	$(CC) $(CFLAGS) parser.C
	@mv parser.o objdir/

objdir/inttree.o: inttree.[Ch]
	$(CC) $(CFLAGS) inttree.C
	@mv inttree.o objdir/

objdir/dbstree.o: dbstree.[Ch]
	$(CC) $(CFLAGS) dbstree.C
	@mv dbstree.o objdir/

objdir/lex.o: lex.C
	$(CC) $(CFLAGS) lex.C
	@mv lex.o objdir/

objdir/cdb.o: cdb.C
	$(CC) $(CFLAGS) cdb.C
	@mv cdb.o objdir/

objdir/space.o: space.C
	$(CC) $(CFLAGS) space.C
	@mv space.o objdir/

objdir/usage.o: usage.C
	$(CC) $(CFLAGS) usage.C
	@mv usage.o objdir/

objdir/ccexpr.o: ccexpr.C
	$(CC) $(CFLAGS) ccexpr.C
	@mv ccexpr.o objdir/

objdir/preproc.o: preproc.C
	$(CC) $(CFLAGS) preproc.C
	@mv preproc.o objdir/

wc:
	wc *.[Ch] | sort -n

clean:
	rm -f objdir/*.o

distclean:
	rm -f objdir/* 2dmap/*.o 2dmap/2dmap
