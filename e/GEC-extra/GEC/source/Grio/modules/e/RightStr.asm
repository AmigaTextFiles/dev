

	XDEF	gRightStr_estr1_estr2_length

gRightStr_estr1_estr2_length:
	MOVEM.L	4(A7),D1/A0/A1
	MOVE.W	-2(A0),D0
	SUB.W	D1,D0
	BCC.B	ok_pos
	MOVEQ	#0,D0
ok_pos:
	ADDA.W	D0,A0
	MOVEA.L	A1,A2
	MOVE.W	-4(A1),D1
	SUBQ.W	#1,D1
	BMI.B	quit
	MOVE.W	D1,D0
loop:
	MOVE.B	(A0)+,(A1)+
	DBEQ	D0,loop
	CLR.B	(A1)
	SUB.W	D0,D1
	MOVE.W	D1,-2(A2)
quit:
	MOVE.L	A2,D0
	RTS

