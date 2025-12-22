/* Buffered read string. */

OPT TURBO

OBJECT readDataType
  fh:LONG
  bufSize:LONG
  maxLineLength:LONG
  inputBuffer:LONG
  length:LONG
  pos:LONG
ENDOBJECT

PROC bReadStr(rData:PTR TO readDataType, string)
  DEF inputBuffer, i=0, pos
  inputBuffer:=rData.inputBuffer
  pos:=rData.pos
  WHILE i<rData.bufSize
    IF pos>=rData.length
      rData.length:=Read(rData.fh, inputBuffer, rData.bufSize)
      IF rData.length<1
          IF i>0
            string[i++]:=10
            string[i]:=0
            rData.length:=i
          ENDIF
          rData.pos:=rData.length
          RETURN i
      ENDIF
      pos:=0
    ENDIF
    string[i]:=inputBuffer[pos++]
    IF (string[i++]=10) OR (i=rData.maxLineLength)
      SetStr(string, i)
      rData.pos:=pos
      RETURN i
    ENDIF
  ENDWHILE
ENDPROC
  /* bReadStr */


