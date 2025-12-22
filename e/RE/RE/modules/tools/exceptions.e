-> general exception catcher for test purposes

PROC report_exception()
  DEF e[5]:ARRAY
  IF exception
    WriteF('Program caused exception: ')
    IF exception<10000
      WriteF('\d\n',exception)
    ELSE
      SELECT exception
        CASE "MEM";  WriteF('no memory\n')
        CASE "OPEN"; WriteF('could not open file \s\n',IF exceptioninfo THEN exceptioninfo ELSE '')
        CASE "^C";   WriteF('***BREAK\n')
        -> and others...
        DEFAULT
          e[4]:=0
          ^e:=exception
          WHILE e[]=0 DO e++
          WriteF('"\s" ',e)
          WriteF(IF exceptioninfo<1000 THEN '[\d]\n' ELSE '[\h]\n',exceptioninfo)
      ENDSELECT
    ENDIF
  ENDIF
ENDPROC
