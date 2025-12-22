#	makefile for testdsp.exe

all:	testdsp.exe 

clean:
	rm m68kfinal.o main_m68k.o testdsp.o wrapper_DSP.o testdsp.exe code_DSP.o libgcc1.o

m68kfinal.o:	main_m68k.o
	vlink -b elf32ppcbe -r -o m68kfinal.o  $(VBCC_LIB)/startup.o main_m68k.o -L$(VBCC_LIB) -lvc -lamiga -lmieee

main_m68k.o: main_m68k.c
	vc +aos68k -I$(VBCC)/targets/m68k-amigaos/include -I$(NDK_INC) -c -o main_m68k.o main_m68k.c

testdsp.o: m68kfinal.o wrapper_DSP.o code_DSP.o libgcc1.o
	vlink -r -b elf32ppcbe -o testdsp.o m68kfinal.o wrapper_DSP.o code_DSP.o libgcc1.o

wrapper_DSP.o: wrapper_DSP.s
	asm3210 wrapper_DSP.s

code_DSP.o: code_DSP.s
	asm3210 code_DSP.s

libgcc1.o: libgcc1.s
	asm3210 libgcc1.s

testdsp.exe: testdsp.o
	elf2exem68k testdsp.o
	