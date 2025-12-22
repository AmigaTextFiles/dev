




	XDEF	qsort_base_low_high_comp_swap



qsort_base_low_high_comp_swap:


	LEA	4(A7),A0
	MOVEM.L	D3-D7/A5,-(A7)
	MOVEM.L	(A0)+,D6/A5	;	swap/comp
	MOVE.L	(A0)+,D0	;	high
	MOVE.L	(A0)+,-(A7)	;	low
	MOVE.L	D0,-(A7)	;	high
	MOVE.L	(A0)+,D7	;	base
	BSR.S	sort
	ADDQ.W	#8,A7
	MOVEM.L	(A7)+,D3-D7/A5
quit:
	RTS




sort:
	MOVE.L	8(A7),D3	;	D3=low
	MOVE.L	4(A7),D4	;	D4=high
	CMP.L	D3,D4
	BLE.S	quit
	MOVE.L	D4,D5
	ADD.L	D3,D5
	LSR.L	#1,D5
loop1:
	MOVEM.L	D3/D5/D7,-(A7)
	JSR	(A5)
	LEA	12(A7),A7
	TST.L	D0
	BGE.S	loop2
	ADDQ.L	#1,D3
	BRA.S	loop1
loop2:
	MOVEM.L	D4/D5/D7,-(A7)
	JSR	(A5)
	LEA	12(A7),A7
	TST.L	D0
	BLE.S	stop
	SUBQ.L	#1,D4
	BRA.S	loop2
stop:
	CMP.L	D4,D3
	BGE.S	break
	MOVEM.L	D3/D4/D7,-(A7)
	MOVEA.L	D6,A0
	JSR	(A0)
	LEA	12(A7),A7
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
	BRA.S	loop1
break:
	LEA	4(A7),A0
	MOVE.L	(A0),D0
	SUB.L	D4,D0
	CMP.L	D4,D0
	BGT.S	max
	MOVE.L	D4,D5
	ADDQ.L	#1,D5
	MOVE.L	(A0),D3		;	D3=high
rekur:
	MOVE.L	D4,(A0)
	MOVEM.L	D3/D5,-(A7)
	BSR.S	sort
	ADDQ.W	#8,A7
	BRA.S	sort
max:
	MOVE.L	D4,D3
	ADDQ.L	#1,D4
	ADDQ.W	#4,A0
	MOVE.L	(A0),D5		;	D5=low
	BRA.S	rekur



