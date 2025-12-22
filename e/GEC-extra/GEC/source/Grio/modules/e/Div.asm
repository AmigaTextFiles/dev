

	XDEF	gDiv_num1_num2


gDiv_num1_num2:

	MOVEM.L	D3-D5,-(A7)
	MOVEQ	#31,D2
	MOVEQ	#0,D3
	MOVEQ	#0,D4
	MOVE.L	20(A7),D0
	SMI	D5
	BPL.B	next
	NEG.L	D0
next:
	MOVE.L	16(A7),D1
	BPL.B	loop
	TST.B	D5
	SEQ	D5
	NEG.L	D1
loop:
	ASL.L	#1,D3
	ASL.L	#1,D0
	ROXL.L	#1,D4
	CMP.L	D1,D4
	BCS.B	smaller
	SUB.L	D1,D4
	ADDQ.L	#1,D3
smaller:
	DBF	D2,loop
	TST.B	D5
	BEQ.B	quit
	NEG.L	D3
quit:
	MOVE.L	D4,D1
	MOVE.L	D3,D0
	MOVEM.L	(A7)+,D3-D5
	RTS

