// small example, of how to use shell arguments with PowerD

OPT	OSVERSION=37

MODULE	'startup/startup_dos'	// only open dos.library, we don't need more.

PROC main()
	DEF	myargs:PTR TO LONG,rdargs
	myargs:=[0,0,0,0]:LONG
	IF rdargs:=ReadArgs('NAME/A,NUMBER/N,BOOL/S,OPT/K',myargs,NIL)
		PrintF('NAME=\s\nNUMBER=\d\nBOOL=\d\nOPT=\s\n',myargs[0],Long(myargs[1]),myargs[2],myargs[3])
		FreeArgs(rdargs)
	ELSE
		PrintFault(IOErr(),'readargs')
	ENDIF
ENDPROC
