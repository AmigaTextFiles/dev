/* PortablE target module for C++ AmigaOS */
OPT NATIVE, INLINE, PREPROCESS
PUBLIC MODULE 'PE/CPP/base'

STATIC pe_TargetOS = 'AmigaOS4'
#define pe_TargetOS_AmigaOS4

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
	NATIVE {
	#ifdef __NEWLIB_H__
		stdin = (FILE*) } fileHandle {;
	#else
		__iob[0] = (iob*) } fileHandle {;
	#endif
	} ENDNATIVE
ENDPROC

PROC SetStdOut(fileHandle:PTR) RETURNS oldstdout:PTR
	oldstdout := stdout
	NATIVE {
	#ifdef __NEWLIB_H__
		stdout = (FILE*) } fileHandle {;
	#else
		__iob[1] = (iob*) } fileHandle {;
	#endif
	} ENDNATIVE
ENDPROC

PROC OpenInOut(fileName:ARRAY OF CHAR) RETURNS fileHandle:PTR IS NATIVE {fopen(} fileName {, "r+")} ENDNATIVE !!PTR

PROC CloseInOut(fileHandle:PTR) IS NATIVE {fclose( (FILE*)} fileHandle {)} ENDNATIVE

/* system constants */

CONST OLDFILE = 1005
CONST NEWFILE = 1006

/* temporary access to some variables for compatability */

->NATIVE {conout} DEF conout:PTR
