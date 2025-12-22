#***************************************************************************
#==========================================================================*
#=																		  =*
#=			Profyler Test Programs v0.0 © 2022 by Mike Steed			  =*
#=																		  =*
#==========================================================================*
#==========================================================================*
#=																		  =*
#=	Makefile for Test Code						Last modified 21-Dec-21	  =*
#=																		  =*
#==========================================================================*
#***************************************************************************

### C library to be used (pick one; comment out the other)

#CLIB = -mcrt=clib2
CLIB = -mcrt=newlib

### Compiler version (pick one; comment out the other)

#For older versions of GCC, without C++ thread support
#THREAD = 

#For newer versions of GCC, with C++ thread support
THREAD = -athread=single

### Compiler and options

CC = gcc
CFLAGS = -Wfatal-errors -O2 -Wall -gstabs $(CLIB) \
		-idirafter ../LibProfyle

# Don't profile, even if profiling is enabled below
NPFLAGS := $(CFLAGS)

CX = g++
CXFLAGS = -Wfatal-errors -O2 -Wall -gstabs $(CLIB) \
		-idirafter ../LibProfyle

### Librarian

AR = ar -r

### Linker and options

LN = gcc
LNFLAGS = -Wl,-N $(CLIB)

LX = g++
LXFLAGS = -Wl,-N $(CLIB) $(THREAD)

### External (non-system) libraries used by the program

LIBS =

### Uncomment the following lines to add profiling

CFLAGS += -finstrument-functions -fno-inline -DPROFILING
CXFLAGS += -finstrument-functions -fno-inline -DPROFILING
LIBS += ../LibProfyle/libprofyle.a

### Emulate SAS/C's __AMIGADATE__

DATESTR := $(shell Date LFORMAT "(%-d.%-m.%Y)")
AMIGADATE = -D__AMIGADATE__="$(DATESTR)"

### Files that most object files depend on

STDDEP = Makefile $(LIBS)

### Build everything

All: Simple SimplePlus SetJump Exception Recursion MultiThread \
	Structor StructorPlus LinkLibTest LinkLibTest2 SOLibTest

### Build the libraries

MyLib.a: MyLib_Hello.o MyLib_World.o MyLib_MyPrintf.o
	$(AR) $@ $^

MyLib.so: MyLib_Hello.o MyLib_World.o MyLib_MyPrintf.o
	$(LN) -shared $^ -o $@

### Build the library component object files

MyLib_Hello.o: MyLib_Hello.c MyLib.h Makefile
	$(CC) $(CFLAGS) -fPIC -c $< -o $@

MyLib_World.o: MyLib_World.c MyLib.h Makefile
	$(CC) $(CFLAGS) -fPIC -c $< -o $@

MyLib_MyPrintf.o: MyLib_MyPrintf.c MyLib.h Makefile
	$(CC) $(CFLAGS) -fPIC -c $< -o $@

### Build the executables

Simple: Simple.o $(LIBS)
	$(LN) $(LNFLAGS) $< $(LIBS) -lamiga -o $@

SimplePlus: SimplePlus.o $(LIBS)
	$(LX) $(LXFLAGS) $< $(LIBS) -lamiga -o $@

SetJump: SetJump.o $(LIBS)
	$(LN) $(LNFLAGS) $< $(LIBS) -lamiga -o $@

Exception: Exception.o $(LIBS)
	$(LX) $(LXFLAGS) $< $(LIBS) -lamiga -o $@

Recursion: Recursion.o $(LIBS)
	$(LN) $(LNFLAGS) $< $(LIBS) -lamiga -o $@

MultiThread: MultiThread.o $(LIBS)
	$(LN) $(LNFLAGS) $< $(LIBS) -lamiga -o $@

Structor: Structor.o $(LIBS)
	$(LN) $(LNFLAGS) $< $(LIBS) -lamiga -o $@

StructorPlus: StructorPlus.o $(LIBS)
	$(LX) $(LXFLAGS) $< $(LIBS) -lamiga -o $@

LinkLibTest: LinkLibTest.o MyLib.a $(LIBS)
	$(LN) $(LNFLAGS) $< MyLib.a $(LIBS) -lamiga -o $@

LinkLibTest2: LinkLibTest2.o MyLib.a $(LIBS)
	$(LN) $(LNFLAGS) $< MyLib.a $(LIBS) -lamiga -o $@

# Always use newlib with shared objects; can't use -N with shared objects
SOLibTest: SOLibTest.o MyLib.so $(LIBS)
	$(LN) -use-dynld -mcrt=newlib $(THREAD) $< MyLib.so $(LIBS) -lamiga -o $@

### Build the object files

Simple.o: Simple.c $(STDDEP)
	$(CC) $(CFLAGS) $(AMIGADATE) -c $< -o $@

SimplePlus.o: SimplePlus.cc $(STDDEP)
	$(CX) $(CXFLAGS) $(AMIGADATE) -c $< -o $@

SetJump.o: SetJump.c $(STDDEP)
	$(CC) $(CFLAGS) $(AMIGADATE) -c $< -o $@

Exception.o: Exception.cc $(STDDEP)
	$(CX) $(CXFLAGS) $(AMIGADATE) -c $< -o $@

Recursion.o: Recursion.c $(STDDEP)
	$(CC) $(CFLAGS) $(AMIGADATE) -c $< -o $@

MultiThread.o: MultiThread.c $(STDDEP)
	$(CC) $(CFLAGS) $(AMIGADATE) -c $< -o $@

Structor.o: Structor.c $(STDDEP)
	$(CC) $(CFLAGS) $(AMIGADATE) -c $< -o $@

StructorPlus.o: StructorPlus.cc $(STDDEP)
	$(CX) $(CXFLAGS) $(AMIGADATE) -c $< -o $@

LinkLibTest.o: MyLibTest.c $(STDDEP)
	$(CC) $(CFLAGS) $(AMIGADATE) -c $< -o $@

# Profile only the linked library, not the main program.
LinkLibTest2.o: MyLibTest.c $(STDDEP)
	$(CC) $(NPFLAGS) $(AMIGADATE) -c $< -o $@

SOLibTest.o: MyLibTest.c $(STDDEP)
	$(CC) $(CFLAGS) $(AMIGADATE) -c $< -o $@
