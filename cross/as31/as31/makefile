# FILE: makefile
# PACKAGE: as31 - 8031/8051 Assembler.
#
# DESCRIPTION:
#
#
# REVISION HISTORY:
#		Jan. 19, 1990 - Created. (Ken Stauffer).
#		Jan. 30, 1990 - Theo played here.
CC=cc
RM=delete QUIET
MV=rename
YACC=yacc
 
CFLAGS=-O2 -Wno-unused -m68000
#CFLAGS=-O2 -Wno-unused -m68020
#CFLAGS=-O2 -Wno-unused -m68030 -m68881
YACCFLAGS=-d
OBJ=as31.o symbol.o lexer.o emitter.o main.o
SHARFILES=README as31.h as31.y as31.man emitter.c lexer.c main.c makefile \
		symbol.c new.asm

as31:		$(OBJ)
		$(CC) $(CFLAGS) -o as31 $(OBJ)
#		chmod a+rx as31

main.o:		main.c as31.h
emitter.o:	emitter.c as31.h
symbol.o:	symbol.c as31.h
lexer.o:	lexer.c as31.h
as31.o:		as31.c
as31.c:		as31.y as31.h
		$(YACC) $(YACCFLAGS) as31.y
		$(MV) y.tab.c as31.c

man:		as31.cat

as31.cat:	as31.man
		nroff -man as31.man > as31.cat
#		chmod a+r as31.cat as31.man
		
asm:		new.obj ram.obj

new.obj:	new.asm
		as31 -Ftdr -l new.asm

clean:
		$(RM) #?.o as31.c y.tab.h as31.shar

shar:
		shar $(SHARFILES) > as31.shar
