-> general exception catcher for test purposes

OPT MODULE
OPT POINTER

PROC report_exception()
  DEF eArray[5]:ARRAY OF CHAR, e:PTR TO CHAR
  IF exception
    Print('Program caused exception: ')
    IF exception<10000
      Print('\d\n',exception)
    ELSE
      SELECT exception
        CASE "MEM";  Print('no memory\n')
        CASE "OPEN"; Print('could not open file \s\n',IF exceptionInfo THEN exceptionInfo ELSE '')
        CASE "^C";   Print('***BREAK\n')
        -> and others...
        DEFAULT
          e := eArray
          e[4]:=0
          PutQuad(e!!PTR!!PTR TO QUAD, exception)
          WHILE e[]=0 DO e++
          Print('"\s" ',e)
          Print(IF exceptionInfo<1000 THEN '[\d]\n' ELSE '[\h]\n',exceptionInfo)
      ENDSELECT
    ENDIF
  ENDIF
ENDPROC
