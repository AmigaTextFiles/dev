



	XDEF    skiparg_str


skiparg_str:

	MOVEA.L 4(A7),D0
	BEQ.S   ZeroParam
	MOVEA.L D0,A0
	MOVEA.L D0,A1
	TST.B   (A0)
	BEQ.B   NoMore
	CMP.B   #10,(A0)
	BNE.B   Start
NoMore:
	MOVEQ   #0,D0
ZeroParam:
	RTS
Start:
	MOVE.B  (A0)+,D1
	BEQ.B   Finish
	CMPI.B  #10,D1
	BEQ.B   Clear
	CMP.B   #'"',D1
	BNE.B   NoComma
Loop:
	MOVE.B  (A0)+,D1
	BNE.B   NoZero
	MOVEQ   #-1,D0
	CLR.B   -(A0)
	BRA.B   Quit
NoZero:
	CMPI.B  #'"',D1
	BEQ.B   Clear
	CMP.B   #'*',D1
	BNE.B   NoStar
	CMPI.B  #'n',(A0)
	BEQ.B   ItLF
	CMPI.B  #'N',(A0)
	BNE.B   NoLF
ItLF:
	MOVEQ   #10,D1
	BRA.B   IncA0
NoLF:
	CMPI.B  #'e',(A0)
	BEQ.B   ItEsc
	CMPI.B  #'E',(A0)
	BNE.B   NoEsc
ItEsc:
	MOVEQ   #27,D1
	BRA.B   IncA0
NoEsc:
	MOVE.B  (A0),D1
IncA0:
	ADDQ.W  #1,A0
NoStar:
	MOVE.B  D1,(A1)+
	BRA.B   Loop
NoComma:
	CMPI.B  #' ',D1
	BEQ.B   Clear
	CMPI.B  #9,D1
	BEQ.B   Clear
	CMPI.B  #'=',D1
	BEQ.B   Clear
	MOVE.B  D1,(A1)+
	BRA.B   Start
Clear:
	CLR.B   (A1)
KillWhite:
	MOVE.B  (A0)+,D1
	BEQ.B   Finish
	CMPI.B  #' ',D1
	BEQ.B   KillWhite
	CMPI.B  #9,D1
	BEQ.B   KillWhite
	CMPI.B  #'=',D1
	BEQ.B   KillWhite
Finish:
	SUBQ.W  #1,A0
Quit:
	MOVE.L  A0,D0
	RTS


