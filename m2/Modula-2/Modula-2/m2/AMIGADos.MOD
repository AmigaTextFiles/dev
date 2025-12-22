(********************************************************************************

Name         : AMIGADos.MOD
Version      : 1.0
Purpose      : Interface to AMIGADos
Authors      : cn/jr/ms/red
Modified     : 12.3.86  20:25  cn
State        : should be ok
Requirements : 

********************************************************************************)

IMPLEMENTATION MODULE AMIGADos;

FROM SYSTEM     IMPORT ADDRESS, ADR;
FROM AMIGABase  IMPORT Regs, ExecBase, ExecOpenLib, LibCall;

CONST 
  (* File Handling  *)
     close              =  -36;
     createDir          = -120;
     currentDir         = -126;
     deleteFile         =  -72;
     dupLock            =  -96;
     examine            = -102;
     exNext             = -108;
     info               = -114;
     input              =  -54;
     ioErr              = -132;
     isInteractive      = -216;
     lock               =  -84;
     open               =  -30;
     output             =  -60;
     parentDir          = -210;
     read               =  -42;
     rename             =  -78;
     seek               =  -66;
     setComment         = -180;
     setProtection      = -186;
     unLock             =  -90;
     waitForChar        = -204;
     write              =  -48;

  (* Process Handling *)
     createProc         = -138;
     dateStamp          = -192;
     delay              = -198;
     deviceProc         = -174;
     exit               = -144;

  (* Loading Code *)
     execute            = -222;
     loadSeg            = -150;
     unLoadSeg          = -156;

TYPE String0C           = ARRAY [0..127] OF CHAR;
     AMIGALockPtr       = ADDRESS;
     AMIGAFile          = ADDRESS;

VAR  DosLib: ADDRESS;
     reg: Regs;
     AMIGAString: String0C;
      
PROCEDURE MakeAMIGAString(s: ARRAY OF CHAR);
  VAR i: CARDINAL;
BEGIN
  i:=0;
  WHILE (i<=HIGH(s)) AND (s[i]#0C) DO
    AMIGAString[i]:=s[i];
    INC(i)
  END;
  AMIGAString[i]:=0C
END MakeAMIGAString;

PROCEDURE Close(f: AMIGAFile);
BEGIN
  reg.d[1]:=LONGINT(f);
  LibCall(DosLib, close, reg);
END Close;

PROCEDURE CreateDir(name: ARRAY OF CHAR): AMIGALockPtr;
BEGIN
  MakeAMIGAString(name);
  reg.d[1]:=LONGINT(ADR(AMIGAString));
  LibCall(DosLib, createDir, reg);
  RETURN AMIGALockPtr(reg.d[0])
END CreateDir;

PROCEDURE CurrentDir(lockPtr: AMIGALockPtr): AMIGALockPtr;
BEGIN
  reg.d[1]:=LONGINT(lockPtr);
  LibCall(DosLib, currentDir, reg);
  RETURN AMIGALockPtr(reg.d[0])
END CurrentDir;

PROCEDURE DeleteFile(name: ARRAY OF CHAR; VAR done: BOOLEAN);
BEGIN
  MakeAMIGAString(name);
  reg.d[1]:=LONGINT(ADR(AMIGAString));
  LibCall(DosLib, deleteFile, reg);
  done:=reg.d[0]#0D
END DeleteFile;

PROCEDURE DupLock(lockPtr: AMIGALockPtr): AMIGALockPtr;
BEGIN
  reg.d[1]:=LONGINT(lockPtr);
  LibCall(DosLib, dupLock, reg);
  RETURN AMIGALockPtr(reg.d[0])
END DupLock;

PROCEDURE Examine(lockPtr: AMIGALockPtr;
                  VAR fileInfo: AMIGAFileInfoBlock; VAR done: BOOLEAN);
BEGIN
  reg.d[1]:=LONGINT(lockPtr);
  reg.d[2]:=LONGINT(ADR(fileInfo));
  LibCall(DosLib, examine, reg);
  done:=reg.d[0]#0D
END Examine;

PROCEDURE ExNext(lockPtr: AMIGALockPtr;
                  VAR fileInfo: AMIGAFileInfoBlock; VAR done: BOOLEAN);
BEGIN
  reg.d[1]:=LONGINT(lockPtr);
  reg.d[2]:=LONGINT(ADR(fileInfo));
  LibCall(DosLib, exNext, reg);
  done:=reg.d[0]#0D
END ExNext;

PROCEDURE Info(lockPtr: AMIGALockPtr;
               VAR infoData: AMIGAInfoData; VAR done: BOOLEAN);
BEGIN
  reg.d[1]:=LONGINT(lockPtr);
  reg.d[2]:=LONGINT(ADR(infoData));
  LibCall(DosLib, info, reg);
  done:=reg.d[0]#0D
END Info;
  
PROCEDURE Input(): AMIGAFile;
BEGIN
  LibCall(DosLib, input, reg);
  RETURN AMIGAFile(reg.d[0])
END Input;

PROCEDURE IoErr(): LONGINT;
BEGIN
  LibCall(DosLib, ioErr, reg);
  RETURN reg.d[0];
END IoErr;

PROCEDURE IsInteractive(f: AMIGAFile): BOOLEAN;
BEGIN
  reg.d[1]:=LONGINT(f);
  LibCall(DosLib, isInteractive, reg);
  RETURN reg.d[0]#0D
END IsInteractive;

PROCEDURE Lock(name: ARRAY OF CHAR;
               accessWrite: BOOLEAN): AMIGALockPtr;
BEGIN
  MakeAMIGAString(name);
  reg.d[1]:=LONGINT(ADR(AMIGAString));
  IF accessWrite THEN
    reg.d[2]:=-2
  ELSE
    reg.d[2]:=-1
  END;
  LibCall(DosLib, lock, reg);
  RETURN AMIGALockPtr(reg.d[0])
END Lock;

PROCEDURE Open(name: ARRAY OF CHAR; newFile: BOOLEAN): AMIGAFile;
BEGIN
  MakeAMIGAString(name);
  reg.d[1]:=LONGINT(ADR(AMIGAString));
  IF newFile THEN
    reg.d[2]:=1006
  ELSE
    reg.d[2]:=1005
  END;
  LibCall(DosLib, open, reg);
  RETURN AMIGAFile(reg.d[0])
END Open;

PROCEDURE Output(): AMIGAFile;
BEGIN
  LibCall(DosLib, output, reg);
  RETURN AMIGAFile(reg.d[0])
END Output;

PROCEDURE ParentDir(lockPtr: AMIGALockPtr): AMIGALockPtr;
BEGIN
  reg.d[1]:=LONGINT(lockPtr);
  LibCall(DosLib, parentDir, reg);
  RETURN AMIGALockPtr(reg.d[0])
END ParentDir;

PROCEDURE Read(f: AMIGAFile; buffer: ADDRESS; length: LONGINT): LONGINT;
BEGIN
  reg.d[1]:=LONGINT(f);
  reg.d[2]:=LONGINT(buffer);
  reg.d[3]:=length;
  LibCall(DosLib, read, reg);
  RETURN reg.d[0]
END Read;
  
PROCEDURE Rename(oldname, newname: ARRAY OF CHAR; VAR done: BOOLEAN);
VAR new:String0C;
BEGIN
  MakeAMIGAString(newname);
  new:=AMIGAString;
  MakeAMIGAString(oldname);
  reg.d[1]:=LONGINT(ADR(AMIGAString));
  reg.d[2]:=LONGINT(ADR(new));
  LibCall(DosLib, rename, reg);
  done:=reg.d[0]#0D
END Rename;

PROCEDURE Seek(f: AMIGAFile; pos: LONGINT; seekMode: AMIGASeekMode): LONGINT;
BEGIN
  reg.d[1]:=LONGINT(f);
  reg.d[2]:=pos;
  CASE seekMode OF
  | ofsBeginning: reg.d[3]:=-1D;
  | ofsCurrent:   reg.d[3]:= 0D;
  | ofsEnd:       reg.d[3]:= 1D;
  END;
  LibCall(DosLib, seek, reg);
  RETURN reg.d[0];
END Seek;

PROCEDURE SetComment(name, comment: ARRAY OF CHAR; VAR done: BOOLEAN);
VAR comm:String0C;
BEGIN
  MakeAMIGAString(comment);
  comm:=AMIGAString;
  MakeAMIGAString(name);
  reg.d[1]:=LONGINT(ADR(AMIGAString));
  reg.d[2]:=LONGINT(ADR(comm));
  LibCall(DosLib, setComment, reg);
  done:=reg.d[0]#0D
END SetComment;

PROCEDURE SetProtection(name: ARRAY OF CHAR;
                        mask: AMIGAFileProtectSET; VAR done: BOOLEAN);
BEGIN
  MakeAMIGAString(name);
  reg.d[1]:=LONGINT(ADR(AMIGAString));
  reg.d[2]:=LONGINT(mask);
  LibCall(DosLib, setProtection, reg);
  done:=reg.d[0]#0D
END SetProtection;

PROCEDURE UnLock(lockPtr: AMIGALockPtr);
BEGIN
  reg.d[1]:=LONGINT(lockPtr);
  LibCall(DosLib, unLock, reg);
END UnLock;

PROCEDURE WaitForChar(f: AMIGAFile; timeout: LONGINT): BOOLEAN;
BEGIN
  reg.d[1]:=LONGINT(f);
  reg.d[2]:=timeout;
  LibCall(DosLib, waitForChar, reg);
  RETURN reg.d[0]#0D
END WaitForChar;

PROCEDURE Write(f: AMIGAFile; buffer: ADDRESS; length: LONGINT): LONGINT;
BEGIN
  reg.d[1]:=LONGINT(f);
  reg.d[2]:=LONGINT(buffer);
  reg.d[3]:=length;
  LibCall(DosLib, write, reg);
  RETURN reg.d[0]
END Write;


TYPE AMIGAProcessPtr = ADDRESS;
     AMIGASegmentPtr = ADDRESS;


PROCEDURE CreateProc(name: ARRAY OF CHAR; priorty: LONGINT;
                     segment: AMIGASegmentPtr;
                     stackSize: LONGINT): AMIGAProcessPtr;
BEGIN
  MakeAMIGAString(name);
  reg.d[1]:=LONGINT(ADR(AMIGAString));
  reg.d[2]:=priorty;
  reg.d[3]:=LONGINT(segment);
  reg.d[4]:=stackSize;
  LibCall(DosLib, createProc, reg);
  RETURN AMIGAProcessPtr(reg.d[0])
END CreateProc;

PROCEDURE DateStamp(VAR v: AMIGADateStamp);
BEGIN
  reg.d[1]:=LONGINT(ADR(v));
  LibCall(DosLib, dateStamp, reg);
END DateStamp;

PROCEDURE Delay(timeout: LONGINT);
BEGIN
  reg.d[1]:=timeout;
  LibCall(DosLib, delay, reg);
END Delay;

PROCEDURE DeviceProc(name: ARRAY OF CHAR): AMIGAProcessPtr;
BEGIN
  MakeAMIGAString(name);
  reg.d[1]:=LONGINT(ADR(AMIGAString));
  LibCall(DosLib, deviceProc, reg);
  RETURN AMIGAProcessPtr(reg.d[0])
END DeviceProc;

PROCEDURE Exit(returnCode: LONGINT);
BEGIN
  reg.d[1]:=returnCode;
  LibCall(DosLib, exit, reg)
END Exit;

PROCEDURE Execute(command: ARRAY OF CHAR;
                  VAR input, output: AMIGAFile; VAR done: BOOLEAN);
BEGIN
  MakeAMIGAString(command);
  reg.d[1]:=LONGINT(ADR(AMIGAString));
  reg.d[2]:=LONGINT(input);
  reg.d[3]:=LONGINT(output);
  LibCall(DosLib, execute, reg);
  done:=reg.d[0]#0D
END Execute;

PROCEDURE LoadSeg(name: ARRAY OF CHAR): AMIGASegmentPtr;
BEGIN
  MakeAMIGAString(name);
  reg.d[1]:=LONGINT(ADR(AMIGAString));
  LibCall(DosLib, loadSeg, reg);
  RETURN AMIGASegmentPtr(reg.d[0])
END LoadSeg;

PROCEDURE UnLoadSeg(segment: AMIGASegmentPtr);
BEGIN
  reg.d[1]:=LONGINT(segment);
  LibCall(DosLib, unLoadSeg, reg);
END UnLoadSeg;

VAR
  st: ARRAY [0..15] OF CHAR;
  p: POINTER TO ADDRESS;
  r: Regs;

BEGIN
  st:='dos.library';
  r.a[1]:=ADR(st);
  r.d[0]:=0;                           (* Version 0 ! *)
  LibCall(ExecBase(), ExecOpenLib(), r);   
  DosLib:=r.d[0];
END AMIGADos.
