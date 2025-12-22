

	XDEF	gMapList_address_list_elist_quotedexp


gMapList_address_list_elist_quotedexp:

	MOVEM.L	4(A7),A0-A3
	PEA	(A1)
	SUBQ.W	#4,A1
	MOVE.W	(A1)+,D0
	MOVE.W	-2(A2),D1
	CMP.W	D1,D0
	BMI.S	quit
	MOVE.W	D1,(A1)+
	BRA.S	start
loop:
	MOVE.L	(A2)+,(A3)
	MOVEM.L	D1/A0-A3,-(A7)
	JSR	(A0)
	MOVEM.L	(A7)+,D1/A0-A3
	MOVE.L	D0,(A1)+
start:
	DBF	D1,loop
quit:
	MOVE.L	(A7)+,D0
	RTS



