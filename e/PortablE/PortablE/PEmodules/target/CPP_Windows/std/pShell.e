/* partially alias module */
OPT NATIVE, INLINE, FORCENATIVE
PUBLIC MODULE 'targetShared/CPP/pShell'

PROC ShellArgs() RETURNS shellArgs:ARRAY OF CHAR IS argString

PRIVATE
DEF argString:STRING

PROC emptyOrHasSpace(string:ARRAY OF CHAR) IS (InStr(string, ' ') <> -1) OR (string[0] = "\0")

PROC new()
	DEF argc, argv:ARRAY OF ARRAY OF CHAR
	DEF len, i, emptyOrHasSpace:BOOL
	
	argc := PrivateGetMainArgc()
	argv := PrivateGetMainArgv()
	
	->create argString
	len := 0
	FOR i := 1 TO argc-1 DO len := len + 1 + StrLen(argv[i]) + (IF emptyOrHasSpace(argv[i]) THEN 2 ELSE 0)
	
	NEW argString[len]
	FOR i := 1 TO argc-1
		emptyOrHasSpace := emptyOrHasSpace(argv[i])
		
		IF i <> 1 THEN StrAdd(argString, ' ')
		IF emptyOrHasSpace THEN StrAdd(argString, '"')
		StrAdd(argString, argv[i])
		IF emptyOrHasSpace THEN StrAdd(argString, '"')
	ENDFOR
ENDPROC

PROC end()
	END argString
ENDPROC
PUBLIC
