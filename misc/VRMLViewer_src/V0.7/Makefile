# Makefile for VRMLViewer
# V 1.0
# 30 july 98

CC = g++
OPT = -IDH1:Sources/BodySoft/VRMLSupport
LOPT = -noixemul
CFLAGS =
CPU = -m68040
LIB = /gg/lib/libnix/swapstack.o -lm -lstubs -lvrmlsupport -luseful

# Cancel automatic compliation
%.o: %.c
        
#Cancel automatic linking
%: %.o
        
# All
all: VRMLViewer

#link
link:
	$(CC) $(CPU) $(LOPT) $(OPT) -o VRMLViewer Main.o MUI_VRMLViewer.o GLFunctions.o $(LIB)

# VRMLViewer
VRMLViewer: Main.o MUI_VRMLViewer.o GLFunctions.o
	$(CC) $(CPU) $(LOPT) $(OPT) -o VRMLViewer Main.o MUI_VRMLViewer.o GLFunctions.o $(LIB)

# Main
Main.o: Main.h Main.cc
	$(CC) $(CPU) $(COPT) $(OPT) -c Main.cc

# MUI_VRMLViewer
MUI_VRMLViewer.o: MUI_VRMLViewer.cpp MUI_VRMLViewer.h MUI_VRMLViewerExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c MUI_VRMLViewer.cpp

# GLFunctions
GLFunctions.o: MUI_VRMLViewer.h Main.h GLFunctions.h GLFunctions.cc
	$(CC) $(CPU) $(COPT) $(OPT) -c GLFunctions.cc

# Other
clean:
	rm *.o
	rm *.rpo
