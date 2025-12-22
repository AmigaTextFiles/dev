GOTO SkipVer
ASSEM
  EVEN
  DC.B "$VER: replace 1.0 (10.10.97)"
  EVEN
END ASSEM
SkipVer:

LIBRARY "dos.library"
DECLARE FUNCTION _Read&(fh&,buf&,len&) LIBRARY "dos.library"
DECLARE FUNCTION _Write&(fh&,buf&,len&) LIBRARY "dos.library"
DECLARE FUNCTION Seek&(fh&,p&,m&) LIBRARY "dos"

IF ARG$(1)="?" THEN
  PRINT "USAGE: replace file search replace [newfile]"
  PRINT
  print "replace replaces all occurances of 'search' in the file 'file' by"
  print "'replace'. The result is either written to 'newfile' or replaces"
  print "the old file."
  SYSTEM 5
END IF

IF ARGCOUNT >= 3 THEN
  neu$=arg$(4)
  IF neu$="" THEN neu$=arg$(1)
  temp$="SwapFile.TMP"
  buflen& = LEN(ARG$(2))
  OPEN "I",1,ARG$(1)
  IF (HANDLE(1) <> 0) THEN
    OPEN "O",2,temp$
    b& = ALLOC(buflen& + 1)
    FOR t& = 0 TO LOF(1)
      h&=Seek&(HANDLE(1),t&,(-1&))
      r&=_Read&(HANDLE(1),b&,buflen&)
      IF CSTR(b&)=ARG$(2) THEN
        r&=_Write&(HANDLE(2),SADD(ARG$(3)),LEN(ARG$(3)))
        t& = t& + buflen& - 1
      ELSE
        r&=_Write&(HANDLE(2),b&,1&)
      END IF
    NEXT t&
    CLOSE 1
    CLOSE 2
    SYSTEM "COPY "+temp$+" "+neu$
    KILL temp$
  ELSE
    PRINT "replace: Can't open ";ARG$(1);" for input"
    CLOSE 1
    SYSTEM 20
  END IF
ELSE
  PRINT "replace: Required argument missing"
  SYSTEM 10
END IF

