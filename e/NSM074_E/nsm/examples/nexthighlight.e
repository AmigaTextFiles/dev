-> nexthighlight.e

/*

nexthighlight.c by Kjetil S. Matheussen 14.12.98.
nexthighlight.e by Claude Heiland-Allen 1999.05.16

*/

OPT OSVERSION=37, REG=3

MODULE 'other/nsm', 'other/nsm_extra'

RAISE "MEM" IF String() = NIL

PROC main() HANDLE

	DEF oss, bb,
		numlines, mline, start,
	    buffer[128] : STRING

	IF (oss := nsm_getoctabase()) = NIL THEN Raise("nsm")
	IF (bb := nsm_getcurrblockbase(oss)) = NIL THEN Raise("nsm")

	numlines := nsm_getnumlines(bb)
	start    := nsm_getcurrline(oss)
	IF start = (numlines - 1) THEN Raise(0)

	FOR mline := start + 1 TO numlines - 1 DO EXIT nsm_getlinehighlight(bb, mline)

	nsm_sendrexx(StringF(buffer, 'ED_ADVANCELINE DOWN \d', mline - start))

EXCEPT DO

	SELECT exception
	CASE "MEM";  WriteF('Error: no mem\n')
	CASE "nsm";  WriteF('Error: no nsm\n')
	ENDSELECT

ENDPROC IF exception THEN 5 ELSE 0

version: CHAR '$VER: nexthighlight 1.1 (1999.05.16)', 0
