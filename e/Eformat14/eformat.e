/* Formatted with Eformat v1.4 from file "df1:eformat.e" */
/*
Eformat v1.4 - Formats E source code into a format I like.

Thanks to whoever wrote the stack code...

*/
MODULE 'dos/dos'

OPT OSVERSION=37

ENUM NOERROR,ERR_NOFILE,ERR_COFILE,ERR_NOMEM,ERR_UNKNOWN

OBJECT st_stackType
	top, count
ENDOBJECT

DEF rdargs,srcfh

PROC main()
	DEF myarg[2]:LIST,raw[300]:STRING,trim[300]:STRING,fw[30]:STRING,
	sel_level=0,sel_tablevel=0,case_tablevel,sstr,tl,key,a,
	addtab,us:st_stackType
	tl:=0
	
	IF (rdargs:=ReadArgs('Source/A',myarg,0))>0
		IF FileLength(myarg[0])>0
			srcfh:=Open(myarg[0],MODE_OLDFILE) ; st_init(us)
			IF srcfh>0
				WriteF('/* Formatted with Eformat v1.4 from file "\s" */\n',myarg[0])
				ReadStr(srcfh,raw)
				REPEAT
					IF CtrlC()
						WriteF('\n/* User Aborted Formatting! */\n')
						getout(0)
					ENDIF
					sstr:=TrimStr(raw)
					/* Copy trimmed string to work buffer... ('trim') */
					StrCopy(trim,sstr,ALL)
					/* Search for first word in line and isolate it... */
					a:=InStr(trim,' ',0)
					IF a>-1
						StrCopy(fw,trim,a)
					ELSE
						StrCopy(fw,trim,ALL)
					ENDIF
					/* Pad it in case it's less than 4 characters... */
					StrAdd(fw,'   ',ALL)
					key:=Long(fw) ; addtab:=FALSE
					SELECT key
						CASE "PROC"
							IF findnonquoted(trim,' RETURN',0)=-1
								addtab:=TRUE
							ENDIF
							tl:=0
						CASE "ENDP"
							tl:=0
						CASE "IF  "
							IF findnonquoted(trim,' THEN',0)=-1
								addtab:=TRUE
							ENDIF
						CASE "ELSE"
							IF findnonquoted(trim,' THEN',0)=-1
								tl-- ; addtab:=TRUE
							ENDIF
						CASE "ENDI"
							tl--
						CASE "SELE"
							sel_level++ ; sel_tablevel:=tl ; case_tablevel:=tl+1
							st_push(us,sel_tablevel) ; addtab:=TRUE
						CASE "ENDS"
							IF (sel_level--)>-1
								sel_tablevel:=st_pop(us)
								tl:=sel_tablevel ; case_tablevel:=tl-1
							ENDIF
						CASE "CASE"
							tl:=case_tablevel ; addtab:=TRUE
						CASE "DEFA"
							tl:=case_tablevel ; addtab:=TRUE
						CASE "REPE"
							IF findnonquoted(trim,' UNTIL',0)=-1
								addtab:=TRUE
							ENDIF
						CASE "UNTI"
							tl--
						CASE "LOOP"
							IF findnonquoted(trim,' ENDLOOP',0)=-1
								addtab:=TRUE
							ENDIF
						CASE "ENDL"
							tl--
						CASE "FOR "
							IF findnonquoted(trim,' DO',0)=-1 AND findnonquoted(trim,'ENDFOR',0)=-1
								addtab:=TRUE
							ENDIF
						CASE "ENDF"
							tl--
						CASE "WHIL"
							IF findnonquoted(trim,' DO',0)=-1 AND findnonquoted(trim,'ENDWHILE',0)=-1
								addtab:=TRUE
							ENDIF
						CASE "ENDW"
							tl--
						CASE "EXCE"
							tl:=0 ; addtab:=TRUE
						CASE "OBJE"
							addtab:=TRUE
						CASE "ENDO"
							tl--
					ENDSELECT
					IF tl>0
						FOR a:=1 TO tl
							WriteF('\c',9)
						ENDFOR
					ELSE
						IF tl<0
							WriteF('/* Conversion Error! Tab level less than 0! */\n')
							tl:=0
						ENDIF
					ENDIF
					/* Addtab adds a tab AFTER the current line is displayed. */
					IF addtab=TRUE
						tl++
					ENDIF
					WriteF('\s\n',trim)
				UNTIL ReadStr(srcfh,raw)=-1
				getout(0)
			ELSE
				error(ERR_COFILE,0)
			ENDIF
		ELSE
			error(ERR_NOFILE,0)
		ENDIF
	ELSE
		WriteF('Incorrect argument format.\n')
	ENDIF
	getout(0)
ENDPROC

CHAR '$VER: Eformat Version 1.4 (c) 1994 Jason Maskell',0

/*
Quoted Keyword kludge for formatting stuff with, you guessed it,
quoted keywords. Like this source, for example.
*/
PROC findnonquoted(source:PTR TO CHAR,target,offs)
	DEF a
	IF (a:=InStr(source,target,offs))>-1
		IF source[a+StrLen(target)]="'"
			a:=-1
		ENDIF
	ENDIF
ENDPROC a

PROC st_init (theStack : PTR TO st_stackType)
	/* Simply declare the stack variable as st_stackType.   The status of the */
	/* stack can be checked by testing stackname.count.                       */
	theStack.top := NIL
	theStack.count := 0
ENDPROC

PROC st_push (theStack : PTR TO st_stackType, addr)
	DEF newList, tempList
	newList := List (1)
	ListCopy (newList, [addr], ALL)
	tempList := Link (newList, theStack.top)
	theStack.top := tempList
	theStack.count := theStack.count + 1
ENDPROC

PROC st_pop (theStack : PTR TO st_stackType)
	DEF list, addr = NIL
	IF theStack.count
		list := theStack.top
		addr := ^list
		theStack.top := Next (list)
		theStack.count := theStack.count - 1
	ENDIF
ENDPROC  addr

PROC error(err,str)
	DEF work[256]:STRING
	SELECT err
		CASE ERR_NOFILE
			StringF(work,'Couldn''t find source E source file.\n')
		CASE ERR_COFILE
			StringF(work,'Couldn''t open file. DOS Error \d\n',IoErr())
		CASE ERR_NOMEM
			StringF(work,'Unable to allocate memory.\n')
		CASE ERR_UNKNOWN
			StringF(work,'Unknown error code! \d',err)
	ENDSELECT
	request('Eformat Error',work,'Ok',0)
	getout(11)
ENDPROC
PROC request(title,body,gadgets,args)
ENDPROC EasyRequestArgs(0,[20,0,title,body,gadgets],0,args)

PROC getout(retcode)
	IF srcfh
		Close(srcfh)
	ENDIF
	FreeArgs(rdargs)
	CleanUp(retcode)
ENDPROC
