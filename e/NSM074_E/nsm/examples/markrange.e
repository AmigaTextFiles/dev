-> markrange.e

/*

markrange.c by Kjetil S. Matheussen 14.12.98.
markrange.e by Claude Heiland-Allen 1999.05.16

*/

OPT OSVERSION = 37

MODULE 'other/nsm', 'other/nsm_extra'

RAISE "MEM" IF String() = NIL

PROC main() HANDLE

	DEF oss, buffer[128] : STRING, starttrack, endtrack, startline, endline

	IF (oss := nsm_getoctabase()) = NIL THEN Raise("nsm")

	IF nsm_ranged(oss)
		starttrack := nsm_getrangestarttrack(oss)
		endtrack   := nsm_getcurrtrack(oss)
		IF starttrack > endtrack
			starttrack := endtrack
			endtrack   := nsm_getrangeendtrack(oss)
		ENDIF
		startline := nsm_getrangestartline(oss)
		endline   := nsm_getcurrline(oss)
		IF startline >= endline
			startline := endline
			endline   := nsm_getrangeendline(oss)
		ENDIF
	ELSE
		starttrack := nsm_getcurrtrack(oss)
		startline  := nsm_getcurrline(oss)
		endtrack := starttrack
		endline  := startline
	ENDIF
	nsm_sendrexx(StringF(buffer,
	    'rn_setrange starttrack \d startline \d endtrack \d endline \d',
	                  starttrack,  startline,   endtrack,   endline))

EXCEPT DO

	SELECT exception
	CASE "MEM";  WriteF('Error: no mem\n')
	CASE "nsm";  WriteF('Error: no nsm\n')
	ENDSELECT

ENDPROC IF exception THEN 5 ELSE 0

version: CHAR '$VER: markrange 1.1 (1999.05.16)', 0
