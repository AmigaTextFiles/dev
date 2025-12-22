/*
** regtest.e
** tests some RegExec() returncodes and error conditions
** (L) 1998 by Matthias Bethke
** Converted from C to E by Per Olofsson
:ts=2
*/

MODULE 'dos/dos',
       'regexp',
       'libraries/regexp'

PROC main() HANDLE
	DEF rcode=RETURN_OK

	IF (regexpbase:=OpenLibrary('regexp.library',37))=NIL THEN Raise("RLIB")

	testExp('..[a-zAB](123|456)+','xyg123456')
	testExp(NIL,'blah')
	testExp('.+',NIL)
	testExp('..[a[-zAB]','blah')
	testExp('?(.))','blah')
	testExp('ab*+cd','abcd')

EXCEPT DO
	IF regexpbase THEN CloseLibrary(regexpbase)
	SELECT exception
		CASE "RLIB" ; PrintF('Can''t open regexp.library V37+!\n') ; rcode:=RETURN_FAIL
	ENDSELECT
ENDPROC rcode

PROC testExp(e:PTR TO CHAR,s:PTR TO CHAR)
	DEF ret=0,err=0,re:PTR TO regexp

	IF (re:=RegComp(e))
		ret:=RegExec(re,s)
		err:=IoErr()
		RegFree(re)
	ELSE
		err:=IoErr()
	ENDIF

	PrintF('RegSMatch("\s","\s") = \d',(IF e THEN e ELSE 'NIL'),(IF s THEN s ELSE 'NIL'),ret)
	IF err THEN PrintF('  (IoErr()=\d)\n',err) ELSE PrintF('\n')
ENDPROC
