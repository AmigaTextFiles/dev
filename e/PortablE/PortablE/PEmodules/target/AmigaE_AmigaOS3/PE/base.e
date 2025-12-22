/* PortablE target module for AmigaE */
OPT PREPROCESS, NATIVE
PUBLIC MODULE 'PE/AmigaE/base'

PROC ReopenStdIn(fileName:ARRAY OF CHAR)
	CloseInOut(stdin)
	stdin := OpenInOut(fileName)
ENDPROC

PROC ReopenStdOut(fileName:ARRAY OF CHAR)
	CloseInOut(stdout)
	stdout := OpenInOut(fileName)
ENDPROC

PROC OpenInOut(fileName:ARRAY OF CHAR) RETURNS fileHandle:PTR IS NATIVE {Open(} fileName {, 1005 /*MODE_OLDFILE*/)} ENDNATIVE !!PTR

PROC CloseInOut(fileHandle:PTR) IS NATIVE {Close(} fileHandle {)} ENDNATIVE

STATIC pe_TargetOS = 'AmigaOS3'
#define pe_TargetOS_AmigaOS3
