#
# gcc Makefile for libiffanim and/or an SDL player
#
# "make" :       creates library and player program
# "make lib" :   creates the library only (no SDL required)
# "make clean" : deletes compiled code
#
# - Change this file according to your system configuration!
# - This makefile creates directories: "obj", "bin", "lib"
#   compiled stuff can be found there afterwards,
#   "make clean" deletes  them
# - The header for the compiled library can simply be taken from the source
#
# - currently configured for mingw/win32 (msys)


#name of the executeable file
BINFILE = iffanimplay

#name of the library
LIBFILE = libiffanim.a

#compiler
CPP  = g++ -mcrt=newlib -O2 -g

#header dir for header to libiffanim
LIBINCDIR = -I"src/iffanim"

#c++ library and include path
#LIBSDIR =  -L"abc/lib"
#INCSDIR =  -I"abc/include" 

#library and include path for SDL
#LIBSDL =  -L"/c/wxDev-Cpp/lib" -lmingw32 -lSDLmain -lSDL -mwindows
#INCSDL =  -I"/c/wxDev-Cpp/include/SDL"
LIBSDL = -lSDL
INCSDL = -I/SDK/Local/newlib/include/SDL

#programs to create and delete directories
RM = rm -r -f
MKDIR = mkdir -v -p


#dir names to create
OBJDIR = obj
BINDIR = bin
LIBDIR = lib


#binary
BIN = $(BINDIR)/$(BINFILE)

#library
LIB = $(LIBDIR)/$(LIBFILE)


#archiver for creating static lib
ARCH = ar -rcs

#for making prog smaller
STRIP = strip -s $(BIN)




$(BIN) : lib
	$(MKDIR) $(OBJDIR)
	$(MKDIR) $(BINDIR)
	$(CPP) -c src/iffanimplay/player.cpp -o $(OBJDIR)/player.o $(INCSDIR) $(LIBSDIR) $(INCSDL) $(LIBINCDIR)
	$(CPP) -c src/iffanimplay/main.cpp -o $(OBJDIR)/main.o $(INCSDIR) $(LIBSDIR) $(INCSDL) $(LIBINCDIR)
	$(CPP) $(OBJDIR)/iffanim.o $(OBJDIR)/player.o $(OBJDIR)/main.o -o $(BIN) $(LIBINCDIR) $(INCSDIR) $(LIBSDIR) $(INCSDL) $(LIBSDL)
#	$(STRIP)


.PHONY : lib
lib :
	$(MKDIR) $(OBJDIR)
	$(MKDIR) $(LIBDIR)
	$(CPP) -c src/iffanim/iffanim.cpp -o $(OBJDIR)/iffanim.o $(INCSDIR) $(LIBSDIR)
	$(ARCH) $(LIB) $(OBJDIR)/iffanim.o 
	

.PHONY : clean
clean :
	$(RM) $(OBJDIR)
	$(RM) $(BINDIR)
	$(RM) $(LIBDIR)
