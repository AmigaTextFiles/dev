/* $VER: readlinetest (25.9.97) © Frédéric Rodrigues
   Tests readline time with other methods

   Do:
   1> ec readlinetest sym opti
   1> run aprof readlinetest

   Timings:              milliseconds  (file in RAM)
   readline            - 0.786
   readStr (E list)    - 3.257
   FGets (dos.library) - 3.562
   ReadStr             - 30.082
*/

MODULE '*modules/readline','dos/dos'

PROC main()
  DEF fh,o,buf[256]:STRING,i
  IF fh:=Open('xpke.e',OLDFILE)
    o:=readlinefrom(fh)
    FOR i:=1 TO 100
        readline(o)
    ENDFOR
    endreadline(o)
    Close(fh)
  ENDIF
  IF fh:=Open('xpke.e',OLDFILE)
    FOR i:=1 TO 100
        fgets(fh,buf,256)
    ENDFOR
    Close(fh)
  ENDIF
  IF fh:=Open('xpke.e',OLDFILE)
    FOR i:=1 TO 100
        readStr(fh,buf)
    ENDFOR
    Close(fh)
  ENDIF
  IF fh:=Open('xpke.e',OLDFILE)
    FOR i:=1 TO 100
        ReadStr(fh,buf)
    ENDFOR
    Close(fh)
  ENDIF
ENDPROC

PROC fgets(fh,buf,len)
  Fgets(fh,buf,len)
ENDPROC

PROC readStr(handle, buffer)
  DEF bytes, size, eof=FALSE
  bytes:=Read(handle, buffer, StrMax(buffer))
  size:=bytes
  IF InStr(buffer, '\n', 0) > -1
    Seek(handle, -(bytes - InStr(buffer, '\n', 0)-1), OFFSET_CURRENT)
    bytes:=InStr(buffer, '\n', 0)
  ELSE
    IF size < StrMax(buffer) THEN eof:=TRUE
  ENDIF
  buffer[bytes]:=0
ENDPROC eof
