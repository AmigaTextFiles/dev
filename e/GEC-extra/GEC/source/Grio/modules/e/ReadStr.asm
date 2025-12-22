


OFFSET_CURRENT	EQU	0

Read		EQU	-42
Seek		EQU	-66

dosbase		EQU	-44
estr		EQU	(2*4)+4
fh		EQU	estr+4



	XDEF	gReadStr_fh_estr

gReadStr_fh_estr:

	MOVEM.L	D3/D4,-(A7)
	MOVEA.L	estr(A7),A2
	MOVE.L	A2,D2
	MOVEQ	#0,D3
	MOVE.W	-4(A2),D3
	MOVE.L	fh(A7),D1
	MOVEA.L	dosbase(A4),A6
	JSR	Read(A6)
	MOVE.L	D0,D4
	BLE.S	error
	MOVEQ	#10,D1
	MOVEA.L	A2,A0
loop:
	CMP.B	(A0)+,D1
	BEQ.S	stop
	SUBQ.W	#1,D0
	BNE.S	loop
	BRA.S	quit
stop:
	SUBA.L	A2,A0
	MOVE.L	D4,D2
	SUB.L	A0,D2
	NEG.L	D2
	SUBQ.W	#1,A0
	MOVE.L	A0,D4
	MOVE.L	fh(A7),D1
	MOVEQ	#OFFSET_CURRENT,D3
	JSR	Seek(A6)
	TST.L	D0
	BPL.S	quit
error:
	MOVEQ	#-1,D0
	MOVEQ	#0,D4
	BRA.S	exit
quit:
	MOVE.L	D4,D0
exit:
	CLR.B	0(A2,D4.L)
	MOVE.W	D4,-2(A2)
	MOVEM.L	(A7)+,D3/D4
	RTS
	

