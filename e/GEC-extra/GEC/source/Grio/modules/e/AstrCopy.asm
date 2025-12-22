

	XDEF	gAstrCopy_str1_str2_length


gAstrCopy_str1_str2_length:

	MOVEM.L	4(A7),D1/A0/A1
	MOVEQ	#0,D0
	MOVE.W	D1,D0
	BEQ.S	quit
	SUBQ.W	#1,D0
loop:
	MOVE.B	(A0)+,(A1)+
	DBEQ	D0,loop
	CLR.B	-(A1)
quit:
	RTS

