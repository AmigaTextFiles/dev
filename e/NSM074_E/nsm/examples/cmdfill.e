-> cmdfill.e
/*
cmdfill.c by Kjetil S. Matheussen 10.12.98.
cmdfill.e by Claude Heiland-Allen 1999.05.16

cmdfill command start end delta [post] [nofill]

command, start, end are hex
delta is float

fillcmdnum now default, with nofill control

*/

OPT OSVERSION=37

MODULE 'other/nsm', 'other/nsm_extra'

RAISE "MEM" IF String() = NIL

PROC main() HANDLE

	DEF oss, block,
	    track, line, page, intnotelast, intnote, post = TRUE,
	    prefix, rangestart, rangeend, firsttime = TRUE, onecmd = TRUE,
	    incdec = -1.0, note = 0.0, rdargs = NIL, args : PTR TO LONG

	IF (oss := nsm_getoctabase()) = NIL THEN Raise("nsm")
	IF (block := nsm_getcurrblockbase(oss)) = NIL THEN Raise("nsm")

	-> ReadArgs() is much easier and nicer
	-> changed FILLCMDNUM to (more useful?) NOFILL
	args := NEW [0,0,0,0,0,0]
	IF (rdargs := ReadArgs(
	    'P=COMMAND/A,RS=START/A,RE=END/A,ID=DELTA/A,POST/S,NF=NOFILL/S',
	    args, NIL)) = NIL THEN Raise("ARGS")

	prefix     := hexval(args[0])
	rangestart := hexval(args[1])
	rangeend   := hexval(args[2])
	incdec     := RealVal(args[3])
	post       := args[4]
	onecmd     := args[5]

	IF (prefix < 0) OR (127 < prefix) THEN Raise("ARGS")
	IF ! incdec <= 0.0 THEN Raise("ARGS")

	track := nsm_getcurrtrack(oss)
	line  := nsm_getcurrline(oss)
	page  := nsm_getcurrpage(oss)

	IF rangeend < rangestart THEN incdec := ! -incdec

	note := rangestart ! + (post ! * incdec)    -> TRUE = -1 in E  (= 1 in C)

	REPEAT
		note := ! note + incdec
		intnote := ! note !
		IF (intnote <> intnotelast) OR firsttime
			IF Not(onecmd) OR firsttime
				nsm_setcmdnum(block, track, line, page, prefix)
			ENDIF
			nsm_setcmdlvl(block, track, line, page, intnote)
			firsttime := FALSE
			intnotelast := intnote
		ENDIF
		line++
	UNTIL ((! incdec < 0.0) AND (! note < (rangeend!))) OR
	      ((! incdec > 0.0) AND (! note >=(rangeend!)))

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

version: CHAR '$VER: cmdfill 1.1 (1999.05.16)', 0
