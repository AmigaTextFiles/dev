
	XDEF	gExists_address_list_quotedexp

gExists_address_list_quotedexp:

	MOVEM.L	4(A7),A0-A2
	MOVEQ	#-1,D1
	MOVE.W	-2(A1),D2
	BRA.B	start
loop:
	MOVE.L	(A1)+,(A2)
	MOVEM.L	D1/D2/A0-A2,-(A7)
	JSR	(A0)
	MOVEM.L	(A7)+,D1/D2/A0-A2
	TST.L	D0
start:
	DBNE	D2,loop
	BNE.S	quit
	MOVEQ	#0,D1
quit:
	MOVE.L	D1,D0
	RTS


