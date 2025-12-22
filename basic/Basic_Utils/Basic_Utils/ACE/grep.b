GOTO SkipVer
ASSEM
  EVEN
  DC.B "$VER: grep 1.0 (10.10.97)"
  EVEN
END ASSEM
SkipVer:

LIBRARY "dos.library"
DECLARE FUNCTION _Read&(fh&,buf&,len&) LIBRARY "dos.library"
DECLARE FUNCTION Seek&(fh&,p&,m&) LIBRARY "dos"

IF ARG$(1)="?" THEN
  PRINT "USAGE: grep file search"
  PRINT
  PRINT "grep displays all occurances of 'search' in the file 'file'."
  SYSTEM 5
END IF

IF ARGCOUNT = 2 THEN
  buflen& = LEN(ARG$(2))
  OPEN "I",1,ARG$(1)
  IF (HANDLE(1) <> 0) THEN
    FOR t& = 0 TO LOF(1) - buflen&)
      h&=Seek&(HANDLE(1),t&,(-1&))
      b& = ALLOC(buflen& + 1)
      r&=_Read&(HANDLE(1),b&,buflen&)
      if CSTR(b&)=ARG$(2) THEN PRINT t&+1,
      CLEAR ALLOC
    NEXT t&
    CLOSE 1
    PRINT
  ELSE
    PRINT "grep: Can't open ";ARG$(1);" for input"
    CLOSE 1
    SYSTEM 20
  END IF
ELSE
  PRINT "grep: Required argument missing"
  SYSTEM 10
END IF

