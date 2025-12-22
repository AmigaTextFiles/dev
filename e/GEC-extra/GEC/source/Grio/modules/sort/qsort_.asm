




	XDEF	qsort_low_high_comp_swap



qsort_low_high_comp_swap:


	LEA	8(A7),A0
	MOVEM.L	D3-D5/A5,-(A7)
	MOVEA.L	A0,A5
	ADDQ.W	#4,A0
	MOVE.L	(A0)+,D1
	MOVE.L	(A0),D0
	BSR.S	sort
	MOVEM.L	(A7)+,D3-D5/A5
	RTS




sort:
	MOVEM.L	D6/D7,-(A7)
	MOVE.L	D0,D6
	MOVE.L	D1,D7
loop1:
	CMP.L	D6,D7
	BLE.S	quit
	MOVE.L	D6,D3
	MOVE.L	D7,D4
	MOVE.L	D4,D5
	ADD.L	D3,D5
	LSR.L	#1,D5
loop2:
	MOVEM.L	D3/D5,-(A7)
	MOVEA.L	(A5),A0
	JSR	(A0)
	ADDQ.W	#8,A7
	TST.L	D0
	BGE.S	loop3
	ADDQ.L	#1,D3
	BRA.S	loop2
loop3:
	MOVEM.L	D4/D5,-(A7)
	MOVEA.L	(A5),A0
	JSR	(A0)
	ADDQ.W	#8,A7
	TST.L	D0
	BLE.S	stop
	SUBQ.L	#1,D4
	BRA.S	loop3
stop:
	CMP.L	D4,D3
	BGE.S	break
	MOVEM.L	D3/D4,-(A7)
	MOVEA.L -4(A5),A0
	JSR	(A0)
	ADDQ.W	#8,A7
	CMP.L	D3,D5
	BNE.S	no_a_c
	MOVE.L	D4,D5
	BRA.S	inc_dec
no_a_c:	
	CMP.L	D4,D5
	BNE.S	inc_dec
	MOVE.L	D3,D5
inc_dec:
	ADDQ.L	#1,D3
	SUBQ.L	#1,D4
	BRA.S	loop2
break:
	PEA	loop1(PC)
	MOVE.L	D7,D0
	SUB.L	D4,D0
	CMP.L	D4,D0
	BLE.S	min
	MOVE.L	D6,D0
	MOVE.L	D4,D1
	MOVE.L	D4,D6
	ADDQ.L	#1,D6
	BRA.S	sort
min:
	MOVE.L	D7,D1
	MOVE.L	D4,D0
	ADDQ.L	#1,D0
	MOVE.L	D4,D7
	BRA.S	sort
quit:
	MOVEM.L	(A7)+,D6/D7
	RTS




