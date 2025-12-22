
/* Questo programma tenta di lanciare un eseguibile ELF esterno, per controllare se gli include
   sono stati tradotti bene. La mia speranza è quella di riuscire a trovare un sistema per creare
   un task con le istruzioni di AmigaE e di darlo in pasto al PPC con qualche funzione ...
*/



MODULE	'*ppc',
		'*libraries/ppc'


PROC main()
DEF elf=NIL:PTR TO LONG

ppclibbase:=OpenLibrary('ppc.library',0)
elf:=PpCLoadObject('loop.elf')
PpCRunObject(elf,NIL)
ENDPROC


