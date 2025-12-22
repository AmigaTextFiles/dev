
SureText	DC.B	"  Ok  ",0
CancelText	DC.B	"Cancel",0
ResumeText	DC.B	"Resume",0

;	even
	CNOP 0,2

;----------------------------------------------------
	xdef	TwoGadRequest
TwoGadRequest:
;Bool=TwoGadRequest(String,Controls)
;                     A0      A1

	MOVEM.L	A2-A4/D2,-(SP)

	LEA.L	SureText,A2
	LEA.L	CancelText,A3
	BRA.S	TheRequest

SimpleRequest:

;SimpleRequest(Text,Controls)
;               A0	A1
; This is just a method of telling a user something. It just calls MultiRequest
; with no gadgets.

	MOVEM.L	A2-A4/D2,-(SP)
	SUBA.L	A2,A2
	LEA.L	ResumeText,A3

TheRequest

	MOVE.L	_ReqBase,A6	;Load A6 from the data segment _before_ tromping on A4.

	SUB.W	#TR_SIZEOF,SP		;get some temporary storage.

	MOVE.L	SP,A4
	MOVEQ	#TR_SIZEOF/2-1,D2	;because the stack is almost never clear.
1$	CLR.W	(A4)+
	DBF	D2,1$

	MOVE.L	A0,TR_Text(SP)
	MOVE.L	A1,TR_Controls(SP)
	MOVE.L	A2,TR_PositiveText(SP)
	MOVE.L	A3,TR_NegativeText(SP)

	MOVE.W	#$FFFF,TR_KeyMask(SP)

	MOVE.L	SP,A0
	JSR	_LVOTextRequest(A6)

	ADD.W	#TR_SIZEOF,SP

	MOVEM.L	(sp)+,A2-A4/D2
	RTS
