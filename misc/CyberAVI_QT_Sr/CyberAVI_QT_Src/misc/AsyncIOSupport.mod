MODULE  AsyncIOSupport;

(* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)

(* /// ------------------------------- "IMPORT" -------------------------------- *)
IMPORT  aio:=AsyncIO,
        d:=Dos,
        e:=Exec,
        i2m:=Intel2Mot,
        u:=Utility,
        y:=SYSTEM;
(* \\\ ------------------------------------------------------------------------- *)

VAR     fh: aio.AsyncFilePtr;
        readOk - : BOOLEAN;
        noOdd * : BOOLEAN;

(* /// -------------------------- "PROCEDURE Open()" --------------------------- *)
PROCEDURE Open * (name: ARRAY OF CHAR;
                  buffers: LONGINT): BOOLEAN; (* $CopyArrays- *)
BEGIN
  IF fh#NIL THEN y.SETREG(0,aio.CloseAsync(fh)); END;
  fh:=aio.OpenAsync(name,aio.read,buffers);
  readOk:=(fh#NIL);
  RETURN readOk;
END Open;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------- "PROCEDURE Close()" -------------------------- *)
PROCEDURE Close * ();
BEGIN
  IF fh#NIL THEN
    y.SETREG(0,aio.CloseAsync(fh));
    fh:=NIL;
  END;
END Close;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------- "PROCEDURE Read()" --------------------------- *)
PROCEDURE Read * (buffer: e.APTR;
                  size: LONGINT);
BEGIN
  IF noOdd & ODD(size) THEN INC(size); END;
  readOk:=(aio.ReadAsyncAPTR(fh,buffer,size)=size) & readOk;
END Read;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------- "PROCEDURE Skip()" --------------------------- *)
PROCEDURE Skip * (bytes: LONGINT);
BEGIN
  IF noOdd & ODD(bytes) THEN INC(bytes); END;
  readOk:=(aio.SeekAsync(fh,bytes,aio.current)#-1) & readOk;
END Skip;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------- "PROCEDURE SeekTo()" -------------------------- *)
PROCEDURE SeekTo * (pos: LONGINT);
BEGIN
  readOk:=(aio.SeekAsync(fh,pos,aio.start)#-1) & readOk;
END SeekTo;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------- "PROCEDURE FilePos()" ------------------------- *)
PROCEDURE FilePos * (): LONGINT;

VAR     pos: LONGINT;

BEGIN
  pos:=aio.SeekAsync(fh,0,aio.current);
  readOk:=(pos#-1) & readOk;
  RETURN pos;
END FilePos;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE FileSize()" ------------------------- *)
PROCEDURE FileSize * (): LONGINT;

VAR     fib: d.FileInfoBlockPtr;
        size: LONGINT;

BEGIN
  fib:=d.AllocDosObjectTags(d.fib,u.done);
  IF fib#NIL THEN
    readOk:=d.ExamineFH(fh.file,fib^) & readOk;
    size:=fib.size;
    d.FreeDosObject(d.fib,fib);
  ELSE
    size:=0;
  END;
  RETURN size;
END FileSize;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE GetMSBLong()" ------------------------ *)
PROCEDURE GetMSBLong * (): LONGINT;

VAR     data: LONGINT;
        ret: LONGINT;

BEGIN
  ret:=0;
  IF aio.ReadAsync(fh,data,SIZE(data))=SIZE(data) THEN
    ret:=data;
    readOk:=TRUE;
  ELSE
    readOk:=FALSE;
  END;
  RETURN ret;
END GetMSBLong;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE GetMSBShort()" ----------------------- *)
PROCEDURE GetMSBShort * (): INTEGER;

VAR     data: INTEGER;
        ret: INTEGER;

BEGIN
  ret:=0;
  IF aio.ReadAsync(fh,data,SIZE(data))=SIZE(data) THEN
    ret:=data;
    readOk:=TRUE;
  ELSE
    readOk:=FALSE;
  END;
  RETURN ret;
END GetMSBShort;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE GetLSBLong()" ------------------------ *)
PROCEDURE GetLSBLong * (): LONGINT;

VAR     data: LONGINT;

BEGIN
  IF aio.ReadAsync(fh,data,SIZE(data))=SIZE(data) THEN
    readOk:=TRUE;
    RETURN i2m.LSB2MSBLong(data);
  ELSE
    readOk:=FALSE;
    RETURN 0;
  END;
END GetLSBLong;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE GetLSBSet()" ------------------------ *)
PROCEDURE GetLSBLSet * (): LONGSET;

VAR     data: LONGSET;

BEGIN
  IF aio.ReadAsync(fh,data,SIZE(data))=SIZE(data) THEN
    readOk:=TRUE;
    RETURN i2m.LSB2MSBLSet(data);
  ELSE
    readOk:=FALSE;
    RETURN LONGSET{};
  END;
END GetLSBLSet;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE GetLSBShort()" ----------------------- *)
PROCEDURE GetLSBShort * (): INTEGER;

VAR     data: INTEGER;

BEGIN
  IF aio.ReadAsync(fh,data,SIZE(data))=SIZE(data) THEN
    readOk:=TRUE;
    RETURN i2m.LSB2MSBShort(data);
  ELSE
    readOk:=FALSE;
    RETURN 0;
  END;
END GetLSBShort;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE UndoError()" ------------------------ *)
PROCEDURE UndoError * ();
BEGIN
  readOk:=TRUE;
END UndoError;
(* \\\ ------------------------------------------------------------------------- *)

CLOSE
  Close();
END AsyncIOSupport.
