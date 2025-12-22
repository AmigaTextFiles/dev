IMPLEMENTATION MODULE NoGuru;

(* (C) Copyright 1993 Marcel Timmermans. All rights reserved. *)

FROM SYSTEM    IMPORT ASSEMBLE,ADDRESS,ADR,CAST,REG,LONGSET,SETREG;
FROM ModulaLib IMPORT thisTask,TerminateRequester;
IMPORT ED: ExecD;

(*$ CaseTab- *)

PROCEDURE TrapHandler;
VAR ErrMsg  : ARRAY[0..25] OF CHAR;
BEGIN
 CASE TrapInfo.TrapNr OF
    02H : ErrMsg:="Bus error";
  | 03H : ErrMsg:="Address error";
  | 04H : ErrMsg:="Illegal instruction";
  | 05H : ErrMsg:="Zero divide";
  | 06H : ErrMsg:="Rangecheck error (CHK)";
  | 07H : ErrMsg:="Overflow error (TPAPV)"
  | 08H : ErrMsg:="Privilege error";
  | 09H : ErrMsg:="Trace";
  | 0AH : ErrMsg:="Line 1010 emulator";
  | 0BH : ErrMsg:="Line 1111 emulator";
  | 20H : ErrMsg:="illegal CASE-index";
  | 21H : ErrMsg:="Pointer is NIL";
  | 22H : ErrMsg:="Overflow";
  | 23H : ErrMsg:="Stack Overflow!";
  | 24H : ErrMsg:="Return Failure!";
  | 25H : ErrMsg:="Range error!";
 ELSE
  ErrMsg:="Trap error nr 00H";
  WITH TrapInfo DO
   INC(ErrMsg[14],SHORTINT(TrapNr DIV 16)); IF ((TrapNr DIV 16)>9) THEN INC(ErrMsg[14],7) END;
   INC(ErrMsg[15],SHORTINT(TrapNr MOD 16)); IF ((TrapNr MOD 16)>9) THEN INC(ErrMsg[15],7) END;
  END;
 END;
  TerminateRequester(ADR(ErrMsg));
END TrapHandler;



PROCEDURE TrapProc;
(*$ EntryExitCode- *)
BEGIN
    ASSEMBLE(
     MOVEM.L  A0-A6,-(A7)
     LEA      TrapInfo.DRegs(A4),A2
     LEA      TrapInfo.ARegs(A4),A3
     MOVEM.L  D0-D7,(A2)
     MOVEM.L  (A7)+,D0-D6
     MOVEM.L  D0-D6,(A3)
     MOVE.L   (A7),TrapInfo.TrapNr(A4)
     LEA      TrapHandler(PC),A0
     CMPI.L   #3,TrapInfo.TrapNr(A4)
     BHI.S    n
     MOVE.L   4, A6   //Check for 68010+
     BTST.B   #0, ED.ExecBase.attnFlags+1(A6)
     BNE.S    m
     ADDQ.W   #8,SP
n:
     ADDQ.W   #4,SP
m:
     MOVE.L   2(A7),TrapInfo.pc(A4)
     MOVE.L   A0,2(A7)
     RTE
    END);
END TrapProc;

BEGIN
 ASSEMBLE(
    MOVEA.L thisTask(A4),A3
    LEA     TrapProc(PC),A0
    MOVE.L  A0,50(A3)
    END);

 (* ModulaStartup Restores always startop TrapProc !!! *)

END NoGuru.