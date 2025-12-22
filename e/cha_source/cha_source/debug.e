/*==========================================================================+
| debug.e                                                                   |
| debugging macros                                                          |
+--------------------------------------------------------------------------*/

OPT PREPROCESS
OPT MODULE
OPT EXPORT

/*-------------------------------------------------------------------------*/

->#define DEBUG

#ifdef DEBUG
#define debug(x) _debug(x)
#endif

#ifndef DEBUG
#define debug(x)
#endif

/*-------------------------------------------------------------------------*/

#ifdef DEBUG

RAISE "MEM" IF String() = NIL

PROC _debug(list : PTR TO LONG)
	DEF l
	IF CtrlC() THEN Raise("^C")
	WriteF('+++ Debug: ')
	l := ListLen(list)
	SELECT l
	CASE 1;  WriteF(list[0])
	CASE 2;  WriteF(list[0], list[1])
	CASE 3;  WriteF(list[0], list[1], list[2])
	CASE 4;  WriteF(list[0], list[1], list[2], list[3])
	CASE 5;  WriteF(list[0], list[1], list[2], list[3], list[4])
	CASE 6;  WriteF(list[0], list[1], list[2], list[3], list[4], list[5])
	CASE 7;  WriteF(list[0], list[1], list[2], list[3], list[4], list[5], list[6])
	CASE 8;  WriteF(list[0], list[1], list[2], list[3], list[4], list[5], list[6], list[7])
	CASE 9;  WriteF(list[0], list[1], list[2], list[3], list[4], list[5], list[6], list[7], list[8])
	DEFAULT; Raise("dbug")
	ENDSELECT
	WriteF('\n')
ENDPROC

PROC complex2string(z : PTR TO LONG) IS StringF(String(40), '\s + \s i', float2string(z[0]), float2string(z[1]))

PROC float2string(f) IS RealF(String(16), f, 6)

#endif

/*--------------------------------------------------------------------------+
| END: debug.e                                                              |
+==========================================================================*/
