

   XDEF     stricmp_str1_str2_len

   
stricmp_str1_str2_len:

	MOVEM.L	4(A7),D0/A0/A1		; LEN,STR1,STR2
	MOVE.L	D0,D2
	BEQ.S	.quit
	MOVEA.L	D0,A2
	ADDQ.W	#1,A2
	MOVEQ	#-1,D0
	MOVEQ	#0,D1
	MOVEM.L	D3-D7,-(A7)
	MOVEQ	#32,D4
	MOVEQ	#65,D5
	MOVEQ	#90,D6
	BRA.S	.start
.loop:	TST.B	D3
	BEQ.S	.qlen
	SUBQ.L	#1,D2
	BEQ.S	.qlen
.start:	MOVE.B	(A1)+,D3
	MOVE.B	(A0)+,D7
	CMP.B	D7,D3
	BEQ.S	.loop
	CMP.B	D5,D3
	BCS.S	.next
	CMP.B	D6,D3
	BHI.S	.next
	OR.B	D4,D3
.next:	CMP.B	D5,D7
	BCS.S	.sub
	CMP.B	D6,D7
	BHI.S	.sub
	OR.B	D4,D7
.sub:	SUB.B	D3,D7
	BEQ.S	.loop
	EXT.W	D7
	EXT.L	D7
	MOVE.L	D7,D1
	MOVEQ	#0,D0
.qlen:	MOVEM.L	(A7)+,D3-D7
	SUBA.L	D2,A2
	MOVE.L	A2,D2
.quit:	RTS


