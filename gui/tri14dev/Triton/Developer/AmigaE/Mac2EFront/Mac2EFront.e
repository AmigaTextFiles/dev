/*	Mac2EFront V1.00
     By Frank Verheyen, 1994
     This command is meant TO be bound into your compilation-script
     Parameters:
		destinationfile, the file in which translated source will be dumped
		sourcefile, the file with your code & macros used in it

	Inside the sourcefile, a line of the form
		/* MAC2E macrofile */
     (mind the uppercase OF MAC2E, so just mentioning 'mac2e' or 'Mac2E' etc.
	in a comment or inside your code won't trigger this program; only total
	UPPERCASE will do so.)
     It announces this sourcefile should be treated with Mac2E AND the macrofile
     before compilation.
     Put the command inside remarks, so it won't disturb normal code.

	Note: currently only one macrofile can be treated per sourcefile,
		maybe I'll change that sometimes :)

*/

OPT OSVERSION=37
CONST MAXPATH=500

ENUM ER_NONE,ER_BADARGS,ER_UTIL,ER_ITARG,ER_COML
ENUM ER_OPENFILE,ER_READFILE,ER_FILEEMPTY,ER_NOMEM
ENUM ARG_DEST,ARG_SRC,NUMARGS

MODULE 'dos/dosasl', 'dos/dos', 'utility'
/*--------------------------------------------------------------------------*/
RAISE ER_OPENFILE IF Open()=NIL,
	ER_NOMEM IF New()=NIL
/*--------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------*/
PROC main()
	DEF src,dest
	DEF src1,dest1
	DEF macfile=NIL

	get_arguments({src},{dest})

	dest1 := cloneString(dest)
	src1 := cloneString(src)
	WriteF('Invoking Mac2EFront <\s> <\s>\n',dest1,src1)
	macfile := parseSource(src1)
	IF macfile<>0
		IF StrCmp(macfile,'')=NIL THEN invokeMac2E(src1,dest1,macfile)
	ENDIF
ENDPROC
/*--------------------------------------------------------------------------*/
PROC parseSource(src) HANDLE
	DEF fh=NIL,flen=0,buf=NIL,len=0
	DEF t,g,foundflag,foundpos,grabcount
	DEF maccommand[MAXPATH]:STRING
	DEF macfile[MAXPATH]:STRING

	WriteF('Parsing \s\n',src)
	StrCopy(maccommand,'MAC2E')

	IF (fh := Open(src,OLDFILE))
		flen := FileLength(src)
		IF flen>0
			buf := New(flen+1)       /* will be filled with 0 */
			IF (Read(fh,buf,flen)<>flen)
                    Raise(ER_READFILE)
               ELSE
               	len := StrLen(maccommand)
                    FOR t := 0 TO flen-len
                    	IF buf[t] = maccommand[0]
                    		foundflag := TRUE
                    		FOR g := 0 TO len-1
                    			IF buf[t+g] <> maccommand[g] THEN foundflag := FALSE
                    		ENDFOR
                    		IF foundflag
	                              foundpos := t+len
							StrCopy(macfile,'')		-> start clean
	                              grabcount := 0
	                              WHILE buf[foundpos]=" " OR buf[foundpos]="\t"
	                              	INC foundpos
                              	ENDWHILE
	                              WHILE buf[foundpos+grabcount]<>" " AND buf[foundpos+grabcount]<>"*"
	                                   macfile[grabcount] := buf[foundpos+grabcount]
	                                   INC grabcount
							ENDWHILE

							macfile[grabcount] := 0	-> add tail-zero
							IF buf THEN Dispose(buf)
							IF fh THEN Close(fh)
							WriteF('MAC2E command encountered: macrofile =\s\n',macfile)
							RETURN cloneString(macfile)
                    		ENDIF
                   		ENDIF
                   	ENDFOR

                    WriteF('Sourcefile doesn\at seem to be needing Macrofiles.\n')
			ENDIF
			IF buf THEN Dispose(buf)
		ELSE
     		Raise(ER_FILEEMPTY)
		ENDIF
          Close(fh)
	ENDIF

	CleanUp(0)
EXCEPT
	SELECT exception
		CASE ER_OPENFILE
			WriteF('File error: could not Open file\n')
		CASE ER_READFILE
			WriteF('File error: could not Read file\n')
          CASE ER_FILEEMPTY
          	WriteF('File error: sourcefile is empty\n')
	ENDSELECT
     IF fh THEN Close(fh)
     IF buf THEN Dispose(buf)
     CleanUp(0)
ENDPROC 0
/*--------------------------------------------------------------------------*/
PROC invokeMac2E(src,dest,macfile)
	DEF con
	DEF command[500]:STRING

  	IF con:=Open('con:0/20/639/100/Mac2EFront V1.0',NEWFILE)
  		conout := con
  		stdout := con

		WriteF('Processing sourcefile \s\n',src)
		WriteF('into destinationfile \s\n',dest)
		WriteF('using macrofile \s\n\n',macfile)

          StrCopy(command,'E:bin/Mac2E ')
          StrAdd(command,src)
          StrAdd(command,' ')
          StrAdd(command,dest)
          StrAdd(command,' E:MacroFiles/')
          StrAdd(command,TrimStr(macfile))

		WriteF('Executing:')
		WriteF('<\s>',command)
		Execute(command,0,con)

		WriteF('\nDone\n')
		conout := NIL
		Close(con)
	ENDIF
ENDPROC
/*--------------------------------------------------------------------------*/
PROC get_arguments(src,dest) HANDLE
	DEF args[NUMARGS]:LIST,x,rdargs=NIL

	IF (utilitybase:=OpenLibrary('utility.library',37))=NIL THEN Raise(ER_UTIL)
	FOR x:=0 TO NUMARGS-1 DO args[x]:=0		/* fill array with 0 */
	rdargs:=ReadArgs('SRC,DEST',args,NIL)
	IF rdargs=NIL THEN Raise(ER_BADARGS)

	^src := args[ARG_SRC]
	^dest := args[ARG_DEST]

	IF utilitybase THEN CloseLibrary(utilitybase)
	IF rdargs THEN FreeArgs(rdargs)

EXCEPT
	SELECT exception
		CASE ER_BADARGS
			WriteF('Bad Arguments ...\n')
		CASE ER_COML;
			WriteF('No commandline specified\n')
		CASE ER_UTIL;
			WriteF('Couldn\at open utility.library v37\n')
		CASE ERROR_BUFFER_OVERFLOW;
			WriteF('Internal error\n')
	ENDSELECT
ENDPROC
/*--------------------------------------------------------------------------*/
-> cloneString(): make a new string, clone original in it, return address of clone
PROC cloneString(s:PTR TO CHAR)
	DEF clone
	clone := String(StrLen(s))
	StrCopy(clone,s,ALL)
ENDPROC clone
/*--------------------------------------------------------------------------*/
