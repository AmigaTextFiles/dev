/* bReadStr.e module test */
PMODULE 'PMODULES:bReadStr'

RAISE "MEM" IF New()=NIL,
      "MEM" IF String()=NIL

PROC main() HANDLE
  DEF fh=NIL, rData:readDataType, str, exitmsg
  IF arg[]=NIL THEN Raise("ARGS")
  IF (fh:=Open(arg, OLDFILE))=NIL THEN Raise("FILO")
  rData.fh:=fh
  rData.inputBuffer:=New(2048)
  rData.bufSize:=2048
  rData.length:=0
  rData.pos:=0
  rData.maxLineLength:=128
  str:=String(128)
  WHILE bReadStr(rData, str) DO WriteF('\s\n', str)
  Close(fh)
  CleanUp(0)
EXCEPT
  IF fh THEN Close(fh)
  SELECT exception
    CASE "ARGS"; exitmsg:='Usage: bReadStr <file>'
    CASE "MEM";  exitmsg:='No mem'
    CASE "FILO"; exitmsg:='Can\at open file'
    DEFAULT;     exitmsg:='Huh?'
  ENDSELECT
  WriteF('\s\n', exitmsg)
  CleanUp(20)
ENDPROC
