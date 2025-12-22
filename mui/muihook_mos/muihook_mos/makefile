# PPC/Morphos MakeFile for popup_mos

CFLAGS = -Igg:ppc-morphos/os-include
LFLAGS = -noixemul -lmui -lamigastubs -lsyscall
CC     = ppc-morphos-gcc

popup_mos.exe : popup_mos.o 
	$(CC) popup_mos.o $(LFLAGS) -o popup_mos.exe 

popup_mos.o : popup_mos.c demo.h SDI_Hook.h SDI_Compiler.h
	$(CC) $(CFLAGS) -c popup_mos.c
