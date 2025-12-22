/* PortablE target module for C++ Windows */
OPT NATIVE, INLINE, PREPROCESS
PUBLIC MODULE 'PE/CPP/base'

STATIC pe_TargetOS = 'Windows'
#define pe_TargetOS_Windows

TYPE CLONG IS NATIVE {long} VALUE

/* stdin & stdout */

PROC ReopenStdIn(fileName:ARRAY OF CHAR)
	IF NATIVE {freopen(} fileName {, "r", stdin)} ENDNATIVE !!ARRAY = NIL THEN Throw("FILE", 'ReopenStdIn(); failed to re-open stdin on the given path')
ENDPROC

PROC ReopenStdOut(fileName:ARRAY OF CHAR)
	IF NATIVE {freopen(} fileName {, "w", stdout)} ENDNATIVE !!ARRAY = NIL THEN Throw("FILE", 'ReopenStdOut(); failed to re-open stdout on the given path')
ENDPROC

PROC SetStdIn(fileHandle:PTR) RETURNS oldstdin:PTR
	oldstdin := stdin
	{_iob[STDIN_FILENO] = *(FILE*)} fileHandle
ENDPROC

PROC SetStdOut(fileHandle:PTR) RETURNS oldstdout:PTR
	oldstdout := stdout
	{_iob[STDOUT_FILENO] = *(FILE*)} fileHandle
ENDPROC

PROC OpenInOut(fileName:ARRAY OF CHAR) RETURNS fileHandle:PTR IS NATIVE {fopen(} fileName {, "r+")} ENDNATIVE !!PTR

PROC CloseInOut(fileHandle:PTR) IS NATIVE {fclose( (FILE*)} fileHandle {)} ENDNATIVE

/* temporary access to some variables for compatability */

->NATIVE {conout} DEF conout:PTR
