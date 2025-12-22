

	XDEF    gListCmp_list1_list2_length


gListCmp_list1_list2_length:

	MOVEM.L	4(A7),D1/A0/A1
	MOVEQ	#0,D0
	TST.W	D1
	BPL.S	no_all
	MOVE.W	-2(A0),D1
no_all:
	CMP.W	-2(A1),D1
	BEQ.S	start
	RTS
loop:
	CMPM.L	(A0)+,(A1)+
start:
	DBNE	D1,loop
	BNE.S	quit
true:
	MOVEQ	#-1,D0
quit:
	RTS
	

