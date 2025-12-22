-> general exception catcher for test purposes

OPT MODULE, AMIGAOS4

EXPORT PROC report_exception()
  DEF e:PTR TO CHAR
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
          e := [exception, 0]
          WHILEN e[] DO e++
          WriteF('"\s" ', e)
          WriteF(IF exceptioninfo<1000 THEN '[\d]\n' ELSE '[\h]\n', exceptioninfo)
      ENDSELECT
    ENDIF
  ENDIF
ENDPROC
