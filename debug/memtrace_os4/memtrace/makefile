#
# gcc Makefile for memtrace example
#
# - Change the pathes according to your system configuration!
# - This makefile creates directories: "ojects", "bin",
#   compiled stuff can be found there afterwards,
#   "make clean" deletes  them
# 

#name of the executeable file
PROG = example.exe

#compiler
CPP  = g++ -mcrt=newlib

#library and include path
LIBS =  -L"c:/wxDev-Cpp/lib"  
INCS =  -I"c:/wxDev-Cpp/include" 

#to create and delete directories
RM = rm -r -f
MKDIR = mkdir -v -p




OBJDIR = obj
BINDIR = bin

#objects to create
OBJ0 = $(OBJDIR)/memtrace.o
OBJ1 = $(OBJDIR)/example_obj.o
OBJ2 = $(OBJDIR)/example.o


#binary
BIN = $(BINDIR)/$(PROG)


$(BIN) : dirs $(OBJ0) $(OBJ1) $(OBJ2)
	$(CPP) $(OBJ0) $(OBJ1) $(OBJ2) -o $(BIN) $(INCS) $(LIBS)
	strip $(BIN) -s


#create dirs
dirs :
	$(MKDIR) $(OBJDIR)
	$(MKDIR) $(BINDIR)

$(OBJ0) :
	$(CPP) -c memtrace/memtrace_internal.cpp -o $(OBJ0) $(INCS) $(LIBS)

$(OBJ1) :
	$(CPP) -c example_obj.cpp -o $(OBJ1) $(INCS) $(LIBS)

$(OBJ2) :
	$(CPP) -c example.cpp -o $(OBJ2) $(INCS) $(LIBS)


.PHONY : clean
clean :
	${RM} $(OBJDIR)
	${RM} $(BINDIR)

