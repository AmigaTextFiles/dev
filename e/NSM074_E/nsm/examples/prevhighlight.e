-> prevhighlight.e

/*

prevhighlight.c by Kjetil S. Matheussen 14.12.98.
prevhighlight.e by Claude Heiland-Allen 1999.05.16

*/

OPT OSVERSION=37, REG=3

MODULE 'other/nsm', 'other/nsm_extra'

RAISE "MEM" IF String() = NIL

PROC main() HANDLE

	DEF oss, bb,
		mline, start,
	    buffer[128] : STRING

	IF (oss := nsm_getoctabase()) = NIL THEN Raise("nsm")
	IF (bb := nsm_getcurrblockbase(oss)) = NIL THEN Raise("nsm")

	start    := nsm_getcurrline(oss)
	IF start = 0 THEN Raise(0)

	FOR mline := start - 1 TO 0 STEP -1 DO EXIT nsm_getlinehighlight(bb, mline)

	nsm_sendrexx(StringF(buffer, 'ED_ADVANCELINE UP \d', start - mline))

EXCEPT DO

	SELECT exception
	CASE "MEM";  WriteF('Error: no mem\n')
	CASE "nsm";  WriteF('Error: no nsm\n')
	ENDSELECT

ENDPROC IF exception THEN 5 ELSE 0

version: CHAR '$VER: prevhighlight 1.1 (1999.05.16)', 0
