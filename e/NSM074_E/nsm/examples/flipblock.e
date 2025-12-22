-> flipblock.e

/*

flipblock.c by Kjetil S. Matheussen 9.12.98.
flipblock.e by Claude Heiland-Allen 1999.05.16

*/

OPT OSVERSION=37, REG=3

MODULE 'other/nsm', 'other/nsm_extra'

RAISE "MEM" IF String() = NIL

PROC main() HANDLE

	DEF oss, bb,
	    numtracks, length, pages, data,
	    track, line, page, cmd,
	    buffer[128] : STRING

	IF (oss := nsm_getoctabase()) = NIL THEN Raise("nsm")
	IF (bb := nsm_getcurrblockbase(oss)) = NIL THEN Raise("nsm")

	numtracks := nsm_getnumtracks(bb)
	length    := nsm_getnumlines(bb) - 1
	pages     := nsm_getnumpages(bb)

	FOR line := 0 TO length/2 - 1
		IF nsm_getlinehighlight(bb, length - line) <> nsm_getlinehighlight(bb, line)
			nsm_sendrexx(StringF(buffer, 'ED_HIGHLIGHTLINE \d TOGGLE', line))
			nsm_sendrexx(StringF(buffer, 'ED_HIGHLIGHTLINE \d TOGGLE', length - line))
		ENDIF
		FOR track := 0 TO numtracks
			FOR cmd := MED_NOTE TO MED_INUM
				data := nsm_getmed(cmd, bb, track, line, 1)
				nsm_setmed(cmd, bb, track, line, 1,
				    nsm_getmed(cmd, bb, track, length - line, 1))
				nsm_setmed(cmd, bb, track, length - line, 1, data)
			ENDFOR
			FOR page := 1 TO pages + 1
				FOR cmd := MED_CMDNUM TO MED_CMDLVL
					data := nsm_getmed(cmd, bb, track, line, page)
					nsm_setmed(cmd, bb, track, line, page,
					    nsm_getmed(cmd, bb, track, length - line, page))
					nsm_setmed(cmd, bb, track, length - line, page, data)
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

version: CHAR '$VER: flipblock 1.1 (1999.05.16)', 0
