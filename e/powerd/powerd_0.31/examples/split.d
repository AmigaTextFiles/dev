MODULE	'exec/memory'

ENUM	SOURCE,LENGTH

BYTE '\0\0$VER:split v1.0 by Martin Kuchinka (17.6.2001)\0\0'

PROC main()
	DEF	ra=NIL,args=[NIL,NIL,NIL]:L
	DEF	length,total
	DEF	ifile,mem=NIL
	DEF	done=0,rel,oname[256]:CHAR,count=0,ofile=NIL

	// get all the needed stuff
	IFN ra:=ReadArgs('SOURCE/A,LENGTH/N',args,NIL) THEN Raise("DOS")
	length:=IF args[LENGTH] THEN Long(args[LENGTH]) ELSE 800000

	// get length of the file to be splitted
	IF (total:=FileLength(args[SOURCE]))<=0 THEN Raise("DOS")

	// open the input file
	IFN ifile:=Open(args[SOURCE],OLDFILE) THEN Raise("DOS")

	// get needed memory chunk
	IFN mem:=AllocVec(length,MEMF_PUBLIC) THEN Raise("MEM")

	WHILE done<total
		StringF(oname,'\s.\z\d[2]',args[SOURCE],count)
		IFN ofile:=Open(oname,NEWFILE) THEN Raise("DOS")

		rel:=Read(ifile,mem,length)
		done+=rel
		Write(ofile,mem,rel)

		Close(ofile);	ofile:=NIL
		IF CtrlC() THEN Raise("^C")
		count++
	ENDWHILE

EXCEPTDO
	IF ofile THEN Close(ofile)
	IF ifile THEN Close(ifile)
	IF mem THEN FreeVec(mem)
	IF ra THEN FreeArgs(ra)
	SELECT exception
	CASE "DOS";	PrintFault(IOErr(),'split')
	CASE "^C";	PrintF('\s: ***break\n','split')
	CASE "MEM";	PrintF('\s: not enough memory\n','split')
	ENDSELECT
ENDPROC
