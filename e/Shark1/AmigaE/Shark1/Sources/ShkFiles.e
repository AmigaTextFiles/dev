OPT MODULE
OPT EXPORT

MODULE 'dos/dos'

PROC skOpenF(file)
DEF fh
fh:=Open(file,MODE_READWRITE)
RETURN fh
ENDPROC

PROC mLoadF(file)
DEF fh
fh:=Open(file,OLDFILE)
RETURN fh
ENDPROC

PROC mSaveF(file)
DEF fh
fh:=Open(file,NEWFILE)
RETURN fh
ENDPROC

PROC mAppendF(file)
DEF fh
fh:=Open(file,$3EC)
Seek(fh,0,1)
RETURN fh
ENDPROC

PROC mReadLine(handle, buffer, seperator)   -> (filehandle,buffer,'\n')
  DEF bytes, strMax, eoln
  strMax:=StrMax(buffer)
  bytes:=Read(handle, buffer, strMax)
  eoln:=InStr(buffer, seperator, 0)
  IF eoln>-1
    Seek(handle, -(bytes-eoln-1), OFFSET_CURRENT)
    buffer[eoln]:=0
  ELSE
    buffer[bytes]:=0
    eoln:=IF bytes=0 THEN -1 ELSE bytes
  ENDIF
ENDPROC eoln

PROC mWriteLine(filehandle,string)
DEF length
length:=Write(filehandle,string,StrLen(string))
RETURN length
ENDPROC

PROC mCloseF(filehandle)
Close(filehandle)
ENDPROC

PROC mFileCopy(src,dest)
DEF old,new,napis,filelen

old:=Open(src,OLDFILE)
IF old=0 THEN RETURN -1
filelen:=FileLength(src)
IF filelen=-1 THEN RETURN -1
napis:=New(filelen+1)
Read(old,napis,filelen)
Close(old)
new:=Open(dest,NEWFILE)
IF new=0 THEN RETURN -2
Write(new,napis,filelen)
Close(new)
ENDPROC
