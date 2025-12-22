MODULE  AsyncIOSupport2;

(* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)

(* /// ------------------------------- "IMPORT" -------------------------------- *)
IMPORT  aio:=AsyncIO,
        d:=Dos,
        e:=Exec,
        i2m:=Intel2Mot,
        u:=Utility,
        y:=SYSTEM;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------------- "TYPE" --------------------------------- *)
TYPE    ASFilePtr * =UNTRACED POINTER TO ASFile;
        ASFile * =STRUCT
            handle: aio.AsyncFilePtr;
            readOk - : BOOLEAN;
            noOdd: BOOLEAN;
        END;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------- "PROCEDURE Open()" --------------------------- *)
PROCEDURE Open * (VAR file: ASFile;
                  name: ARRAY OF CHAR;
                  buffers: LONGINT;
                  noOdd: BOOLEAN): BOOLEAN; (* $CopyArrays- *)
BEGIN
  IF file.handle#NIL THEN y.SETREG(0,aio.CloseAsync(file.handle)); END;
  file.handle:=aio.OpenAsync(name,aio.read,buffers);
  file.readOk:=(file.handle#NIL);
  file.noOdd:=noOdd;
  RETURN file.readOk;
END Open;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------- "PROCEDURE Close()" -------------------------- *)
PROCEDURE Close * (VAR file: ASFile);
BEGIN
  IF file.handle#NIL THEN
    y.SETREG(0,aio.CloseAsync(file.handle));
    file.handle:=NIL;
  END;
END Close;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------- "PROCEDURE Read()" --------------------------- *)
PROCEDURE Read * (VAR file: ASFile;
                  buffer: e.APTR;
                  size: LONGINT);
BEGIN
  IF file.noOdd & ODD(size) THEN INC(size); END;
  file.readOk:=(aio.ReadAsyncAPTR(file.handle,buffer,size)=size) & file.readOk;
END Read;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------- "PROCEDURE Skip()" --------------------------- *)
PROCEDURE Skip * (VAR file: ASFile;
                  bytes: LONGINT);
BEGIN
  IF file.noOdd & ODD(bytes) THEN INC(bytes); END;
  file.readOk:=(aio.SeekAsync(file.handle,bytes,aio.current)#-1) & file.readOk;
END Skip;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------- "PROCEDURE SeekTo()" -------------------------- *)
PROCEDURE SeekTo * (VAR file: ASFile;
                    pos: LONGINT);
BEGIN
  file.readOk:=(aio.SeekAsync(file.handle,pos,aio.start)#-1) & file.readOk;
END SeekTo;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------- "PROCEDURE FilePos()" ------------------------- *)
PROCEDURE FilePos * (VAR file: ASFile): LONGINT;

VAR     pos: LONGINT;

BEGIN
  pos:=aio.SeekAsync(file.handle,0,aio.current);
  file.readOk:=(pos#-1) & file.readOk;
  RETURN pos;
END FilePos;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE FileSize()" ------------------------- *)
PROCEDURE FileSize * (VAR file: ASFile): LONGINT;

VAR     fib: d.FileInfoBlockPtr;
        size: LONGINT;

BEGIN
  fib:=d.AllocDosObjectTags(d.fib,u.done);
  IF fib#NIL THEN
    file.readOk:=d.ExamineFH(file.handle.file,fib^) & file.readOk;
    size:=fib.size;
    d.FreeDosObject(d.fib,fib);
  ELSE
    size:=0;
  END;
  RETURN size;
END FileSize;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE GetMSBLong()" ------------------------ *)
PROCEDURE GetMSBLong * (VAR file: ASFile): LONGINT;

VAR     data: LONGINT;
        ret: LONGINT;

BEGIN
  ret:=0;
  IF aio.ReadAsync(file.handle,data,SIZE(data))=SIZE(data) THEN
    ret:=data;
    file.readOk:=TRUE;
  ELSE
    file.readOk:=FALSE;
  END;
  RETURN ret;
END GetMSBLong;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE GetMSBShort()" ----------------------- *)
PROCEDURE GetMSBShort * (VAR file: ASFile): INTEGER;

VAR     data: INTEGER;
        ret: INTEGER;

BEGIN
  ret:=0;
  IF aio.ReadAsync(file.handle,data,SIZE(data))=SIZE(data) THEN
    ret:=data;
    file.readOk:=TRUE;
  ELSE
    file.readOk:=FALSE;
  END;
  RETURN ret;
END GetMSBShort;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE GetLSBLong()" ------------------------ *)
PROCEDURE GetLSBLong * (VAR file: ASFile): LONGINT;

VAR     data: LONGINT;

BEGIN
  IF aio.ReadAsync(file.handle,data,SIZE(data))=SIZE(data) THEN
    file.readOk:=TRUE;
    RETURN i2m.LSB2MSBLong(data);
  ELSE
    file.readOk:=FALSE;
    RETURN 0;
  END;
END GetLSBLong;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE GetLSBSet()" ------------------------ *)
PROCEDURE GetLSBLSet * (VAR file: ASFile): LONGSET;

VAR     data: LONGSET;

BEGIN
  IF aio.ReadAsync(file.handle,data,SIZE(data))=SIZE(data) THEN
    file.readOk:=TRUE;
    RETURN i2m.LSB2MSBLSet(data);
  ELSE
    file.readOk:=FALSE;
    RETURN LONGSET{};
  END;
END GetLSBLSet;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE GetLSBShort()" ----------------------- *)
PROCEDURE GetLSBShort * (VAR file: ASFile): INTEGER;

VAR     data: INTEGER;

BEGIN
  IF aio.ReadAsync(file.handle,data,SIZE(data))=SIZE(data) THEN
    file.readOk:=TRUE;
    RETURN i2m.LSB2MSBShort(data);
  ELSE
    file.readOk:=FALSE;
    RETURN 0;
  END;
END GetLSBShort;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE UndoError()" ------------------------ *)
PROCEDURE UndoError * (VAR file: ASFile);
BEGIN
  file.readOk:=TRUE;
END UndoError;
(* \\\ ------------------------------------------------------------------------- *)

END AsyncIOSupport2.
