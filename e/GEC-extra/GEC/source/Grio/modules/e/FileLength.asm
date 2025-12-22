

	XDEF	gFileLength_name


gFileLength_name:

	MOVE.L	 4(A7),D1
	PEA      (-1).W
	MOVEQ    #-2,D2
	MOVEA.L	 -$2C(A4),A6
	JSR      -84(A6)
	MOVE.L   D0,A2
	MOVE.L   A2,D1
	BEQ.S    quit
	MOVEA.L	 A7,A3
	MOVE.L   A7,D0
	ANDI.W	 #-4,D0
	MOVEA.L	 D0,A7
	LEA	 -260(A7),A7
	MOVE.L   A7,D2
	JSR	 -102(A6)
	MOVE.L	 124(A7),D1
	MOVEA.L	 A3,A7
	TST.L	 D0
	BEQ.S	 unlock
	MOVE.L	 D1,(A7)
unlock:
	MOVE.L   A2,D1
	JSR	 -90(A6)
quit:
	MOVE.L   (A7)+,D0
	RTS

