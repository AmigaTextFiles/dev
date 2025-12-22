IMPLEMENTATION MODULE AmigaLib;

(* (C) Copyright 1996 Marcel Timmermans. All rights reserved. *)

FROM SYSTEM IMPORT ASSEMBLE,ADDRESS;

IMPORT Reg,ud:UtilityD,id:IntuitionD;


PROCEDURE FastRand(seed{Reg.D0}:LONGINT):LONGINT;
(*$ EntryExitCode- *)
BEGIN
 ASSEMBLE(
	ADD.L	D0,D0
	BHI.S	Cont
	EORI.L	#$1D872B41,D0
Cont:
	RTS
 END);
END FastRand;

PROCEDURE RangeRand(maxValue{Reg.D5}:LONGINT):CARDINAL;
BEGIN
 ASSEMBLE(
	MOVEM.L D4-D5,-(A7)
	MOVE.W	D5,D4
	SUBQ.W	#1,D4
	MOVE.L	RangeSeed(A4),D0
L1:
	ADD.L	D0,D0
	BHI.S	L2
	EORI.L	#$1D872B41,D0
L2:
	LSR.W	#1,D4
	BNE.S	L1
	MOVE.L	D0,RangeSeed(A4)
	TST.W	D5
	BNE.S	L3
	SWAP	D0
	BRA.S	L4
L3:
	MULU	D5,D0
L4:
	CLR.W	D0
	SWAP	D0
	MOVEM.L (A7)+,D4-D5
	RTS

 END);
END RangeRand;

(*$ EntryExitCode- *)
PROCEDURE CallHookA(hook{Reg.A0}:ud.HookPtr;object{Reg.A2}:ADDRESS;
                    message{Reg.A1}:ADDRESS):ADDRESS;
BEGIN
 ASSEMBLE(
   MOVE.L ud.Hook.entry(A0),-(A7)
   RTS
 END);
END CallHookA;

PROCEDURE DoMethodA(obj{Reg.A2}:ADDRESS; msg{Reg.A1}:ADDRESS):ADDRESS;
(*$ EntryExitCode- *)
BEGIN
 ASSEMBLE(
        MOVE.L  A2,-(A7)
        MOVE.L  A2,D0
        BEQ.S   L1
        MOVEA.L -4(A2),A0
        PEA     L2(PC)
        MOVE.L  8(A0),-(A7)
        RTS
L1:
        MOVEQ   #0,D0
L2:
        MOVEA.L (A7)+,A2
        RTS
 END);
END DoMethodA;

PROCEDURE DoSuperMethodA(cl{Reg.A0}:id.IClassPtr;obj{Reg.A2}:ADDRESS;
                         msg{Reg.A1}:ADDRESS):ADDRESS;
(*$ EntryExitCode- *)
BEGIN
 ASSEMBLE(
	MOVE.L	A2,-(A7)
	MOVE.L	A2,D0
	BEQ.S	L1
	MOVE.L	A0,D0
	BEQ.S	L1
	MOVE.L    24(A0),A0
        PEA     L2(PC)
        MOVE.L  8(A0),-(A7)
        RTS
L1:
        MOVEQ   #0,D0
L2:
	MOVEA.L (A7)+,A2
	RTS
 END);
END DoSuperMethodA;

PROCEDURE CoerceMethodA(cl{Reg.A0}:id.IClassPtr;obj{Reg.A2}:ADDRESS;
                         msg{Reg.A1}:id.Msg):ADDRESS;
(*$ EntryExitCode- *)
BEGIN
 ASSEMBLE(
	MOVE.L	A2,-(A7)
	MOVE.L	A2,D0
	BEQ.S	L1
	MOVE.L	A0,D0
	BEQ.S	L1
	MOVEA.L 24(A0),A0
        PEA     L2(PC)
        MOVE.L  8(A0),-(A7)
        RTS
L1:
        MOVEQ   #0,D0
L2:
	MOVEA.L (A7)+,A2
	RTS
 END);
END CoerceMethodA;

PROCEDURE SetSuperAttrsA(cl{Reg.A0}:id.IClassPtr;obj{Reg.A2}:ADDRESS;
                        tags{Reg.A1}:ud.Tag):ADDRESS;
(*$ EntryExitCode- *)
BEGIN
 ASSEMBLE(
        MOVE.L	A2,-(A7)
        MOVE.L	A2,D0
        BEQ.S	L1
        MOVE.L	A0,D0
        BEQ.S   L1
        MOVEA.L 24(A0),A0
        MOVE.L	#$00000000,-(A7)
        MOVE.L	A1,-(A7)
        MOVE.L	#$00000103,-(A7)
        MOVEA.L A7,A1
        PEA	L3(PC)
        MOVE.L	8(A0),-(A7)
        RTS
L3:
        LEA	12(A7),A7
        MOVEA.L (A7)+,A2
        RTS

L1:
        MOVEQ   #0,D0
L2:
	MOVEA.L (A7)+,A2
	RTS
 END);
END SetSuperAttrsA;


END AmigaLib.
