

default : gcc_ppc

#vcc_ppc : main.c SSProcLib.c SSProcLib_protos.h
#	 vc -cpp-comments -I. main.c SSProcLib.c -o main_vcc_ppc -ldebug -lamiga

#vcc_68k : main.c SSProcLib.c SSProcLib_protos.h
#	 vc +m68k -cpp-comments -I. main.c SSProcLib.c -o main_vcc_68k -ldebug -lamiga

gcc_ppc	: TestSSProcLib.c SSProcLib.c SSProcLib_protos.h
	gcc -Wall -DAMIGAOSLIKE -I. TestSSProcLib.c SSProcLib.c -o TestSSProcLib -ldebug


