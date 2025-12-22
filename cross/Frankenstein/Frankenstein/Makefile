# HEADER:	;
# TITLE:	Frankenstein Cross Assemblers;
# VERSION: 	2.0;
# SYSTEM:	Unix (microport system V/AT);
# FILENAME:	Makefile ;
# DESCRIPTION: "Reconfigurable Cross-assembler producing Intel (TM)
#		Hex format object records.  ";
# KEYWORDS: 	cross-assemblers, 1805, 2650, 6301, 6502, 6805, 6809, 
#		6811, tms7000, 8048, 8051, 8096, z8, z80;
# WARNINGS:	"This software is in the public domain.  
#		Any prior copyright claims are relinquished.  
#	
#		This software is distributed with no warranty whatever.  
#		The author takes no responsibility for the consequences 
#		of its use.
#	
#		Yacc (or Bison) required to compile."  ;
# AUTHORS:	Mark Zenier;
# COMPILERS:	Microport System V/AT;
#
#	usage	
#		make somename TARGET=somename 
#		make newmachine       clean out machine dependent *.o
#		make clean	      clean out for release disk
#
#	Conditional Compilation Flags
#
#	DOSTMP		use the current directory for temporary intermediate
#			file
#	NOGETOPT	use the getopt.h file
#	USEINDEX	redefine the strchr() library function to use
#			the older equivalent name index()
#	NOSTRING	use internal definitions if the <string.h> include
#			file does not exist
#
# USAGE (e.g.): make as6502 TARGET=as6502

RM=delete QUIET
CP=copy
MV=rename

YACC=yacc
YACCLEXLIB = 
CC=gcc 
CFLAGS= -O2 -Wno-unused #-m68030 -m68881
MAINNEEDS =
MAINDEPENDS =

TARGET = frasm
PRINTSPOOL = lpr

# LEXERDEBUG = -DDEBUG=1
LEXERDEBUG =

# for SunOS 4.1
#CFLAGS = -g 
#YACCLEXLIB = -ly 
#MAINNEEDS =
#MAINDEPENDS =
#MAINDEPENDS =

# for microport and xenix
# CFLAGS = -Ml -g 
# YACCLEXLIB = -ly 
# MAINNEEDS =
# MAINDEPENDS =

# for dos cross compiled on xenix
# CFLAGS = -dos  -Ml
# YACCLEXLIB =
# MAINNEEDS = -DNOGETOPT -DDOSTMP
# MAINDEPENDS = getopt.h

# for v7
# CFLAGS = -DUSEINDEX -DNOSTRING
# YACCLEXLIB = -ly 
# MAINNEEDS = -DNOGETOPT
# MAINDEPENDS = getopt.h

clean :
	$(RM) #?.o fraytok.h 
	$(RM) y.tab.[ch]
	$(RM) as#?.c as#?.h as#?.o

newmachine :
	$(RM) fraytok.h
	$(RM) fryylex.o
	$(RM) $(TARGET).c $(TARGET).h $(TARGET).o

$(TARGET) : frasmain.o frapsub.o fryylex.o $(TARGET).o fraosub.o
	$(CC) $(CFLAGS) -o $(TARGET) frasmain.o frapsub.o \
		fraosub.o fryylex.o $(TARGET).o $(YACCLEXLIB)
	$(RM) fraytok.h
	$(TARGET) ../test/$(TARGET).tst

frasmain.o : frasmain.c  frasmdat.h $(MAINDEPENDS)
	$(CC) $(CFLAGS) $(MAINNEEDS) -c frasmain.c

$(TARGET).c $(TARGET).h : $(TARGET).y
	$(YACC) -d $(TARGET).y
	$(MV) y.tab.c $(TARGET).c
	$(MV) y.tab.h $(TARGET).h
	$(RM) fraytok.h

fraytok.h : $(TARGET).h
	$(CP) $(TARGET).h fraytok.h

$(TARGET).o : $(TARGET).c  frasmdat.h fragcon.h
	$(CC) $(CFLAGS) -c $(TARGET).c

frapsub.o : frapsub.c fragcon.h frasmdat.h fraeuni.h fraebin.h
	$(CC) $(CFLAGS) -c frapsub.c

fraosub.o : fraosub.c  frasmdat.h fragcon.h fraeuni.h fraebin.h
	$(CC) $(CFLAGS) -c fraosub.c

fryylex.o : fryylex.c frasmdat.h fraytok.h
	$(CC) $(CFLAGS) $(LEXERDEBUG) -c fryylex.c

