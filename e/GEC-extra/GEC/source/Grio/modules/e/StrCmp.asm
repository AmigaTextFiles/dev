

	XDEF	gStrCmp_str1_str2_length

gStrCmp_str1_str2_length:

	MOVEM.L	4(A7),D1/A0/A1
	MOVEQ	#0,D0
	ADDQ.W	#1,D1
loop:
	SUBQ.W	#1,D1
	BEQ.S	same
	MOVE.B	(A1)+,D2
        CMP.B	(A0)+,D2
	BNE.B	quit
	TST.B	D2
	BNE.B	loop
same:
	MOVEQ	#-1,D0
quit:
	RTS

