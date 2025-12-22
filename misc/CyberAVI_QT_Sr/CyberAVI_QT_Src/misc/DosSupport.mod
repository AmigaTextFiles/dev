MODULE  DosSupport;

(* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)

(* /// ------------------------------- "IMPORT" -------------------------------- *)
IMPORT  d:=Dos,
        e:=Exec,
        ol:=OberonLib,
        y:=SYSTEM;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------------- "TYPE" --------------------------------- *)
TYPE    DoProc * =PROCEDURE (ap: d.AnchorPathPtr;
                             multi: BOOLEAN): LONGINT;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DoAllFiles()" ------------------------ *)
PROCEDURE DoAllFiles * (files: d.ArgStringArray;
                        doAll: BOOLEAN;
                        doProc: DoProc): BOOLEAN;

VAR     cnt: LONGINT;
        retVal: LONGINT;
        anchor: d.AnchorPathPtr;
        oldCD: d.FileLockPtr;
        doProcResult: LONGINT;
        multi: BOOLEAN;
        prgName: e.STRING;

(* /// -------------------------- "PROCEDURE IsDir()" -------------------------- *)
  PROCEDURE IsDir(): BOOLEAN;
  BEGIN
    RETURN (anchor.info.dirEntryType>=d.root) & (anchor.info.dirEntryType#d.softLink);
  END IsDir;
(* \\\ ------------------------------------------------------------------------- *)

BEGIN
  y.SETREG(0,d.GetProgramName(prgName,SIZE(prgName)));
  cnt:=0;
  WHILE files[cnt]#NIL DO INC(cnt); END;
  multi:=(cnt>1);
  anchor:=e.AllocVec(SIZE(anchor^)+SIZE(e.STRING),e.any+LONGSET{e.memClear});
  IF anchor=NIL THEN
    retVal:=d.noFreeStore;
  ELSE
    anchor.breakBits:=LONGSET{d.ctrlC};
    anchor.foundBreak:=LONGSET{};
    anchor.flags:=SHORTSET{};
    anchor.strLen:=SIZE(e.STRING);
    cnt:=0;
    doProcResult:=0;
    REPEAT
      retVal:=d.MatchFirst(files[cnt]^,anchor^);
      WHILE (retVal=0) & (doProcResult#d.break) DO
        IF IsDir() THEN
          IF ~(d.didDir IN anchor.flags) & doAll THEN INCL(anchor.flags,d.doDir); END;
          EXCL(anchor.flags,d.didDir);
        ELSE
          oldCD:=d.CurrentDir(anchor.last.lock);
          doProcResult:=doProc(anchor,multi OR (d.itsWild IN anchor.flags));
          y.SETREG(0,d.CurrentDir(oldCD));
        END;
        IF doProcResult#d.break THEN
          IF doProcResult#0 THEN y.SETREG(0,d.PrintFault(doProcResult,anchor.info.fileName)); END;
          retVal:=d.MatchNext(anchor^);
        ELSE
          y.SETREG(0,d.PrintFault(doProcResult,anchor.info.fileName));
        END;
      END;
      d.MatchEnd(anchor^);
      INC(cnt);
    UNTIL (files[cnt]=NIL) OR (doProcResult=d.break) OR (retVal=d.noMoreEntries);
    e.FreeVec(anchor);
  END;
  IF (retVal#0) & (retVal#d.noMoreEntries) THEN
    y.SETREG(0,d.PrintFault(retVal,prgName));
  END;
  RETURN (doProcResult=0) & (retVal=d.noMoreEntries);
END DoAllFiles;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------- "PROCEDURE Fail()" --------------------------- *)
PROCEDURE Fail * (err: LONGINT;
                  haltErr: LONGINT);
BEGIN
  IF err#0 THEN
    IF err=-1 THEN err:=d.IoErr(); END;
    y.SETREG(0,d.PrintFault(err,NIL));
  END;
  ol.Result:=haltErr;
  ol.HaltProc();
END Fail;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------- "PROCEDURE B2CStr()" -------------------------- *)
PROCEDURE B2CStr * (bstr: ARRAY OF CHAR;
                    VAR cstr: ARRAY OF CHAR); (* $CopyArrays- *)

VAR     x: INTEGER;

BEGIN
  FOR x:=0 TO ORD(bstr[0])-1 DO
    cstr[x]:=bstr[x+1];
  END;
  cstr[x]:=00X;
END B2CStr;
(* \\\ ------------------------------------------------------------------------- *)

END DosSupport.
