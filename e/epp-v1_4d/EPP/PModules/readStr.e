OPT TURBO

MODULE 'dos/dos'

PROC readStr(handle, buffer)
  DEF bytes, strMax, eoln
  strMax:=StrMax(buffer)
  bytes:=Read(handle, buffer, strMax)
  eoln:=InStr(buffer, '\n', 0)
  IF eoln>-1
    Seek(handle, -(bytes-eoln-1), OFFSET_CURRENT)
    buffer[eoln]:=0
  ELSE
    buffer[bytes]:=0
    eoln:=IF bytes=0 THEN -1 ELSE bytes
  ENDIF
ENDPROC eoln
  /* readStr */

