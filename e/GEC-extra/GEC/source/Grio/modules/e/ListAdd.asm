

	XDEF	gListAdd_elist_list_length


gListAdd_elist_list_length:

	MOVEM.L	4(A7),D0/A0/A1
	MOVEA.L	A1,A2
	TST.W	D0
	BPL.S	no_all
	MOVE.W	-2(A0),D0
no_all:
	SUBQ.W	#4,A1
	MOVE.W	(A1)+,D1
	SUB.W	(A1),D1
	CMP.W	D1,D0
	BMI.S	ok_len
	MOVE.W	D1,D0
ok_len:
	TST.W	D0
	BLE.S	quit
	MOVEQ	#0,D1
	MOVE.W	(A1),D1
	ADD.W	D0,(A1)+
	LSL.L	#2,D1
	ADDA.L	D1,A1
loop:
	MOVE.L	(A0)+,(A1)+
	DBF	D0,loop
quit:
	MOVE.L	A2,D0
	RTS

