/*==========================================================================+
| errors.e                                                                  |
| unified error reporting                                                   |
+--------------------------------------------------------------------------*/

OPT MODULE,
    PREPROCESS
OPT EXPORT

/*-------------------------------------------------------------------------*/

#define error(s) Throw("ERR", s)
#define argerror(s) Throw("args", s)

/*-------------------------------------------------------------------------*/

PROC errorstring(x, xi)
	DEF s = 0, r2 = 0, r3 = 0
	r2 := xi
	SELECT x
	CASE 0
	CASE "ERR";  s := '*** Error: \s\n'
	CASE "^C";   s := '*** Break\n'
	CASE "MEM";  s := '*** Error: not enough free memory\n'
	CASE "NEW";  s := '*** Error: not enough free memory\n'
	CASE "ARG";  s := '*** Usage error: value expected for argument \s\n'
	CASE "IARG"; s := '*** Usage error: integer expected for argument \s\n'
	CASE "FARG"; s := '*** Usage error: real number expected for argument \s\n'
	CASE "SARG"; s := '*** Usage error: string expected for argument \s\n'
	CASE "OARG"; s := '*** Usage error: instrument number expected for argument \s\n'
	CASE "ARGS"; s := '*** Usage error: type ? for help\n'
	CASE "args"; s := '*** Usage error: \s\n'
	CASE "rarg"; s := '*** Usage error: argument \s outside valid range\n'
	CASE "oss";  s := '*** OSS error: \s\n'
	CASE "bug";  s := '*** Internal error: \z\h[8]\n'
	DEFAULT;     s := '*** Unknown error: \z\h[8] \z\h[8] ("\s", "\s")\n'; r2 := x; r3 := xi
	ENDSELECT
ENDPROC s, r2, r3

/*-------------------------------------------------------------------------*/

EXPORT PROC printerror(x, xi)
	DEF s = 0, a = 0, b = 0
	s, a, b := errorstring(x, xi)
	IF s THEN WriteF(s, a, b, NEW [a, 0], b)
ENDPROC

/*--------------------------------------------------------------------------+
| END: errors.e                                                             |
+==========================================================================*/
