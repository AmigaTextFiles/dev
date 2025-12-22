


	XDEF	limStrCmp_str1_str2_limiter_lenght

limStrCmp_str1_str2_limiter_lenght:

	MOVEM.L  4(A7),D0/D2/A0/A1
	MOVE.W	 D0,D1
	BEQ.S	 equal
	SUBQ.W	 #1,D1
loop:
	MOVE.B	 (A1)+,D0
	CMP.B	 (A0)+,D0
	BMI.B	 biger
	BGT.B	 lower
	CMP.B	 D2,D0
start:
	DBEQ	 D1,loop
equal:
	MOVEQ	 #0,D0
	RTS
biger:
	MOVEQ	 #1,D0
	RTS
lower:
	MOVEQ	 #-1,D0
	RTS

