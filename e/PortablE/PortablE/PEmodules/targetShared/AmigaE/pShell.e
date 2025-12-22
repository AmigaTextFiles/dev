/* AmigaE implementation of pShell */
OPT NATIVE, INLINE, POINTER, FORCENATIVE
PUBLIC MODULE 'target/PEalias/CtrlC'
MODULE 'exec', 'dos'

CONST SHELL_RET_OK = 0, SHELL_RET_WARN = 5, SHELL_RET_ERROR = 10, SHELL_RET_FAIL = 20

PROC ExecuteCommand(command:ARRAY OF CHAR) RETURNS executed:BOOL IS NATIVE {Execute(} command {, 0, 0)} ENDNATIVE !!BOOL

PROC ProgramName() RETURNS progName:ARRAY OF CHAR IS progString

PROC ShellArgs() RETURNS shellArgs:ARRAY OF CHAR IS {arg}!!ARRAY OF CHAR
->NATIVE {arg} DEF shellArgs:ARRAY OF CHAR

PROC HighlightOnString() IS '\e[32;43m'

PROC HighlightOffString() IS '\e[31;40m\e[0m'

PRIVATE
DEF progString=NILS:STRING

PROC new()
	DEF cli:PTR TO commandlineinterface
	IF cli := Cli()
		progString := bcplToString(cli.commandname)
	ELSE
		progString := StrJoin('UNKNOWN')
	ENDIF
ENDPROC

PROC end()
	END progString
ENDPROC

PROC bcplToString(bcplString:BSTR) RETURNS string:OWNS STRING
	DEF len, temp:ARRAY OF CHAR
	
	temp := Baddr(bcplString) !!ARRAY
	len := CharToUnsigned(temp[0])
	
	NEW string[len]
	StrCopy(string, temp, len, 1)
FINALLY
	IF exception THEN END string
ENDPROC
PUBLIC
