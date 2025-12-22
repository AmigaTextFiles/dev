


	XDEF	newM_size_attr


newM_size_attr:
	MOVEM.L	4(A7),D1/D2
	ADDQ.L	#8,D2
	MOVE.L	D2,D0
	MOVE.L	4.W,A6
	JSR	-198(A6)
	TST.L	D0
	BEQ.S	quit
	MOVEA.L	D0,A0
	LEA	-$14(A4),A1
	MOVE.L	(A1),(A0)+
	MOVE.L	D2,(A0)+
	MOVE.L	D0,(A1)
	MOVE.L	A0,D0
quit:
	RTS

	

