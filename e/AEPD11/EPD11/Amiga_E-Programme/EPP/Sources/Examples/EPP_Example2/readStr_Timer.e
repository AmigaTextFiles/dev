/* readStr_Timer.e - supply filename on command-line */
PMODULE 'PMODULES:eTimer'
PMODULE 'PMODULES:readStr'

RAISE "CBRK" IF CtrlC()=TRUE,
      "MEM" IF String()=NIL

ENUM ET_ReadStr,
     ET_readStr,
     ET_MAIN

DEF fh=NIL, s=NIL:PTR TO CHAR

PROC time_ReadStr()
  et_startTimer(ET_ReadStr, 'ReadStr')
  WHILE ReadStr(fh, s)>-1 DO NOP
  et_stopTimer()
ENDPROC

PROC time_readStr()
  et_startTimer(ET_readStr, 'readStr')
  WHILE readStr(fh, s)>-1 DO NOP
  et_stopTimer()
ENDPROC

PROC main() HANDLE
  DEF x
  IF arg[]=NIL THEN Raise("ARGS")
  IF (fh:=Open(arg, OLDFILE))=NIL THEN Raise("FILO")
  et_startTimer(ET_MAIN, 'main')
  s:=String(128)
  WriteF('Timing ReadStr\n')
  time_ReadStr()
  Seek(fh, 0, OFFSET_BEGINNING)
  WriteF('Timing readStr')
  time_readStr()
  DisposeLink(s)
  et_stopTimer()
  Close(fh)
  RETURN 0
EXCEPT
  IF fh THEN Close(fh)
  IF s THEN DisposeLink(s)
  SELECT exception
    CASE "CBRK"; x:='User break'
    CASE "ARGS"; x:='Bad args'
    CASE "FILO"; x:='Can\at open file'
    CASE "MEM";  x:='No mem'
  ENDSELECT
  WriteF('\s\n', x)
  RETURN 20
ENDPROC
