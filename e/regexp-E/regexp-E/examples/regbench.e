/*
** regbench.e
** quick-n-dirty example of regexp.library usage
** (L) 1998 by Matthias Bethke
** Converted from C to E by Per Olofsson
:ts=2
*/

MODULE 'dos/dos',
       'regexp',
       'libraries/regexp'

PROC main() HANDLE
	DEF pat:PTR TO CHAR,								-> the pattern
			i,															-> a counter
			re:PTR TO regexp,								-> handle for the compiled expression
			ds[2]:ARRAY OF datestamp,				-> for timing
			tix,														-> elapsed ticks
			rcode=RETURN_OK									-> program return code

	pat:='b.*x...a+w$'

/* open regexp.library */
	IF (regexpbase:=OpenLibrary('regexp.library',37))=NIL THEN Raise("RLIB")

	PrintF('Compiling pattern once, matching 50000 times\n')
/* take current time */
	DateStamp(ds[0])
/* compile the pattern to internal format */
	IF (re:=RegComp(pat))
		FOR i:=0 TO 24999
			RegExec(re,'blllllxabcaw')						-> one pattern that matches
			RegExec(re,'bhh1234567890hhx222w')		-> one that doesn't - jut 2 b fair :)
		ENDFOR
/* free the regexp */
		RegFree(re)
	ELSE
		PrintF('Can''t compile pattern "\s"!\n',pat)
		rcode:=RETURN_ERROR
	ENDIF
/* timing stuff */
	DateStamp(ds[1])
	tix:=50*60*(ds[1].minute-ds[0].minute)
	tix:=tix+(ds[1].tick-ds[0].tick)
	tix:=Shl(tix,1)

	PrintF('Time: \d.\z\d[2]s (\d ticks), \d matches per second\n',tix/100,Mod(tix,100),Shr(tix,1),5000000/tix)

EXCEPT DO
	IF regexpbase THEN CloseLibrary(regexpbase)
	SELECT exception
		CASE "RLIB" ; PrintF('Can''t open regexp.library V37+!\n') ; rcode:=RETURN_FAIL
	ENDSELECT
ENDPROC rcode
