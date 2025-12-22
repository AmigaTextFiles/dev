lbC000644	MOVE.L	($10,A5),-(SP)
	PEA	(Is.MSG,PC)
	MOVE.L	A3,-(SP)
	BSR.W	Format?
	LEA	(12,SP),SP
	BRA.B	lbC00068A

lbC000658	MOVE.L	($10,A5),-(SP)
	PEA	(Is.MSG,PC)
	MOVE.L	A3,-(SP)
	BSR.W	Format?
	LEA	(12,SP),SP
	BRA.B	lbC00068A

lbC00066C	MOVE.L	($14,A5),-(SP)
	PEA	(Is.MSG,PC)
	MOVE.L	A3,-(SP)
	BSR.W	Format?
	LEA	(12,SP),SP
	BRA.B	lbC00068A

lbC000680	LEA	(ascii.MSG0,PC),A0
	MOVEA.L	A3,A1
lbC000686	MOVE.B	(A0)+,(A1)+
	BNE.B	lbC000686
lbC00068A	MOVEA.L	($28,SP),A0
	MOVE.L	A3,(A0)
	LEA	(8,A0),A5
	LEA	(9,A2),A0	;Start of volume name string
	MOVEA.L	($28,SP),A1
	MOVE.L	A0,(4,A1)
	MOVEA.L	($1C,SP),A3
	MOVE.L	(A2),D0	;BytesTotal still set to -1?
	MOVEQ	#-1,D1
	CMP.L	D1,D0
	BEQ.B	lbC000716	;don't calc sizes for this volume
	CMPI.L	#$200,D0
	BLT.B	lbC0006E4
	MOVEQ	#$40,D1	;Bit naughty, assumes 512 byte
	LSL.L	#3,D1	;block size
	BSR.W	DivideD0xD1
	MOVE.L	D0,($1C,SP)	;Save Total Blocks for later
	MOVE.L	(4,A2),D0	;Bytes Used
	MOVEQ	#$40,D1	;naughty again, divide by 512
	LSL.L	#3,D1
	BSR.W	DivideD0xD1
	MOVE.L	D0,D1	;=Blocks Used
	ASL.L	#2,D1	;x 4
	SUB.L	D0,D1	;-blocks used = (3xBlocksUsed)
	ASL.L	#3,D1	;x 8 = (24 x Blocks Used)
	ADD.L	D0,D1	;+ blocks used = (25 x BlocksUsed)
	ASL.L	#2,D1	;x 4 = (100 x BlocksUsed)
	MOVE.L	D1,D0
	MOVE.L	($1C,SP),D1	;BlocksFree
	BSR.W	DivideD0xD1	;(100 x BlocksUsed)/BlocksFree = %Full
	dw	$C40

lbC0006E4	MOVEQ	#$64,D0	;100%
	MOVE.L	D0,-(SP)
	PEA	(ld.MSG,PC)	;% Free string
	MOVE.L	($1C,SP),-(SP)
	BSR.W	Format?
	MOVE.L	(A2),D0	;Bytes Total -
	SUB.L	(4,A2),D0	;Bytes Used = Bytes Free
	MOVEA.L	A3,A0
	BSR.W	SizeString	;Calc size value: B,K,M,G
	MOVEA.L	D0,A3
	MOVEA.L	($24,SP),A0
	MOVE.L	(4,A2),D0	;Bytes Used
	BSR.W	SizeString	;Calc size value: B,K,M,G
	LEA	(12,SP),SP
	MOVEA.L	D0,A2
	BRA.B	lbC000724

lbC000716	MOVEA.L	($18,SP),A2
	CLR.B	(A2)
	CLR.B	(A3)
	MOVEA.L	($14,SP),A0
	CLR.B	(A0)
lbC000724	MOVE.L	($14,SP),(A5)
	MOVE.L	A3,(4,A5)
	MOVE.L	A2,(8,A5)
lbC000730	MOVEQ	#0,D0
	MOVEM.L	(SP)+,A2-A6
	ADDA.W	#$18,SP
	RTS

