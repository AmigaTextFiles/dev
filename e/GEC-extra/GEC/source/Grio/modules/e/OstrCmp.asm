

	XDEF	gOstrCmp_str1_str2_length

gOstrCmp_str1_str2_length:

	MOVEM.L	4(A7),D1/A0/A1
	MOVEQ	#1,D0
	BRA.S	start
loop:
	MOVE.B	(A1)+,D2
	CMP.B	(A0)+,D2
	BEQ.B	same
	BMI.B	big
	MOVEQ	#-1,D0
big:
	RTS
same:
	TST.B	D2
start:
	DBEQ	D1,loop
	MOVEQ	#0,D0
	RTS

