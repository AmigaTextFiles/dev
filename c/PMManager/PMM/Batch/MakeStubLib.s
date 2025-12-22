.KEY NAME,FD
.BRA {
.KET }

FailAt 99999999

Cd Lib:

PmmTool -n {FD} Lib:{NAME}.Lib
If WARN
	Cd Lib:LibStubs/{NAME}
	Delete #? ALL
	MakeDir STD
	MakeDir 040
	MakeDir PPC
	MakeDir WOS

	Cd Lib:LibStubs/{NAME}/STD
	FD2Lib {FD}
	List #?.s LFormat="PhxAss %s" > Lib:LibStubs/{NAME}/Make_{Name}.AsmSTD
	Execute Lib:LibStubs/{NAME}/Make_{Name}.AsmSTD
	List #?.o LFORMAT="PmmLibr R Lib:{NAME} %m*NPmmLibr R Lib:All %m" > Lib:LibStubs/{NAME}/Make_{Name}.LibSTD
	Execute Lib:LibStubs/{NAME}/Make_{Name}.LibSTD

	Cd Lib:LibStubs/{NAME}/040
	FD2Lib -40 {FD}
	List #?.s LFormat="PhxAss %s" > Lib:LibStubs/{NAME}/Make_{Name}.Asm040
	Execute Lib:LibStubs/{NAME}/Make_{Name}.Asm040
	List #?.o LFORMAT="PmmLibr R Lib:{NAME}_040 %m*NPmmLibr R Lib:All_040 %m" > Lib:LibStubs/{NAME}/Make_{Name}.Lib040
	Execute Lib:LibStubs/{NAME}/Make_{Name}.Lib040

	Cd Lib:LibStubs/{NAME}/PPC
	FD2LibPPC {FD}
	List #?.s LFormat="Echo %n*NPasm_wos -R -F1 -O65536 %s" > Lib:LibStubs/{NAME}/Make_{Name}.AsmPPC
	Execute Lib:LibStubs/{NAME}/Make_{Name}.AsmPPC
	List #?.o LFORMAT="ppc-amigaos-ar qv Lib:{NAME}_PPC.a %n*Nppc-amigaos-ar qv Lib:All_PPC.a %n" > Lib:LibStubs/{NAME}/Make_{Name}.LibPPC
	Execute Lib:LibStubs/{NAME}/Make_{Name}.LibPPC

	Cd Lib:LibStubs/{NAME}/WOS
	FD2LibWOS {FD}
	List #?.s LFormat="Echo %n*NPasm_wos -F2 -O65536 %s" > Lib:LibStubs/{NAME}/Make_{Name}.AsmWOS
	Execute Lib:LibStubs/{NAME}/Make_{Name}.AsmWOS
	List #?.o LFORMAT="PmmLibr R Lib:{NAME}_WOS %m*NPmmLibr R Lib:All_WOS %m" > Lib:LibStubs/{NAME}/Make_{Name}.LibWOS
	Execute Lib:LibStubs/{NAME}/Make_{Name}.LibWOS
Else
	Echo "{FD}*N{NAME}.Lib ist aktuell!"
EndIf
