-> .e

/*

.c by Kjetil S. Matheussen 10.12.98.
.e by Claude Heiland-Allen 1999.05.16

*/

OPT OSVERSION=37

MODULE 'other/nsm', 'other/nsm_extra'

RAISE "MEM" IF String() = NIL

PROC main() HANDLE

	DEF oss, rdargs = NIL, args : PTR TO LONG

	IF (oss := nsm_getoctabase()) = NIL THEN Raise("nsm")

	-> ReadArgs() is much easier and nicer
	args := NEW [0]
	IF (rdargs := ReadArgs('', args, NIL)) = NIL THEN Raise("ARGS")


	nsm_updateeditor(oss)

EXCEPT DO

	IF rdargs THEN FreeArgs(rdargs)

	SELECT exception
	CASE "ARGS"; WriteF('Error: bad args\n')
	CASE "MEM";  WriteF('Error: no mem\n')
	CASE "nsm";  WriteF('Error: no nsm\n')
	ENDSELECT

ENDPROC IF exception THEN 5 ELSE 0

PROC hexval(str) IS Val(StringF(String(16),'$\s',str))

version: CHAR '$VER:  1.1 (1999.05.16)', 0
