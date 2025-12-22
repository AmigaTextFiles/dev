IMPLEMENTATION MODULE IntuiSup;

(* (C) Copyright 1994 Marcel Timmermans. All rights reserved. *)

FROM SYSTEM IMPORT ASSEMBLE;

FROM GraphicsL IMPORT graphicsBase;

PROCEDURE MenuNum(code{0}:CARDINAL):CARDINAL;
(*$ EntryExitCode- *)
BEGIN
  ASSEMBLE(ANDI.W  #$1F,D0
           RTS
           END);
END MenuNum;


PROCEDURE ItemNum(code{0}:CARDINAL):CARDINAL;
(*$ EntryExitCode- *)
BEGIN
  ASSEMBLE(LSR     #5,D0
           ANDI.W  #$3F,D0
           RTS
           END);
END ItemNum;

PROCEDURE SubNum(code{0}:CARDINAL):CARDINAL;
(*$ EntryExitCode- *)
BEGIN
  ASSEMBLE(MOVEQ   #11,D1
           LSR.W   D1,D0
           RTS
           END);
END SubNum;

PROCEDURE DetectAga():BOOLEAN;
(*$ EntryExitCode- *)
BEGIN
  ASSEMBLE(
     SF      D0
     MOVE.L  graphicsBase(A4),A0           
     CMP.W   #39,20(A0)  (* Lib version *)
     BLT.S   quit
     MOVE.B  236(A0),D1  (* ChipRevBits *)
     BTST    #2,D1
     BEQ.S   quit
     BTST    #3,D1
     BEQ.S   quit
     ST      D0     (* AGA detected!! *)
quit:
     RTS
    END);
END DetectAga;

END IntuiSup.
