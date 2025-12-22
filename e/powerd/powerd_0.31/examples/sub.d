// This proggy subtracts two input files and writes result into output file.
// It may be usefull, if you have two same programs/sources, but one doesn't
// run and you can't find differences. If input files are same, output file
// will contain only zeroes.

MODULE	'exec/memory'

OPT	DOSONLY

ENUM	FILEA,FILEB,DST

PROC main()
	DEF	rda,args:PTR TO LONG,mem1,mem2,i1,i2,o
	args:=[NIL,NIL,NIL]
	IF rda:=ReadArgs('FILEA/A,FILEB/A,DST/A',args,NIL)
		IF mem1:=AllocMem(32768,MEMF_PUBLIC)
			IF mem2:=AllocMem(32768,MEMF_PUBLIC)
				IF i1:=Open(args[FILEA],OLDFILE)
					IF i2:=Open(args[FILEB],OLDFILE)
						IF o:=Open(args[DST],NEWFILE)
							Sub(mem1,mem2,i1,i2,o)
							Close(o)
						ELSE PrintFault(IOErr(),'sub')
						Close(i2)
					ELSE PrintFault(IOErr(),'sub')
					Close(i1)
				ELSE PrintFault(IOErr(),'sub')
				FreeMem(mem2,32768)
			ELSE PrintF('\s: not enough memory','sub')
			FreeMem(mem1,32768)
		ELSE PrintF('\s: not enough memory','sub')
		FreeArgs(rda)
	ELSE PrintFault(IOErr(),'sub')
ENDPROC

PROC Sub(bufa:PTR TO CHAR,bufb:PTR TO CHAR,i1,i2,o)
	DEF	l,i
	REPEAT
		l:=Read(i1,bufa,32768)
		Read(i2,bufb,32768)
		FOR i:=0 TO l-1 bufa[i]-=bufb[i]
		Write(o,bufa,l)
	UNTIL l<32768
ENDPROC
