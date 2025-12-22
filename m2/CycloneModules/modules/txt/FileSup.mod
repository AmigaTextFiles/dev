IMPLEMENTATION MODULE FileSup;

(* (C) Copyright 1995 Marcel Timmermans. All rights reserved. *)

FROM SYSTEM IMPORT ADR,ADDRESS;
IMPORT DosL,DosD,ExecL,ExecD;

PROCEDURE GetFileDate(Name:ARRAY OF CHAR; VAR date:DosD.Date):BOOLEAN;
(*$ CopyDyn- *)
CONST 
  fbs=SIZE(DosD.FileInfoBlock);
VAR 
  FLock:DosD.FileLockPtr;
  Fib  :DosD.FileInfoBlockPtr;
  Len  :LONGINT;
  ok:BOOLEAN;
BEGIN
 ok:=FALSE;
 Fib:=ExecL.AllocMem(fbs,ExecD.MemReqSet{ExecD.public});
 IF Fib#NIL THEN
  FLock:=DosL.Lock(ADR(Name), NIL);
  IF FLock#NIL THEN
   IF DosL.Examine(FLock,Fib)=TRUE THEN
    date:=Fib^.date;  
    ok:=TRUE;
   END;
   DosL.UnLock(FLock);
  END;
  ExecL.FreeMem(Fib,fbs);
 END;
 RETURN ok;
END GetFileDate;

PROCEDURE FileExists(Name:ADDRESS):BOOLEAN;
VAR 
  FLock:DosD.FileLockPtr;
BEGIN
  FLock:=DosL.Lock( Name, NIL);
  IF FLock#NIL THEN DosL.UnLock(FLock); END;
  RETURN FLock=NIL;
END FileExists;


PROCEDURE GetFileLen(Name:ARRAY OF CHAR):LONGINT;
CONST 
  fbs=SIZE(DosD.FileInfoBlock);
VAR FLock:DosD.FileLockPtr;
    Fib  :DosD.FileInfoBlockPtr;
    Len  :LONGINT;
BEGIN
 Len:=-1;
 Fib:=ExecL.AllocMem(fbs,ExecD.MemReqSet{ExecD.public});
 IF Fib#NIL THEN
  FLock:=DosL.Lock(ADR(Name),NIL);
  IF FLock#NIL THEN
   IF DosL.Examine(FLock,Fib)=TRUE THEN
    Len:=Fib^.size;
   END;
   DosL.UnLock(FLock);
  END;
  ExecL.FreeMem(Fib,fbs);
 END;
 RETURN Len;
END GetFileLen;


END FileSup.mod
