IMPLEMENTATION MODULE Stream;

FROM SYSTEM IMPORT ADR,ADDRESS,BYTE,CAST,SHIFT;
IMPORT DosL,DosD,ExecD,ExecL,io:InOut;

PROCEDURE TStream.Open(name:ARRAY OF CHAR; write:BOOLEAN):BOOLEAN;
(*$ CopyDyn- *)
VAR 
 mode:LONGINT;
BEGIN
 Error:=cantOpen;
 Write:=write;
 IF write THEN mode:=DosD.newFile ELSE mode:=DosD.oldFile; END;
 file:=DosL.Open(ADR(name),mode);
 IF file#NIL THEN
  io.WriteString('FileOpen\n');
  pos:=0;
  bufpos:=0;
  buflen:=0;
  eof:=FALSE;
  buffer:=ExecL.AllocMem(BufSize,ExecD.MemReqSet{ExecD.public});
  Error:=ok;
 END;
 RETURN file#NIL; 
END TStream.Open;

PROCEDURE TStream.ReadBytes(adr:ADDRESS; len:LONGINT);
VAR 
  CharPtr{10}:POINTER TO CHAR;
  i{7},bp{6},l{5}:LONGINT;
BEGIN
 IF (adr#NIL) & ~Write THEN
   CharPtr:=adr; i:=0;
   bp:=bufpos;
   l:=buflen;
   WHILE i<=len DO
    IF bp=l THEN 
      bp:=0; bufpos:=0;
      l:=DosL.Read(file,buffer,BufSize);
      IF l<0 THEN Error:=readErr; buflen:=l; RETURN; END;
      IF l=0 THEN eof:=TRUE; buflen:=l; RETURN; END;
    END;
    CharPtr^:=buffer^[bp]; INC(CharPtr); INC(bp); INC(i);
   END;
   buflen:=l;
   bufpos:=bp;
   INC(pos,len);
   Error:=ok;
 END; 
END TStream.ReadBytes;

PROCEDURE TStream.WriteBytes(adr:ADDRESS; len:LONGINT);
VAR 
  CharPtr{10}:POINTER TO CHAR;
  i{7},bp{6}:LONGINT;
BEGIN
 IF (adr#NIL) & Write THEN
  io.WriteString('WriteBytes ');
  CharPtr:=adr;
  i:=0;
  bp:=bufpos;
  WHILE i<=len DO
    IF bp=BufSize THEN
      bufpos:=0; bp:=0;
      IF DosL.Write(file,buffer,BufSize)#BufSize THEN Error:=writeErr; RETURN; END;
    END;
    io.WriteString('.');
    buffer^[bp]:=CharPtr^; 
    INC(CharPtr); INC(bp); INC(i);
  END;
  bufpos:=bp;
  INC(pos,len);
  Error:=ok;
  io.WriteString(' End\n');
 END; 
END TStream.WriteBytes;

PROCEDURE TStream.Close;
BEGIN
 Error:=ok;
 IF file#NIL THEN
  io.WriteString('Closing\n');
  IF Write THEN 
   io.WriteString('WriteBuffer\n');
   IF ((bufpos-1)#DosL.Write(file,buffer,bufpos-1)) THEN
    Error:=writeErr;
   END;
  END;
  DosL.Close(file);
  IF buffer#NIL THEN
    io.WriteString('Free Memory\n');
    ExecL.FreeMem(buffer,BufSize);
  END;
  file:=NIL;
  io.WriteString('Done!\n');
 END;
END TStream.Close;


PROCEDURE TReader.Init(s:TStream);
BEGIN
 FStream:=s;
END TReader.Init;

PROCEDURE TReader.ReadBoolean(VAR b:BOOLEAN);
BEGIN
 FStream^.ReadBytes(ADR(b),1);
END TReader.ReadBoolean;

PROCEDURE TReader.ReadInt(VAR i:LONGINT);
VAR n:LONGINT; s:INTEGER; x:CHAR;
BEGIN
 s:=0; n:=0; FStream^.ReadBytes(ADR(x),1);
 WHILE (ORD(x)>=128) DO
  INC(n, SHIFT(ORD(x)-128,s)); INC(s,7); FStream^.ReadBytes(ADR(x),1);
 END;
 i:=n+LONGINT(SHIFT(ORD(x) MOD 64 - ORD(x) DIV 64 * 64,s));
END TReader.ReadInt;

PROCEDURE TReader.ReadChar(VAR ch:CHAR);
BEGIN
 FStream^.ReadBytes(ADR(ch),1);
END TReader.ReadChar;

PROCEDURE TReader.ReadBlock(VAR blk:ARRAY OF BYTE);
BEGIN
 FStream^.ReadBytes(ADR(blk),HIGH(blk)+1);
END TReader.ReadBlock;


(* TWriter *)

PROCEDURE TWriter.Init(s:TStream);
BEGIN
 FStream:=s;
END TWriter.Init;

PROCEDURE TWriter.WriteBoolean(b:BOOLEAN);
BEGIN
 FStream^.WriteBytes(ADR(b),1);
END TWriter.WriteBoolean;

PROCEDURE TWriter.WriteInt(i:LONGINT);
VAR x:SHORTCARD;
BEGIN
  WHILE (i < -64) OR (i > 63) DO
    x:=i MOD 128 + 128;
    FStream^.WriteBytes(ADR(x),1); i := i DIV 128;
  END;
  x:=i MOD 128;
  FStream^.WriteBytes(ADR(x),1);
END TWriter.WriteInt;


PROCEDURE TWriter.WriteChar(ch:CHAR);
BEGIN
 FStream^.WriteBytes(ADR(ch),1);
END TWriter.WriteChar;

PROCEDURE TWriter.WriteBlock(blk:ARRAY OF BYTE);
BEGIN
 FStream^.WriteBytes(ADR(blk),HIGH(blk)+1);
END TWriter.WriteBlock;

BEGIN
END Stream.
