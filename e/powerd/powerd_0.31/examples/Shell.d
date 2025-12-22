// Silly Shell Example by Wouter van Oortmerssen

MODULE	'dos/dos','startup/startup_dos'

PROC main()
	DEF	inputstring[80]:STRING,con
	IF con:=Open('con:10/10/600/100/MySillyShell v0.1',MODE_NEWFILE)
		Write(con,'Shell by $#%! in 1991 (and MarK 1999). "BYE" to stop.\n',STRLEN)
		WHILE StrCmp(inputstring,'BYE')=FALSE
			Execute(inputstring,0,con)
			Write(con,'MyPrompt> ',STRLEN)
			ReadEStr(con,inputstring)
			UpperStr(inputstring)
		ENDWHILE
		Close(con)
	ELSE
		PrintFault(IOErr(),'shell')
	ENDIF
ENDPROC
