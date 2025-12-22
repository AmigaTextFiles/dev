# Makefile for VRMLEditor
# V 1.0
# 30 july 98

CC = gcc
OPT = -IDH1:Sources/BodySoft/VRMLSupport -IDH1:Sources/BodySoft/MCC/mui -IDH1:Sources/BodySoft/MCC -IMUI -IDH1:Sources/BodySoft/Useful
LOPT = -noixemul
COPT = -O0
CPU = -m68040
LIB = -lvrmlsupport -lusefull MUI/libmuivrmleditor.a -lm -lstack -lstubs

VSDIR = DH1:Sources/BodySoft/VRMLSupport/
MCDIR = DH1:Sources/BodySoft/MCC/
UDIR = DH1:Sources/BodySoft/Useful/
MUIDIR = MUI/

MCCOBJ = $(MCDIR)MCC_DDListtree.o

# Cancel automatic compliation
%.o: %.c
        
#Cancel automatic linking
%: %.o
        
# All
all: VRMLEditor_GCC

link:
	$(CC) $(CPU) $(LOPT) $(OPT) -o VRMLEditor_GCC Main.o GLFunctions.o GLFunctions2.o MUIWindows.o $(MCCOBJ) $(LIB)

# VRMLEditor
VRMLEditor_GCC: Main.o MUIWindows.o GLFunctions.o GLFunctions2.o
	$(CC) $(CPU) $(LOPT) $(OPT) -o VRMLEditor_GCC Main.o GLFunctions.o GLFunctions2.o MUIWindows.o $(MCCOBJ) $(LIB)

# Main
Main.o: Main.h MUIWindows.h Stack.hpp Main.cc
	$(CC) $(CPU) $(COPT) $(OPT) -c Main.cc

# GLFunctions
GLFunctions.o: Main.h GLFunctions.cc $(MUIDIR)App.h GLFunctions.h MUIWindows.h
	$(CC) $(CPU) $(COPT) $(OPT) -c GLFunctions.cc

# GLFunctions2
GLFunctions2.o: GLFunctions2.c GLFunctions.h
	$(CC) $(CPU) $(OPT) $(OPT) -c GLFunctions2.c

# MUIWindows
MUIWindows.o: MUIWindows.h $(MUIDIR)App.h MUIWindows.cc
	$(CC) $(CPU) $(COPT) $(OPT) -c MUIWindows.cc

# Other
clean:
	rm *.o
	rm *.rpo
