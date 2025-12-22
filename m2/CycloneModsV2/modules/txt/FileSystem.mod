IMPLEMENTATION MODULE FileSystem;

(* (C) Copyright 1994 Marcel Timmermans. All rights reserved. *)

FROM SYSTEM IMPORT ADR,ADDRESS,BYTE;
IMPORT el:ExecL,
       ed:ExecD,
       dd:DosD,
       dl:DosL;

CONST
  maxFileName=255;

TYPE
  FileListPtr=POINTER TO FileList;
  FileList=RECORD
    next:FileListPtr;
    fsFile:File;
    nameString:ARRAY[0..maxFileName] OF CHAR;
  END;

VAR
  inUsedFiles:FileListPtr;


PROCEDURE ClearFile(VAR file:File);
BEGIN
  WITH file DO (* Clear file *)
    handle:=NIL;
    eof:=FALSE;
    mode:=FileModeSet{};
    bufPos:=0;
    bufLen:=0;
    pos:=0;
    res:=notdone;
  END;
END ClearFile;

PROCEDURE Lookup(VAR file:File; name:ARRAY OF CHAR;new:BOOLEAN);
(*$ autoRegs- *)
VAR
  am:LONGINT;
  i:INTEGER;
  nfl:FileListPtr;
BEGIN
  ClearFile(file);
  nfl:=el.AllocMem(SIZE(FileList),ed.MemReqSet{ed.memClear});
  IF nfl#NIL THEN
    i:=0;
    WHILE (i<maxFileName) & (i<=HIGH(name)) & (name[i]#0C) DO
      nfl^.nameString[i]:=name[i];
      INC(i);
    END;
    nfl^.nameString[i]:=0C;
    IF new THEN 
        am:=dd.newFile; file.mode:=FileModeSet{write};
    ELSE 
        am:=dd.oldFile; file.mode:=FileModeSet{read};
    END;
    file.handle:=dl.Open(ADR(nfl^.nameString),am);
    IF file.handle=NIL THEN
      file.res:=openfileErr;
    ELSE
      WITH nfl^ DO
        fsFile:=file;
        next:=inUsedFiles;
      END;
      inUsedFiles:=nfl;
      file.res:=done;
    END;
  ELSE
    file.res:=memErr;
  END;
END Lookup;

PROCEDURE ReadBytes(VAR file:File; adr:ADDRESS; size:LONGINT);
VAR
  actual,i,bpos:LONGINT;
  bptr:POINTER TO CHAR;
BEGIN
  WITH file DO
    i:=0; bpos:=bufPos;
    IF adr=NIL THEN res:=bufErr; END;
    bptr:=adr;
    WHILE i<size DO
      IF (bpos=bufLen) THEN
        bufPos:=0; bpos:=0;
        bufLen:=dl.Read(handle,ADR(buffer[0]),BufSize);
        IF bufLen<0 THEN res:=readErr; RETURN END;
        IF bufLen=0 THEN eof:=TRUE; RETURN; END;
      END;
      bptr^:=buffer[bpos]; INC(bptr); INC(bpos);
      INC(i);
    END;
    bufPos:=bpos;
    INC(pos,size);
    res:=done;
  END;
END ReadBytes;

PROCEDURE ReadChar(VAR file:File; VAR ch:CHAR);
BEGIN
  WITH file DO
    IF (bufPos=bufLen) THEN
      bufPos:=0;
      bufLen:=dl.Read(handle,ADR(buffer[0]),BufSize);
      IF bufLen<0 THEN res:=readErr; RETURN END;
      IF bufLen=0 THEN eof:=TRUE; RETURN; END;
    END;
    ch:=buffer[bufPos];
    INC(bufPos);
    INC(pos);
  END;
END ReadChar;

PROCEDURE ReadByteBlock(VAR file:File; VAR block:ARRAY OF BYTE);
VAR
  actual,i,bpos:LONGINT;
BEGIN
  WITH file DO
    i:=0; bpos:=bufPos;
    WHILE i<HIGH(block)+1 DO
      IF (bpos=bufLen) THEN
        bufPos:=0; bpos:=0;
        bufLen:=dl.Read(handle,ADR(buffer[0]),BufSize);
        IF bufLen<0 THEN res:=readErr; RETURN END;
        IF bufLen=0 THEN eof:=TRUE; RETURN; END;
      END;
      block[i]:=buffer[bpos]; INC(bpos);
      INC(i);
    END;
    bufPos:=bpos;
    INC(pos,i);
    res:=done;
  END;
END ReadByteBlock;

PROCEDURE FlushBuf(VAR file:File):BOOLEAN;
VAR i,j,len:LONGINT;
BEGIN
  i:=0;
  j:=file.bufPos;
  file.bufPos:=0;
  REPEAT
    len:=dl.Write(file.handle,ADR(file.buffer[i]),j);
    IF len<0 THEN
      file.res:=writeErr;
      RETURN FALSE;
    END;
    INC(i,len);
    DEC(j,len);
  UNTIL j<=0;
  file.res:=done;
  RETURN TRUE;
END FlushBuf;

PROCEDURE WriteBytes(VAR file:File; adr:ADDRESS; size:LONGINT);
VAR
  actual,i,bpos:LONGINT;
  bptr:POINTER TO CHAR;
BEGIN
  WITH file DO
    i:=0; bpos:=bufPos;
    IF adr=NIL THEN res:=bufErr; END;
    bptr:=adr;
    WHILE i<size DO
      IF (bpos=BufSize) THEN
        bufPos:=bpos; bpos:=0;
        IF ~FlushBuf(file) THEN res:=writeErr; RETURN; END;
      END;
      buffer[bpos]:=bptr^; INC(bptr); INC(bpos);
      INC(i);
    END;
    bufPos:=bpos;
    INC(pos,size);
    res:=done;
  END;
END WriteBytes;

PROCEDURE WriteChar(VAR file:File; ch:CHAR);
BEGIN
  WITH file DO
    IF (bufPos=BufSize) THEN
      IF ~FlushBuf(file) THEN res:=writeErr; RETURN; END;
    END;
    buffer[bufPos]:=ch;
    INC(bufPos);
    INC(pos);
  END;
END WriteChar;

PROCEDURE WriteByteBlock(VAR file:File; VAR block:ARRAY OF BYTE);
VAR
  actual,i,bpos:LONGINT;
  bptr:POINTER TO CHAR;
BEGIN
  WITH file DO
    i:=0; bpos:=bufPos;
    WHILE i<HIGH(block)+1 DO
      IF (bpos=BufSize) THEN
        bufPos:=bpos; bpos:=0;
        IF ~FlushBuf(file) THEN res:=writeErr; RETURN; END;
      END;
      buffer[bpos]:=CHAR(block[i]); INC(bpos);
      INC(i);
    END;
    bufPos:=bpos;
    INC(pos,i);
    res:=done;
  END;
END WriteByteBlock;

PROCEDURE GetPos(VAR file:File; VAR Pos:LONGINT);
BEGIN
  Pos:=file.pos;
END GetPos;

PROCEDURE SetPos(VAR file:File;Pos:LONGINT);
BEGIN
  WITH file DO
    IF res=done THEN
      IF dl.Seek(handle,Pos,dd.beginning)=-1 THEN
        res:=seekErr;
      ELSE
        bufLen:=0;
        bufPos:=0;
        pos:=Pos;
      END;
    END;
  END;
END SetPos;

PROCEDURE Close(VAR file:File);
VAR f,prev:FileListPtr;
BEGIN
  f:=inUsedFiles; prev:=NIL;
  file.res:=notdone;
  WHILE f#NIL DO
    IF f^.fsFile.handle=file.handle THEN
      (* match*)
      IF prev=NIL THEN
        inUsedFiles:=f^.next;
      ELSE
       prev^.next:=f^.next;
      END;
      IF write IN file.mode THEN
        IF FlushBuf(file) THEN END;
      END;
      dl.Close(file.handle);
      el.FreeMem(f,SIZE(FileList));
      ClearFile(file);
      file.res:=done;
      RETURN;
    END;
    prev:=f;
    f:=f^.next;
  END;
END Close;

PROCEDURE Delete(VAR file:File);
VAR f,prev:FileListPtr;
BEGIN
  f:=inUsedFiles; prev:=NIL;
  WHILE f#NIL DO
    IF f^.fsFile.handle=file.handle THEN
      (* match*)
      IF prev=NIL THEN
        inUsedFiles:=f^.next;
      ELSE
       prev^.next:=f^.next;
      END;
      IF write IN file.mode THEN
        IF FlushBuf(file) THEN END;
      END;
      dl.Close(file.handle); file.handle:=NIL;
      IF dl.DeleteFile(ADR(f^.nameString)) THEN 
        file.res:=done 
      ELSE 
        file.res:=deleteErr; 
      END;
      el.FreeMem(f,SIZE(FileList));
      RETURN;
    END;
    prev:=f;
    f:=f^.next;
  END;
END Delete;

PROCEDURE Length(VAR file:File; VAR len:LONGINT);
VAR old:LONGINT;
BEGIN
  WITH file DO
    IF res=done THEN
      IF read IN mode THEN 
        old:=dl.Seek(handle,0,dd.end);
        len:=dl.Seek(handle,old,dd.beginning);
      ELSE (* write *)
        len:=pos;
      END; 
    END;
  END;
END Length;

PROCEDURE CleanFileSystem;
VAR f,prev:FileListPtr;
BEGIN
  f:=inUsedFiles; prev:=NIL;
  WHILE f#NIL DO
    IF write IN f^.fsFile.mode THEN
      IF FlushBuf(f^.fsFile) THEN END;
    END;
    IF f^.fsFile.handle#NIL THEN dl.Close(f^.fsFile.handle); END;
    prev:=f;
    f:=f^.next;
    el.FreeMem(prev,SIZE(FileList));
  END;
  inUsedFiles:=NIL;
END CleanFileSystem;

BEGIN
 inUsedFiles:=NIL;
CLOSE
 CleanFileSystem;
END FileSystem.
