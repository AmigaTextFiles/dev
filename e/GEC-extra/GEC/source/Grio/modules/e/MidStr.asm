

	XDEF	gMidStr_estr_str_index_length



gMidStr_estr_str_index_length:

	MOVEM.L	4(A7),D1/D2/A0/A1
	ADDA.W	D2,A0
	MOVEA.L	A1,A2
	MOVE.W	-4(A1),D0
	CMP.W	D1,D0
	BCC.B	ok_len
	MOVE.W	D0,D1
ok_len:
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

