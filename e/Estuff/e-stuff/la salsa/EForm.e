PROC main()
	DEF fhin, fhout
	DEF str[300]:STRING, s[300]:STRING
	DEF rdargs, myargs[3]:ARRAY OF LONG
	DEF indent=0, i=0, now=TRUE
	rdargs:=ReadArgs('IN/A,OUT/A',myargs,NIL)
	IF rdargs
		fhin:=Open(myargs[0],OLDFILE)
		fhout:=Open(myargs[1],NEWFILE)
		WHILE Fgets(fhin,str,300)
			StrCopy(s,TrimStr(str))
			IF StrCmp(s,'PROC',4)
				IF InStr(s,'IS',0)<>-1
					now:=FALSE
				ELSE
					now:=TRUE
					indent++
				ENDIF
			ELSEIF StrCmp(s,'ENDPROC',7)
				indent:=0
				now:=FALSE
			ELSEIF StrCmp(s,'IF',2)
				IF InStr(s,'THEN',0)<>-1
				now:=FALSE
			ELSE
				indent++
				now:=TRUE
			ENDIF
		ELSEIF StrCmp(s,'ENDIF',5)
			indent--
			now:=FALSE
		ELSEIF StrCmp(s,'ELSE',4)
			now:=TRUE
		ELSEIF StrCmp(s,'FOR ',4)
			IF InStr(s,'DO',0)<>-1
				now:=FALSE
			ELSE
				indent++
				now:=TRUE
			ENDIF
		ELSEIF StrCmp(s,'ENDFOR',6)
			indent--
			now:=FALSE
		ELSEIF StrCmp(s,'SELECT',6)
			indent++
			now:=TRUE
		ELSEIF StrCmp(s,'CASE',4)
			now:=TRUE
		ELSEIF StrCmp(s,'DEFAULT',7)
			now:=TRUE
		ELSEIF StrCmp(s,'ENDSELECT',9)
			now:=FALSE
			indent--
		ELSEIF StrCmp(s,'REPEAT',6)
			IF InStr(s,'UNTIL',0)<>-1
				now:=FALSE
			ELSE
				indent++
				now:=TRUE
			ENDIF
		ELSEIF StrCmp(s,'UNTIL',5)
			indent--
			now:=FALSE
		ELSEIF StrCmp(s,'LOOP',4)
			IF InStr(s,'ENDLOOP',7)
				now:=FALSE
			ELSE
				now:=TRUE
				indent++
			ENDIF
		ELSEIF StrCmp(s,'ENDLOOP',7)
			indent--
			now:=FALSE
		ELSEIF StrCmp(s,'WHILE',5)
			IF InStr(s,'DO',0)<>-1
				now:=FALSE
			ELSE
				now:=TRUE
				indent++
			ENDIF
		ELSEIF StrCmp(s,'ENDWHILE',8)
			indent--
			now:=FALSE
		ELSEIF StrCmp(s,'EXCEPT',6)
			now:=TRUE
			indent:=0
		ELSEIF StrCmp(s,'OBJECT',6)
			now:=TRUE
			indent++
		ELSEIF StrCmp(s,'ENDOBJECT',9)
			now:=FALSE
			indent--
		ELSEIF StrCmp(s,'',ALL)
			StrCopy(s,'\n')
			now:=FALSE
		ELSE
			now:=FALSE
		ENDIF
		IF now=TRUE
			IF indent THEN FOR i:=1 TO indent-1 DO Write(fhout,'\t',1)
			Write(fhout,s,StrLen(s))
		ELSEIF now=FALSE
			IF indent THEN FOR i:=1 TO indent DO Write(fhout,'\t',1)
			Write(fhout,s,StrLen(s))
		ENDIF
	ENDWHILE
	Close(fhout)
	Close(fhin)
	FreeArgs(rdargs)
ENDIF
ENDPROC
