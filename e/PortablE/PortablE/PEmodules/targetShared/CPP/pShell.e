/* C++ implementation of pShell */
OPT NATIVE, PREPROCESS, INLINE, FORCENATIVE, POINTER
PUBLIC MODULE 'target/PEalias/CtrlC'
{#include <stdlib.h>}

CONST SHELL_RET_OK = 0, SHELL_RET_WARN = 5, SHELL_RET_ERROR = 10, SHELL_RET_FAIL = 20

PROC ExecuteCommand(command:ARRAY OF CHAR) RETURNS executed:BOOL
	DEF ret:INT
	ret := NATIVE {system((const char*)} command {)} ENDNATIVE !!INT
	executed := (ret <> -1) AND (ret <> 127)
ENDPROC

PROC ProgramName() RETURNS progName:ARRAY OF CHAR
	DEF i, chara:CHAR, filePos
	
	progName := PrivateGetMainArgv()[0]
	
	->ensure remove any directory stuff (needed for MorphOS)
	filePos := 0
	i := 0
	REPEAT
		chara := progName[i]
		IF (chara = "/") OR (chara = "\\") OR (chara = ":") THEN filePos := i+1
		
		i++
	UNTIL chara = 0
	
	IF filePos THEN progName := progName + (filePos * SIZEOF CHAR)
ENDPROC

->PROC ShellArgs() RETURNS shellArgs:ARRAY OF CHAR IS ...	->this is defined elsewhere

#ifdef pe_TargetOS_Windows
PROC HighlightOnString()  IS '##'
PROC HighlightOffString() IS '##'
#else
	#ifdef pe_TargetOS_Linux
->PROC HighlightOnString()  IS '\e[33;1;44m'		->bold yellow foreground, blue background
->PROC HighlightOffString() IS '\e[37;0;40m\e[0m'
PROC HighlightOnString()  IS '\e[1;7m'				->bold foreground, invert foreground & background
PROC HighlightOffString() IS '\e[0m'
	#else ->Amiga
PROC HighlightOnString()  IS '\e[32;43m'
PROC HighlightOffString() IS '\e[31;40m\e[0m'
	#endif
#endif
