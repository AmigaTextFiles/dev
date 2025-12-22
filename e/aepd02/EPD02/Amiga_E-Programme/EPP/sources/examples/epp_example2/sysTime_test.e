PMODULE 'PMODULES:sysTime'

PROC main ()
  DEF systemTime [8] : STRING
  VOID systemTimeStr (systemTime)
  WriteF ('The current time is \s\n', systemTime)
ENDPROC