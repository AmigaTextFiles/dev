# AVA Makefile
# Uros Platise (c) 1999
#
# Check directories and then
#  - to compile type: make
#  - to install type: make install
#  - to run type: ava
#
# Switch -fhandle-exceptions is required by the GNU C++ 2.7.2.1 and
# may be removed for higher versions (as egcs 2.9.*)
#
# Switch -O2 does not work with GNU C+ 2.7.2.1 due to internal errors

# Directory Setup
	AVA_BIN = /usr/local/bin
	AVA_LIB = /usr/local/lib/uTools/ava

# The following lines declare compile options. 
#
#   Note: -O option cannot be specifed for GNU C++ version 2.7.2.1
#         due to the internal bug. That is why is not specifed by default.

	SRC	= Main.C Preproc.C Lexer.C Syntax.C Symbol.C \
                  Segment.C Keywords.C Reports.C Object.C Avr.C

	OBJ	= Main.o Preproc.o Lexer.o Syntax.o Symbol.o \
                  Segment.o Keywords.o Reports.o Object.o Avr.o

	CC	= g++
	LIBS	=

# Old testing flags ...
#	CPPFLAGS= -DAVA_LIB="\"$(AVA_LIB)\"" -Wall \
#		  -fhandle-exceptions -fenum-int-equiv -fnonnull-objects \
#		  -fforce-addr -fthread-jumps -felide-constructors

# Add -O option for version 2.8 or more ...

# GNU C++ compiler
#	CPPFLAGS= -DAVA_LIB="\"$(AVA_LIB)\"" -Wall \
#		  -fhandle-exceptions -fenum-int-equiv

# egcs C++ compiler
	CPPFLAGS= -O2 -DAVA_LIB="\"$(AVA_LIB)\"" -Wall \
		  -fenum-int-equiv


# Do the stuff as specified above.
all:	ava

ava:	$(OBJ)
	$(CC) -o $@ $(CPPFLAGS) $(OBJ) $(LIBS)

clean:
	rm *.o ava

install:
	mkdir -p $(AVA_LIB)
	rm -r $(AVA_LIB)
	cp -r ../avalib $(AVA_LIB)
	cp ava $(AVA_BIN)
