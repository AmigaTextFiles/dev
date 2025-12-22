MODULE  CyberAVIUtils;

(* $IFNOT DEBUG *)
  (* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)
(* $END *)

(* /// ------------------------------- "IMPORT" -------------------------------- *)
IMPORT  aio:=AsyncIO,
        d:=Dos,
        e:=Exec,
        lv:=LibraryVer,
        ol:=OberonLib,
        u:=Utility,
        y:=SYSTEM;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------------- "TYPE" --------------------------------- *)
TYPE    Array4=ARRAY 4 OF SHORTINT;
        Array2=ARRAY 2 OF SHORTINT;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE PrintFCC()" ------------------------- *)
PROCEDURE PrintFCC * (fcc: LONGINT);

TYPE    arr=ARRAY 4 OF CHAR;

VAR     data: arr;
        null: LONGINT;

BEGIN
  null:=0;
  data:=y.VAL(arr,fcc);
  d.PrintF("%s ($%08lx)",y.ADR(data),fcc);
END PrintFCC;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE PrintChunkHead()" ---------------------- *)
PROCEDURE PrintChunkHead * (id,size: LONGINT);
BEGIN
  d.PrintF("id: ");
  PrintFCC(id);
  d.PrintF(" size: $%08lx (%10ld)",size,size);
END PrintChunkHead;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------------- "PROCEDURE oom()" --------------------------- *)
PROCEDURE oom();

VAR     errStr: e.STRING;
        prg: e.STRING;

BEGIN
  y.SETREG(0,d.GetProgramName(prg,SIZE(prg)));
  y.SETREG(0,d.Fault(d.noFreeStore,prg,errStr,SIZE(errStr)));
  d.PrintF("%s\n",y.ADR(errStr));
  HALT(5);
END oom;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------- "PROCEDURE AddPtr()" -------------------------- *)
PROCEDURE AddPtr * (VAR ptr: e.APTR;
                    add: LONGINT);
BEGIN
  ptr:=y.VAL(e.APTR,y.VAL(LONGINT,ptr)+add);
END AddPtr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE CheckVersions()" ---------------------- *)
PROCEDURE CheckVersions * (dummy: ARRAY OF CHAR); (* $CopyArrays- *)
BEGIN
  IF ~lv.CheckVersion(y.ADR(e.SysBase.libNode),39,0) THEN
    d.PrintF("CyberAVI needs at least AmigaOS 3.0 (V39)\n");
    HALT(0);
  END;
  IF ~(e.m68020 IN e.SysBase.attnFlags) THEN
    d.PrintF("CyberAVI needs at least MC68020\n");
    HALT(0);
  END;
  IF ~lv.CheckVersion(aio.base,39,0) THEN
    d.PrintF("CyberAVI needs asyncio.library V39+\n");
    HALT(0);
  END;
END CheckVersions;
(* \\\ ------------------------------------------------------------------------- *)

BEGIN
  ol.OutOfMemHandler:=oom;
END CyberAVIUtils.
