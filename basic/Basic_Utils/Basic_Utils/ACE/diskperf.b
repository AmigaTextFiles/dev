GOTO SkipVer
ASSEM
  EVEN
  DC.B "$VER: diskperf 1.0 (23.12.96)"
  EVEN
END ASSEM
SkipVer:

LIBRARY "dos.library"
DECLARE FUNCTION _Read&(fh&,buf&,len&) LIBRARY "dos.library"

CONST buflen = 32768

IF ARGCOUNT = 1 THEN
  IF ARG$(1)="?" THEN
    PRINT "USAGE: diskperf filename"
    PRINT
    PRINT "Measures the disk performance by reading filename from disk. The longer the"
    PRINT "file to be examined is, the more accurate is the performance measurement."
    SYSTEM 5
  ELSE
    OPEN "I",1,ARG$(1)
    IF (HANDLE(1) <> 0) THEN
      b& = ALLOC(buflen + 1)
      l& = LOF(1)
      r& = buflen
      a = TIMER
      WHILE (r& = buflen)
        r&=_Read&(HANDLE(1),b&,buflen)
      WEND
      b = TIMER
      CLOSE 1
      CLEAR ALLOC
      c = b - a
      IF (c > 1/50) THEN
        r = l& / c / 1024
        PRINT "It took";c;"seconds to read";l&;"bytes."
        PRINT "This results in about";CINT(r);"KB/s."
        SYSTEM 0
      ELSE
        PRINT "Can't measure elapsed time"
        SYSTEM 20
      END IF
    ELSE
      PRINT "Can't open ";ARG$(1);" for input"
      CLOSE 1
      SYSTEM 20
    END IF
  END IF
ELSE
  PRINT "diskperf: Required argument missing"
  SYSTEM 10
END IF
