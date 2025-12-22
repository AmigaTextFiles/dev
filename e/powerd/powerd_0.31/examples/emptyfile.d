// creates a file (full of zero bytes) of given length

MODULE	'exec/memory'

PROC main()
	DEF	args=[NIL,NIL,NIL]:L,ra
	ENUM	FILE,LENGTH,VERBOSE
	IF ra:=ReadArgs('FILE/A,LENGTH/A/N,V=VERBOSE/S',args,NIL)
		DEF	file,buffer,length,wrote,add,realadd
		IF file:=Open(args[FILE],NEWFILE)
			IF buffer:=AllocVec(32770,MEMF_PUBLIC|MEMF_CLEAR)
				wrote:=0
				length:=Long(args[LENGTH])
				IF args[VERBOSE]
					PrintF('emptyfile v1.0 by MarK 27.8.2001\nFile name: ''\s'', File Length: \d\n',args[FILE],length)
				ENDIF
				WHILE wrote<length
					add:=length-wrote
				EXITIF add<=0
					add:=IF add<=32768 THEN add ELSE 32768
					realadd:=Write(file,buffer,add)
				EXITIF realadd<>add DO PrintFault(IOErr(),'emptyfile')
					wrote+=realadd
				EXITIF CtrlC()
				ENDWHILE
				FreeVec(buffer)
			ENDIF
			Close(file)
		ELSE PrintFault(IOErr(),'emptyfile')
		FreeArgs(ra)
	ELSE PrintFault(IOErr(),'emptyfile')
ENDPROC
