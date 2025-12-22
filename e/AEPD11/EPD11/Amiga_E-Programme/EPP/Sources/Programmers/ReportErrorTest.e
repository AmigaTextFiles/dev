RAISE "MEM" IF String()=NIL

MODULE 'dos/dos'

PMODULE 'reportError'

PROC main() HANDLE
  DEF i, errMsg
  FOR i:=1 TO 100 DO reportError(i)
EXCEPT
  SELECT exception
    CASE "MEM";  errMsg:='Out of memory'
    CASE "FILO"; errMsg:='Can''t open map file'
    CASE "FILR"; errMsg:='Can''t read map file'
    CASE "lmax"; errMsg:='Line number out of range'
    DEFAULT;     errMsg:='It''s a mystery...'
  ENDSELECT
  WriteF('ERROR: \s\n', errMsg)
  RETURN RETURN_FAIL
ENDPROC  RETURN_OK
