/* PortablE target module for C++ AROS */
OPT NATIVE, INLINE, PREPROCESS
PUBLIC MODULE 'PE/CPP/base'

STATIC pe_TargetOS = 'AROS'
#define pe_TargetOS_AROS

TYPE CLONG IS NATIVE {long} VALUE

PROC new()
	IF PrivateGetMainArgc() = 0
		->(launched from Workbench) so must open our own Shell window (if there is Shell output), since AROS's new C runtime doesn't do it for us (sigh)
		ReopenStdOut('CON://///CLOSE/WAIT/AUTO')
	ENDIF
ENDPROC

/* stdin & stdout */

PROC ReopenStdIn(fileName:ARRAY OF CHAR)
	IF NATIVE {freopen(} fileName {, "r", stdin)} ENDNATIVE !!ARRAY = NIL THEN Throw("FILE", 'ReopenStdIn(); failed to re-open stdin on the given path')
ENDPROC

PROC ReopenStdOut(fileName:ARRAY OF CHAR)
	IF NATIVE {freopen(} fileName {, "w", stdout)} ENDNATIVE !!ARRAY = NIL THEN Throw("FILE", 'ReopenStdOut(); failed to re-open stdout on the given path')
ENDPROC

PROC SetStdIn(fileHandle:PTR) RETURNS oldstdin:PTR
	oldstdin := stdin
	->stdin := fileHandle
	Throw("ERR", 'SetStdIn(); this procedure cannot be supported by AROS, use ReopenStdIn() instead')
	fileHandle:=NIL	->dummy
ENDPROC

PROC SetStdOut(fileHandle:PTR) RETURNS oldstdout:PTR
	oldstdout := stdout
	->stdout = fileHandle
	Throw("ERR", 'SetStdOut(); this procedure cannot be supported by AROS, use ReopenStdOut() instead')
	fileHandle:=NIL	->dummy
ENDPROC

PROC OpenInOut(fileName:ARRAY OF CHAR) RETURNS fileHandle:PTR IS NATIVE {fopen(} fileName {, "r+")} ENDNATIVE !!PTR

PROC CloseInOut(fileHandle:PTR) IS NATIVE {fclose( (FILE*)} fileHandle {)} ENDNATIVE

/* system constants */

CONST OLDFILE = 1005
CONST NEWFILE = 1006

/* temporary access to some variables for compatability */

->NATIVE {conout} DEF conout:PTR
