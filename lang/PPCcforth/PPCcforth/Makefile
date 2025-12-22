CC = cc

test :		forth.core forth

forth :		forth.o prims.o
		$(CC) -o forth forth.o prims.o

forth.o :	forth.c common.h forth.h prims.h
		$(CC) -c forth.c

prims.o :	prims.c forth.h prims.h
		$(CC) -c prims.c

all :		forth forth.core l2b b2l

nf :		nf.o lex.yy.o
		$(CC) -o nf nf.o lex.yy.o

nf.o :		nf.c forth.lex.h common.h
		$(CC) -c nf.c

# A current bug in the Lattice C compiler on the AMIGA prevents it
# from compiling the lex.yy.c file.  This means that the nf program
# will not yet run on an AMIGA under Lattice C, and the resources of
# a unix system will be required to produce nf and forth.core.
lex.yy.o :	lex.yy.c forth.lex.h
		$(CC) -c lex.yy.c

lex.yy.c :	forth.lex
		-mv lex.yy.c lex.yy.c.old
		lex forth.lex
		rm -f lex.tmp
		sed "s/yylex(){/TOKEN *yylex(){/" lex.yy.c > lex.tmp
		mv -f lex.tmp lex.yy.c

forth.core :	nf forth.dict
		nf < forth.dict

# l2b : convert a line file to a block file. Usage: l2b < linefile > blockfile
l2b :		l2b.c
		$(CC) -o l2b l2b.c

# b2l: convert a block file to a line file. Usage: b2l < blockfile > linefile
b2l :		b2l.c
		$(CC) -o b2l b2l.c

# forth.line and forth.block are not included here, because you can't tell
# which one is more recent. To make one from the other, use b2l and l2b.
