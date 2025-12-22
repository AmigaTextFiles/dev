# FILE: makefile
# PACKAGE: as31 - 8031/8051 Assembler.
#
# DESCRIPTION:
#
#
# REVISION HISTORY:
#		Jan. 19, 1990 - Created. (Ken Stauffer).
#		Jan. 30, 1990 - Theo played here.
#               Late 1994     - Paul Stoffregen updates the code
#               Sept 1995     - bug fixes, add obsure option for cgi


#Use this CFLAGS line with gcc on linux
CFLAGS=-O2 -fomit-frame-pointer
CC=gcc

#Use this CFLAGS line on solaris, etc
#CFLAGS=-O

#Try these for HPUX
#CFLAGS=-O2
#CC=gcc

#AmigaOS PowerUp
PPC_CC           =       ppc-amigaos-gcc
PPC_AS           =       ppc-amigaos-gas
PPC_LD           =       ppc-amigaos-ld
PPC_OD           =       ppc-amigaos-objdump
PPC_AOPTS		  =		 
PPC_COPTS        =       -S -O3 -I/gg/include
PPC_LOPTS        =       -v -r 
PPC_OOPTS		  =		 --section-headers --all-headers --reloc --syms --line-numbers
PPC_LLIBS		  =		 gg:lib/libppc-amigaos-bfd.a gg:lib/libppc-amigaos-opcodes.a gg:lib/libmoto.a gg:lib/libm.a

YACCFLAGS=-d
OBJ=as31.o symbol.o lexer.o emitter.o main.o

all: 68k

68k: as31

PPC: as31.elf

############################################################

as31:		$(OBJ)
		$(CC) $(CFLAGS) -o as31 $(OBJ)
		chmod a+rx as31

main.o:		main.c as31.h
emitter.o:	emitter.c as31.h
symbol.o:	symbol.c as31.h
lexer.o:	lexer.c as31.h
as31.o:		as31.c
as31.c:		as31.y as31.h
		yacc $(YACCFLAGS) as31.y
		/bin/mv y.tab.c as31.c

clean:
		$(RM) *~ *.o as31.c y.tab.h as31.shar core


mrproper:
			rm -f *.o *~

as31.elf: main.ppco emitter.ppco symbol.ppco lexer.ppco as31.ppco Makefile
			$(PPC_LD) $(PPC_LOPTS) -o $@ $(PPC_LLIBS) $<
			$(PPC_OD) $(PPC_OOPTS) $< >as31PPC.dump
			protect $< +e

%.ppcs: %.c as31.h
			$(PPC_CC) $(PPC_COPTS) -c -o $@ $<

%.ppco: %.ppcs as31.h
			$(PPC_AS) $(PPC_ASOPTS) -o $@ $<


