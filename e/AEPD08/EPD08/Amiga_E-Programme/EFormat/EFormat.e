/*
	Eformat v1.2 - Formats E source code into a format I like.
*/
OPT OSVERSION=37
MODULE 'dos/dos'
ENUM NOERROR,ERR_NOFILE,ERR_COFILE,ERR_NOMEM,ERR_UNKNOWN
DEF rdargs,srcfh

PROC main()
	DEF myarg[1]:LIST,raw[300]:STRING,trim[300]:STRING,fw[30]:STRING,
	sel_level=0,case_before=0,sstr,tl,key,a,addtab,user_stack,usptr
	tl:=0
	rdargs:=ReadArgs('Source/A',myarg,0)
	IF rdargs>0
		IF FileLength(myarg[0])>0
			srcfh:=Open(myarg[0],MODE_OLDFILE)
			IF srcfh>0
				WriteF('/* Converted with Eformat v1.2 from file "\s" */\n',myarg[0])
				ReadStr(srcfh,raw)
				IF (user_stack:=New(100))=0
					error(ERR_NOMEM,0)
				ENDIF
				REPEAT
					IF CtrlC()
						WriteF('Ctrl C!\n')
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
							IF InStr(trim,' RETURN',0)=-1
								addtab:=TRUE
							ENDIF
							tl:=0
						CASE "ENDP"
							tl:=0
						CASE "IF  "
							IF InStr(trim,' THEN',0)=-1
								addtab:=TRUE
							ENDIF
						CASE "ELSE"
							IF InStr(trim,' THEN',0)=-1
								tl-- ; addtab:=TRUE
							ENDIF
						CASE "ENDI"
							tl--
						CASE "SELE"
							MOVE.L		A1,-(A7)
							MOVEA.L		usptr,A1
							MOVE.B		case_before,-(A1)
							MOVE.L		(A7)+,A1
							case_before:=0 ; addtab:=TRUE ; sel_level++
						CASE "ENDS"
							tl:=tl-2
							IF (sel_level--)>-1
								MOVE.L		A1,-(A7)
								MOVEA.L		usptr,A1
								MOVE.B		(A1)+,case_before
								MOVE.L		(A7)+,A1
							ELSE
								case_before:=0
							ENDIF
						CASE "CASE"
							IF (case_before++)>=1
								tl--
							ENDIF
							IF InStr(trim,';',0)=-1
								addtab:=TRUE
							ENDIF
						CASE "DEFA"
							IF (case_before++)>=1
								tl--
							ENDIF
							IF InStr(trim,';',0)=-1
								addtab:=TRUE
							ENDIF
						CASE "REPE"
							IF InStr(trim,' UNTIL',0)=-1
								addtab:=TRUE
							ENDIF
						CASE "UNTI"
							tl--
						CASE "LOOP"
							IF InStr(trim,' ENDLOOP',0)=-1
								addtab:=TRUE
							ENDIF
						CASE "ENDL"
							tl--
						CASE "FOR "
							IF InStr(trim,' DO',0)=-1 AND InStr(trim,'ENDFOR',0)=-1
								addtab:=TRUE
							ENDIF
						CASE "ENDF"
							tl--
						CASE "WHIL"
							IF InStr(trim,' DO',0)=-1 AND InStr(trim,'ENDWHILE',0)=-1
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
	Dispose(user_stack)
	getout(0)
ENDPROC

CHAR '$VER: Eformat Version 1.2 (c) 1994 Jason Maskell',0

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
