MODULE  ASLSupport;

(* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)

(* /// ------------------------------- "IMPORT" -------------------------------- *)
IMPORT  asl:=ASL,
        d:=Dos,
        e:=Exec,
        ol:=OberonLib,
        y:=SYSTEM;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------------- "TYPE" --------------------------------- *)
TYPE    DoProc * =PROCEDURE (ap: d.AnchorPathPtr;
                             multi: BOOLEAN): LONGINT;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DoAllFiles()" ------------------------ *)
PROCEDURE DoAllFiles * (req: asl.FileRequesterPtr;
                        doProc: DoProc): BOOLEAN;

VAR     cnt: LONGINT;
        retVal: LONGINT;
        anchor: d.AnchorPathPtr;
        oldCD: d.FileLockPtr;
        doProcResult: LONGINT;
        multi: BOOLEAN;
        prgName: e.STRING;

BEGIN
  y.SETREG(0,d.GetProgramName(prgName,SIZE(prgName)));
  anchor:=e.AllocVec(SIZE(anchor^)+SIZE(e.STRING),e.any+LONGSET{e.memClear});
  IF anchor=NIL THEN
    retVal:=d.noFreeStore;
  ELSE
    anchor.breakBits:=LONGSET{d.ctrlC};
    anchor.foundBreak:=LONGSET{};
    anchor.flags:=SHORTSET{d.doWild};
    anchor.strLen:=SIZE(e.STRING);
    cnt:=0;
    doProcResult:=0;
    multi:=(req.numArgs>1);
    REPEAT
      oldCD:=d.CurrentDir(req.argList[cnt].lock);
      retVal:=d.MatchFirst(req.argList[cnt].name^,anchor^);
      IF retVal=0 THEN doProcResult:=doProc(anchor,multi); END;
      IF doProcResult#0 THEN y.SETREG(0,d.PrintFault(doProcResult,anchor.info.fileName)); END;
      d.MatchEnd(anchor^);
      y.SETREG(0,d.CurrentDir(oldCD));
      INC(cnt);
    UNTIL (cnt=req.numArgs) OR (doProcResult#0);
    e.FreeVec(anchor);
  END;
  IF (retVal#0) & (retVal#d.noMoreEntries) THEN
    y.SETREG(0,d.PrintFault(retVal,prgName));
  END;
  RETURN (doProcResult=0) & (retVal=d.noMoreEntries);
END DoAllFiles;
(* \\\ ------------------------------------------------------------------------- *)

END ASLSupport.

