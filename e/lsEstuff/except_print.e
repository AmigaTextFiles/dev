OPT MODULE

EXPORT PROC print_exception(exception, exceptioninfo=NIL)
SELECT exception
->general...
CASE "LIB"
   WriteF('library')
CASE "DEV"
   WriteF('device')
CASE "WIN"
   WriteF('window')
CASE "ARGS"
   WriteF('args')
CASE "SCR"
   WriteF('screen')
CASE "OPEN"
   WriteF('open file')
CASE "PORT"
   WriteF('create msgport')
CASE "SIG"
   WriteF('alloc signal')
CASE "FONT"
   WriteF('open font')
CASE "FPO"
   WriteF('find port')
CASE "EXE"
   WriteF('systemtaglist')
CASE "NIL"
   WriteF('NILCHECK')
CASE "IN"
   WriteF('input didnt succeed')
CASE "OUT"
   WriteF('output didnt succeed')
CASE "^C"
   WriteF('ctrl c break')
CASE "QUIT"
   WriteF('program termination\n')
->eget stuff..
CASE "GLE"
   WriteF('GLE')
DEFAULT
   ->
ENDSELECT
IF exceptioninfo
   WriteF(' exceptioninfo # : \d\n', exceptioninfo)
   IF StrLen(exceptioninfo) > 3
      WriteF(' exceptioninfo str : \s[20]\n', exceptioninfo)
   ENDIF
ENDIF
ENDPROC

