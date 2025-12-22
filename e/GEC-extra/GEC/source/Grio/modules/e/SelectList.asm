

	XDEF	gSelectList_address_list_elist_quotedexp

gSelectList_address_list_elist_quotedexp:

	MOVEM.L	4(A7),A0-A3
	MOVEA.L	A1,A6
	MOVEQ	#0,D1
	MOVE.W	-2(A2),D2
	BRA.S	skip
loop:
	MOVE.L	(A2)+,(A3)
	MOVEM.L	D1/D2/A0-A3/A6,-(A7)
	JSR	(A0)
	MOVEM.L	(A7)+,D1/D2/A0-A3/A6
	TST.L	D0
	BEQ.S	skip
	MOVE.L	(A3),(A1)+
	ADDQ.W	#1,D1
	CMP.W	-4(A6),D1
	BEQ.S	quit
skip:
	DBF	D2,loop
quit:
	MOVE.W	D1,-2(A6)
	MOVE.L	D1,D0
	RTS

