# Makefile for GLArea_Demo
# V 1.0
# 24/07/1999

CC = gcc
OPT =
LOPT = -noixemul
COPT = -O0
CPU = -m68040
LIB = -lm -lstubs

UDIR = "Useful/"

# Cancel automatic compliation
%.o: %.c
        
#Cancel automatic linking
%: %.o
        
# All
all:GLArea_Demo

#link
link:
	$(CC) $(CPU) $(LOPT) $(OPT) -o GLArea_Demo Main.o MUI_GLAreas_Demo.o GLFunctions.o Pawn.o ColorCube.o Ground.o Background.o $(UDIR)GL_stubs.o $(LIB)

# GLArea_Demo
GLArea_Demo: Main.o MUI_GLArea_Demo.o GLFunctions.o Pawn.o ColorCube.o Ground.o Background.o
	$(CC) $(CPU) $(LOPT) $(OPT) -o GLArea_Demo Main.o MUI_GLArea_Demo.o GLFunctions.o Pawn.o ColorCube.o Ground.o Background.o $(UDIR)GL_stubs.o $(LIB)

# Main
Main.o: Main.h Main.c GLFunctions.h MUI_GLArea_Demo.h
	$(CC) $(CPU) $(COPT) $(OPT) -c Main.c

# GLFunctions
GLFunctions.o: GLFunctions.c GLFunctions.h
	$(CC) $(CPU) $(COPT) $(OPT) -c GLFunctions.c

# Pawn
Pawn.o: Pawn.c
	$(CC) $(CPU) $(COPT) $(OPT) -c Pawn.c

# ColorCube
ColorCube.o: ColorCube.c
	$(CC) $(CPU) $(COPT) $(OPT) -c ColorCube.c

# Ground
Ground.o: Ground.c
	$(CC) $(CPU) $(COPT) $(OPT) -c Ground.c

# Background
Background.o: Background.c
	$(CC) $(CPU) $(COPT) $(OPT) -c Background.c

# MUI_GLArea_Demo
MUI_GLArea_Demo.o: MUI_GLArea_Demo.c MUI_GLArea_Demo.h MUI_GLArea_DemoExtern.h GLFunctions.h
	$(CC) $(CPU) $(COPT) $(OPT) -c MUI_GLArea_Demo.c

# Other
clean:
	rm *.o
	rm *.rpo
