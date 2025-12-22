IMPLEMENTATION MODULE FatNoGuru;

(* (C) Copyright 1993 Marcel Timmermans. All rights reserved. *)

(* Extended version of NoGuru, gives more info about bug position,
   position may be some addresses to high, depending on the exception.
   3.12.96., Stefan Tiemann, made FatNoGuru based on NoGuru
*)

FROM SYSTEM    IMPORT ASSEMBLE,ADDRESS,ADR,CAST,REG,LONGSET,SETREG,SHIFT;
FROM ModulaLib IMPORT thisTask,TerminateRequester,wbStarted;
IMPORT R:Reg;
IMPORT DD: DosD;
IMPORT EL: ExecL;
IMPORT ED: ExecD;
IMPORT STR: String;


// --- Find  hunk, offset in our prg only
// Hunk: The hunk of the the exception
// Offset: The offset of the the exception in the Hunk
// RETURN: TRUE if in our program, FALSE if elswhere (ROM etc.)
PROCEDURE FindMySegment(VAR Hunk, Offset: LONGCARD): BOOLEAN;
TYPE
   AdrP= POINTER TO ADDRESS;
VAR
   SegListP: DD.SegmentPtr;
   ASegListP: ADDRESS;   //SLP * 4, usable address
BEGIN
   IF DD.ProcessPtr(thisTask)^.task.node.type = ED.process THEN   //a task has no seglist
      IF wbStarted THEN
         SegListP:= CAST(DD.SegmentPtr, ADDRESS(DD.ProcessPtr(thisTask)^.segList)*4 + 8);
      ELSE
         SegListP:= CAST(DD.SegmentPtr, DD.ProcessPtr(thisTask)^.cli^.module);
      END;

      Hunk:= 0;
      ASegListP:= CAST(ADDRESS, SegListP) * 4;
      WHILE (SegListP # NIL) & ((TrapInfo.pc < ASegListP) OR
                                (TrapInfo.pc > (ASegListP + AdrP(ASegListP - 4)^))) DO
         SegListP:= CAST(DD.SegmentPtr, SegListP^.next);
         INC(Hunk);
         ASegListP:= CAST(ADDRESS, SegListP) * 4;
      END;
      IF SegListP # NIL THEN   //PC is in our prg
         Offset:= LONGCARD(TrapInfo.pc - ASegListP - 4);
      END;
   END;

   RETURN SegListP # NIL;
END FindMySegment;



(*$ CaseTab- *)

PROCEDURE TrapHandler;
VAR
   ErrMsg  : ARRAY[0..50] OF CHAR;
   Hunk, Offset: LONGCARD;
   R,L: INTEGER;
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

 IF FindMySegment(Hunk, Offset) THEN   //Add Hunk+Offset to ErrMsg
   STR.Concat(ErrMsg, ", H/O:");
   L:= STR.Length(ErrMsg);
   FOR R:= L TO (L+3) DO
      ErrMsg[R]:= CHR(SHIFT(Hunk, (R-L-3)*4) MOD 16 + ORD("0"));   //Make 4-digit-HEX-number
      IF ErrMsg[R] > "9" THEN   INC(ErrMsg[R], 7);   END;   //Adjust HEX-letters
   END;

   ErrMsg[L+4]:= "/";
   INC(L, 5);
   FOR R:= L TO (L+7) DO
      ErrMsg[R]:= CHR(SHIFT(Offset, (R-L-7)*4) MOD 16 + ORD("0"));   //Make 8-digit-HEX-number
      IF ErrMsg[R] > "9" THEN   INC(ErrMsg[R], 7);   END;   //Adjust HEX-letters
   END;
   ErrMsg[L+8]:= 0C;
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
     BHI.S    m0x0noaddr
     MOVE.L   4, A6   //Check for 68010+
     BTST.B   #0, ED.ExecBase.attnFlags+1(A6)
     BEQ.S    m000addr
     MOVE.L   6(A7),TrapInfo.pc(A4)
     BRA.S    all

m000addr:
     ADDQ.W   #8,SP
m0x0noaddr:
     ADDQ.W   #4,SP
     MOVE.L   2(A7),TrapInfo.pc(A4)
all:
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

END FatNoGuru.