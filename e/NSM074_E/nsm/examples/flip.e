-> flip.e

/*

flip.c by Kjetil S. Matheussen 14.1.98.
flip.e by Claude Heiland-Allen 1999.05.16

*/

OPT OSVERSION=37, REG=3

MODULE 'other/nsm', 'other/nsm_extra'

RAISE "MEM" IF String() = NIL

PROC main() HANDLE

	DEF oss, bb,
	    starttrack, endtrack, startline, endline, pages, data,
	    track, line, page, cmd

	IF (oss := nsm_getoctabase()) = NIL THEN Raise("nsm")
	IF (bb := nsm_getcurrblockbase(oss)) = NIL THEN Raise("nsm")

	IF nsm_ranged(oss)
		starttrack := nsm_getrangestarttrack(oss)
		endtrack   := nsm_getrangeendtrack(oss)
		startline  := nsm_getrangestartline(oss)
		endline    := nsm_getrangeendline(oss)
	ELSE
		starttrack := nsm_getcurrtrack(oss)
		endtrack   := starttrack
		startline  := 0
		endline    := nsm_getnumlines(bb)-1
	ENDIF

	pages := nsm_getnumpages(bb)

	FOR line := 0 TO (endline - startline + 1)/2 - 1
		FOR track := starttrack TO endtrack
			FOR cmd := MED_NOTE TO MED_INUM
				data := nsm_getmed(cmd, bb, track, line + startline, 1)
				nsm_setmed(cmd, bb, track, line + startline, 1,
				    nsm_getmed(cmd, bb, track, endline - line, 1))
				nsm_setmed(cmd, bb, track, endline - line, 1, data)
			ENDFOR
			FOR page := 1 TO pages + 1
				FOR cmd := MED_CMDNUM TO MED_CMDLVL
					data := nsm_getmed(cmd, bb, track, line + startline, page)
					nsm_setmed(cmd, bb, track, line + startline, page,
					    nsm_getmed(cmd, bb, track, endline - line, page))
					nsm_setmed(cmd, bb, track, endline - line, page, data)
				ENDFOR
			ENDFOR
		ENDFOR
	ENDFOR

	nsm_updateeditor(oss)

EXCEPT DO

	SELECT exception
	CASE "MEM";  WriteF('Error: no mem\n')
	CASE "nsm";  WriteF('Error: no nsm\n')
	ENDSELECT

ENDPROC IF exception THEN 5 ELSE 0

version: CHAR '$VER: flip 1.1 (1999.05.16)', 0
