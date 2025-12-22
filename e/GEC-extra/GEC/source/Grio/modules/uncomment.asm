

REMLF		EQU	0
REMSPACE	EQU	1
STAR		EQU	2
EC		EQU	3


UNCM_NORMAL	EQU	0
UNCM_REMLF	EQU	1
UNCM_REMSPACE	EQU	2
UNCM_STAR	EQU	4
UNCM_EC		EQU	8


		XDEF	UNCM_NORMAL
		XDEF	UNCM_REMLF
		XDEF	UNCM_REMSPACE
		XDEF	UNCM_STAR
		XDEF	UNCM_EC



	XDEF  unComment_str_opt



unComment_str_opt:

	MOVEM.L	D2-D7/A2,-(A7)
        MOVEM.L 32(A7),D7/A0
	MOVEA.L	A0,A1
	MOVEA.L	A0,A2
	MOVEQ	#10,D2
	MOVEQ	#" ",D3
	MOVEQ	#"*",D4
	MOVEQ	#"/",D5
	MOVEQ	#9,D6
loopkillcom:
	MOVE.B	(A0)+,D0
	BEQ.W	copybyte
	BTST	#REMLF,D7
	BEQ.S	killnolf
	CMP.B	D2,D0
	BNE.S	killnolf
killlf:
	CMP.B	(A0)+,D0
	BEQ.S	killlf
	SUBQ.W	#1,A0
	BRA.S	copyornot
killnolf:
	BTST	#REMSPACE,D7
	BEQ.S	endnospace
	CMP.B	D3,D0
	BEQ.S	checkfirst
	CMP.B	D6,D0
	BNE.S	endnospace
checkfirst:
	CMPA.L	A1,A2
	BEQ.S	loopkillcom
	CMP.B	-1(A1),D2
	BNE.S	nofirst
skipspace:
	MOVE.B	(A0)+,D0
	CMP.B	D3,D0
	BEQ.S	skipspace
	CMP.B	D6,D0
	BEQ.S	skipspace
	SUBQ.W	#1,A0
	BRA.S	loopkillcom
nofirst:
	MOVE.L	A0,D1
nofirstloop:
	MOVE.B	(A0)+,D0
        BEQ.W	copybyte
	CMP.B	D2,D0
	BEQ.W	copybyte
	CMP.B	D3,D0
	BEQ.S	nofirstloop
	CMP.B	D6,D0
	BEQ.S	nofirstloop
	MOVE.L	D1,A0
	MOVE.B	-1(A0),D0
	BRA.S	copybyte
endnospace:
	CMP.B	#";",D0
	BNE.S	nosred
nextline:	
	CMPA.L	A1,A2
	BEQ.S	loopnext
	MOVE.B	-(A1),D0
	CMP.B	D3,D0
	BEQ.S	nextline
	CMP.B	D6,D0
	BEQ.S	nextline
	ADDQ.W	#1,A1
loopnext:
	MOVE.B	(A0)+,D0
	BEQ.S	copybyte
	CMP.B	D2,D0
	BNE.S	loopnext
copyornot:
	CMPA.L	A2,A1
	BEQ.W	loopkillcom
	CMP.B	-1(A1),D2
	BEQ.W	loopkillcom
	BRA.S	copybyte
nosred:
        BTST    #STAR,D7
        BEQ.S   nostar
	CMP.B	D4,D0
	BEQ.S	nextline
nostar:
	BTST    #EC,D7
	BEQ.S   noEC
	CMP.B   #"-",D0
	BNE.B	noEC
	CMPI.B  #">",(A0)
	BNE.S   noEC
	ADDQ.W  #1,A0
	BRA.S   nextline
noEC:
	CMP.B	D5,D0
	BNE.S	copybyte
	CMP.B	(A0),D4
	BNE.S	copybyte
	MOVE.L	A0,D1
	ADDQ.W	#1,A0
killcomclose:
	MOVE.B	(A0)+,D0
	BEQ.S	killcomnoclose
	CMP.B	D4,D0
	BNE.S	killcomclose
	CMP.B	(A0),D5
	BNE.S	killcomclose
	ADDQ.W	#1,A0
	BRA.W	loopkillcom
killcomnoclose:
	MOVEA.L	D1,A0
	MOVE.B	D4,D0
copybyte:
	MOVE.B	D0,(A1)+
	BNE.W	loopkillcom
	SUBQ.W	#1,A1
	MOVE.L	A1,D0
	SUB.L	A2,D0
	MOVEM.L	(A7)+,D2-D7/A2
	RTS




