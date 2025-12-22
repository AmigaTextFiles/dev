OPT NATIVE, INLINE
MODULE 'dos'

PROC ShellArgs() RETURNS shellArgs:ARRAY OF CHAR IS argString

PRIVATE
DEF argString:STRING

PROC new()
	DEF len
	
	argString := StrJoin(GetArgStr())
	len := EstrLen(argString)
	IF argString[len-1] = "\n" THEN SetStr(argString,len-1)
ENDPROC

PROC end()
	END argString
ENDPROC
PUBLIC
