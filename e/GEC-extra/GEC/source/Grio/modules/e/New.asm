


	XDEF	gNew_size_raise


gNew_size_raise:
	MOVEM.L	4(A7),A2/A3
	ADDQ.W	#8,A3
	MOVE.L	A3,D0
	MOVEQ	#0,D1
	MOVE.L	4.W,A6
	JSR	-198(A6)
	TST.L	D0
	BNE.S	ok_mem
	MOVE.L	A2,D0
	BEQ.S	quit
	PEA	(A2)
	DC.W	$4EB9,$3,$5C
ok_mem:
	MOVEA.L	D0,A0
	LEA	-$14(A4),A1
	MOVE.L	(A1),(A0)+
	MOVE.L	A3,(A0)+
	MOVE.L	D0,(A1)
	MOVE.L	A0,D0
quit:
	RTS

	

