GOTO SkipVer
ASSEM
  EVEN
  DC.B "$VER: mbver 1.0 (10.10.97)"
  EVEN
END ASSEM
SkipVer:

LIBRARY "dos.library"
DECLARE FUNCTION _Read&(fh&,buf&,len&) LIBRARY "dos.library"
DECLARE FUNCTION _Write&(fh&,buf&,len&) LIBRARY "dos.library"
DECLARE FUNCTION Seek&(fh&,p&,m&) LIBRARY "dos"

IF ARG$(1)="?" THEN
  PRINT "USAGE: mbver file year_without_century"
  PRINT
  PRINT "mbver corrects the version string of Maxon (Hisoft) Basic executables."
  PRINT
  PRINT "Note: Add a space to your version string. The space character will be"
  PRINT "      replaced by a null string."
  SYSTEM 5
END IF

IF ARGCOUNT = 2 THEN
  neu$=arg$(1)
  temp$="SwapFile.TMP"
  a$="."+ARG$(2)+") "
  b$="."+ARG$(2)+")"+CHR$(0)
  buflen& = LEN(a$)
  OPEN "I",1,ARG$(1)
  IF (HANDLE(1) <> 0) THEN
    OPEN "O",2,temp$
    b& = ALLOC(buflen& + 1)
    FOR t& = 0 TO LOF(1)
      h&=Seek&(HANDLE(1),t&,(-1&))
      r&=_Read&(HANDLE(1),b&,buflen&)
      IF CSTR(b&)=a$ THEN
        r&=_Write&(HANDLE(2),SADD(b$),5)
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

