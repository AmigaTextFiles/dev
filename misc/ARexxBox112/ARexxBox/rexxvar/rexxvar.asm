;
; Dies sind die Routinen CheckRexxMsg, GetRexxVar und SetRexxVar.
; (reverse engineered aus der amiga.lib Version 37.32)
;
; Eine Implementation auf herkömmlichem Weg (C) ist nicht möglich, da
; undokumentierte Funktionen der RexxSysLib benutzt werden.
;
; Aufruf Manx: as rexxvar.asm
;

	xdef _CheckRexxMsg
_CheckRexxMsg:
	MOVEA.L 4(A7),A0

	xdef __CheckRexxMsg
__CheckRexxMsg:
	MOVEM.L D2/A2/A6,-(A7)
	MOVEA.L A0,A2
	MOVEA.L 4,A6
	LEA     rxsyslibname,A1
	MOVEQ   #0,D0
	JSR     -$228(A6)
	MOVE.L  D0,D2
	BEQ.S   .1
	MOVEA.L D0,A1
	JSR     -$19E(A6)
	MOVEQ   #0,D0
	CMP.L   $18(A2),D2
	BNE.S   .1
	MOVE.L  $14(A2),D1
	BEQ.S   .1
	MOVEA.L A2,A0
	MOVEA.L D2,A6
	JSR     -$A8(A6)
.1
	TST.L   D0
	MOVEM.L (A7)+,D2/A2/A6
	RTS

	xdef _GetRexxVar
_GetRexxVar:
	MOVEM.L 4(A7),A0-A1
	BSR.S   __GetRexxVar
	BNE.S   .2
	MOVEA.L $C(A7),A0
	MOVE.L  A1,(A0)
.2
	RTS

	xdef __GetRexxVar:
__GetRexxVar
	MOVEM.L D2-D3/A2-A6,-(A7)
	MOVEA.L A0,A2
	MOVEA.L A1,A3
	BSR.S   __CheckRexxMsg
	BEQ.S   .3
	MOVEA.L $18(A2),A6
	MOVEA.L $14(A2),A0
	JSR     -$6C(A6)
	MOVEA.L A0,A4
	MOVEA.L A3,A0
	BSR.L   .4
	BNE.S   .5
	MOVEA.L A1,A2
	MOVE.L  D1,D2
	MOVEA.L A4,A0
	MOVE.L  D2,D0
	MOVEQ   #0,D1
	JSR     -$48(A6)
	MOVEQ   #0,D0
	ADDQ.L  #8,A1
	TST.L   D1
	BEQ.S   .5
	SUBA.L  A1,A1
	BRA.S   .5
.3
	MOVEQ   #$A,D0
.5
	TST.L   D0
	MOVEM.L (A7)+,D2-D3/A2-A6
	RTS

	xdef _SetRexxVar
_SetRexxVar:
	MOVEM.L 4(A7),A0-A1
	MOVEM.L $C(A7),D0-D1

	xdef __SetRexxVar
__SetRexxVar
	MOVEM.L D2-D7/A2-A6,-(A7)
	LEA     -$C(A7),A7
	MOVEA.L A0,A2
	MOVEA.L A1,A3
	MOVEA.L D0,A5
	MOVE.L  D1,D3
	LEA     .6,A0
	MOVEA.L A7,A1
	BSR.L   .7
	MOVEA.L A2,A0
	BSR.L   __CheckRexxMsg
	BEQ.S   .8
	MOVEA.L $18(A2),A6
	MOVEQ   #9,D0
	CMPI.L  #$FFFF,D3
	BGT.S   .9
	MOVEA.L $14(A2),A0
	JSR     -$6C(A6)
	MOVEA.L A0,A4
	MOVEA.L A3,A0
	BSR.L   .4
	BNE.S   .9
	MOVEA.L A1,A2
	MOVE.L  D1,D2
	MOVEA.L A4,A0
	MOVE.L  D2,D0
	JSR     -$42(A6)
	MOVE.L  D0,D4
	MOVEA.L A4,A0
	MOVEA.L A5,A1
	MOVE.L  D3,D0
	BSR.L   .10
	BEQ.S   .6
	MOVEA.L A4,A0
	MOVEA.L D0,A1
	MOVE.L  D4,D0
	JSR     -$54(A6)
	MOVEQ   #0,D0
	BRA.S   .9
.6
	MOVEQ   #3,D0
	BRA.S   .9
.8
	MOVEQ   #$A,D0
.9
	MOVEA.L A7,A0
	MOVE.L  D0,-(A7)
	BSR.L   .11
	MOVE.L  (A7)+,D0
	LEA     $C(A7),A7
	MOVEM.L (A7)+,D2-D7/A2-A6
	RTS

.4
	MOVEM.L D2-D3/A2-A3,-(A7)
	MOVEQ   #0,D2
	MOVEQ   #0,D3
	JSR     -$120(A6)
	MOVEA.L A0,A1
	MOVEA.L A4,A0
	BSR.S   .10
	MOVEA.L D0,A2
	BEQ.S   .12
	LEA     8(A2),A1
	MOVE.W  4(A2),D0
	MOVE.L  A1,D1
.13
	CMPI.B  #$2E,(A1)+
	DBEQ    D0,.13
	BNE.S   .14
	EXG     D1,A1
	SUB.L   A1,D1
	MOVE.L  A2,D3
	MOVEA.L A4,A0
	MOVE.L  D1,D0
	BSR.S   .10
	MOVEA.L D0,A2
	BEQ.S   .12
.14
	LEA     8(A2),A0
	JSR     -$66(A6)
	CMP.W   4(A2),D1
	BEQ.S   .15
	MOVEQ   #$28,D2
	BRA.S   .15
.12
	MOVEQ   #3,D2
.15
	TST.L   D2
	BEQ.S   .16
	MOVEA.L A4,A0
	MOVEA.L A2,A1
	BSR.S   .17
	MOVEA.L A4,A0
	MOVEA.L D3,A1
	BSR.S   .17
.16
	MOVEA.L A2,A1
	MOVE.L  D3,D1
	MOVE.L  D2,D0
	MOVEM.L (A7)+,D2-D3/A2-A3
	RTS

.10
	MOVEM.L D0/A1,-(A7)
	ADDQ.L  #8,D0
	ADDQ.L  #1,D0
	JSR     -$72(A6)
	MOVEM.L (A7)+,D0/A1
	BEQ.S   .18
	MOVE.L  A0,-(A7)
	CLR.L   (A0)
	MOVE.W  D0,4(A0)
	MOVE.B  #2,6(A0)
	CLR.B   8(A0,D0.L)
	ADDQ.L  #8,A0
	JSR     -$10E(A6)
	MOVEA.L (A7)+,A0
	MOVE.B  D0,7(A0)
.18
	MOVE.L  A0,D0
	RTS

.17
	MOVE.L  A1,D1
	BEQ.S   .19
	MOVEQ   #1,D0
	AND.B   6(A1),D0
	BNE.S   .19
	MOVE.W  4(A1),D0
	ADDQ.L  #8,D0
	ADDQ.L  #1,D0
	JSR     -$78(A6)
.19
	RTS

.7
	MOVE.L  A3,-(A7)
	MOVEA.L $14(A2),A3
	MOVE.L  A2,0(A1)
	MOVEM.L $FC(A3),D0-D1
	MOVEM.L A0-A1,$FC(A3)
	MOVEM.L D0-D1,4(A1)
	MOVEA.L (A7)+,A3
	RTS

.11
	MOVEA.L 0(A0),A1
	MOVEA.L $14(A1),A1
	MOVEM.L 4(A0),D0-D1
	MOVEM.L D0-D1,$FC(A1)
	RTS

rxsyslibname:
	dc.b "rexxsyslib.library"
	dc.b 0,0
