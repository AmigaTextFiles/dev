/* 	A tiny program to show PPC infos on your system. 

	Original in C by R. Schmidt
	First E translation (some bugs and crashes) by R. Zimmerling
	Second E traslation by R. Santato

*/


MODULE  'exec/types','exec/libraries',
        'utility/tagitem','*ppc','*libraries/ppc'

DEF i,								-> I must use this ! E doesn't accept ABSOLUTE PTRs!
    cpuclock:LONG,				          -> Variable on which I put the clock frequency
    cpu,								-> CPU return value...
    cpustring[15]:STRING,				-> ... in a better form !
    revision


PROC main()
ppclibbase:=OpenLibrary('ppc.library',0)				-> Opening the library...
IF ppclibbase=NIL THEN WriteF('Cannot open ppc.library\n')	-> ... and check of the pointer !

some_infos()
get_clock()							-> Search for PPC cpu frequency
get_cpu()								-> and wich CPU
get_revision()							-> and which version

ENDPROC


PROC some_infos()
WriteF('\n\n------------------------------------\n\n')
WriteF('     PowerPC System Checker\n\n')
WriteF(' written in E by Riccardo Santato\n\n')
ENDPROC


PROC get_clock()
i:=PPCINFOTAG_CPUCLOCK
cpuclock:=PpCGetAttrs({i})
WriteF('PPC Clock Frequency = \d\n',cpuclock)
ENDPROC

PROC get_cpu()
i:=PPCINFOTAG_CPU
cpu:=PpCGetAttrs({i})
SELECT cpu
  CASE CPU_603
    StrCopy(cpustring,'PPC 603',ALL)
  CASE CPU_604
    StrCopy(cpustring,'PPC 604',ALL)
  CASE CPU_602
    StrCopy(cpustring,'PPC 602',ALL)
  CASE CPU_603e
    StrCopy(cpustring,'PPC 603e',ALL)
  CASE CPU_603p
    StrCopy(cpustring,'PPC 603p',ALL)
  CASE CPU_604e
    StrCopy(cpustring,'PPC 604e',ALL)
  DEFAULT
    StrCopy(cpustring,'Unknown',ALL)
ENDSELECT
WriteF('Cpu type:=\d\nCpu name:=\s\n',cpu,cpustring)
ENDPROC

PROC get_revision()
i:=PPCINFOTAG_CPUREV
revision:=PpCGetAttrs({i})
WriteF('Cpu revision:=\d\n\n',revision)
WriteF('------------------------------------\n\n')
ENDPROC