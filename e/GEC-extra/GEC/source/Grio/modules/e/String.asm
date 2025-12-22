

	XDEF	gString_size_raise

gString_size_raise:
	MOVEM.L	4(A7),A2/A3
	MOVE.L	A3,D0
	BEQ.B   quit
	MOVEQ   #0,D0
	CMPA.W	#$7FF0,A3
	BCC.B	quit
	MOVE.L	A3,D0
	MOVEQ   #17,D1
	ADD.L	D1,D0
	MOVE.L	D0,D2
	MOVEQ   #0,D1
	MOVEA.L	$4.W,A6
	JSR	-$C6(A6)
	TST.L	D0
	BNE.B	ok_mem
	MOVE.L	A2,D0
	BEQ.S   quit
	PEA	(A2)
	DC.W	$4EB9,$3,$5C	;	Raise
ok_mem:
	MOVEA.L	D0,A0
	LEA	-$14(A4),A1
	MOVE.L	(A1),(A0)+
	MOVE.L	D2,(A0)+
	CLR.L	(A0)+
	MOVE.W	A3,(A0)+
	CLR.L   (A0)
	ADDQ.W  #2,A0
	MOVE.L	D0,(A1)
	MOVE.L  A0,D0	
quit:
	RTS





