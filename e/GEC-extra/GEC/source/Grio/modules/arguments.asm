


        XDEF      initArgs_str

arg	equ	-32
        
initArgs_str:

        MOVE.L    4(A7),D0
        BNE.S     startarg
        MOVE.L    arg(A4),D0
startarg:
        MOVEM.L   D3-D7,-(A7)
        MOVEQ     #0,D1
        MOVEA.L   D0,A2
        MOVEQ     #0,D0
        TST.B     (A2)
        BEQ.S     griogotoquit
        MOVEQ     #10,D3
        CMP.B     (A2),D3
        BEQ.S     griogotoquit
        MOVEA.L   (4).W,A6
        MOVE.L    #320,D0
        MOVE.L    D0,D4
        ADDQ.W    #3,D0
        LSL.W     #2,D0
        MOVE.L    D0,D2
        JSR       -198(A6)
        MOVE.L    D0,D1
griogotoquit:
        BEQ.W     grioquit
        MOVEA.L   D0,A3
        MOVE.L    D2,(A3)+
        ADDQ.W    #4,A3
        MOVE.L    A3,D0
        MOVE.L    D4,D1
        MOVEA.L   D4,A6
        MOVEA.L   A2,A0
        MOVEQ     #" ",D4
        MOVEQ     #34,D5
        MOVEQ     #9,D6
        MOVEQ     #"=",D7
        BRA.S     griogetchar
grionewarg:
        TST.B     (A0)
        BEQ.S     griookquit
        CMP.B     (A0),D3
        BEQ.S     griookquit
        MOVEA.L   A0,A2
griogetchar:    
        MOVE.B    (A0)+,D2
        BEQ.S     griozero
        CMP.B     D3,D2
        BEQ.S     griozero
        CMP.B     D5,D2
        BEQ.S     griojestcu
        CMP.B     D4,D2
        BEQ.S     griozero
        CMP.B     D7,D2
        BEQ.S     griozero
        CMP.B     D6,D2
        BNE.S     griogetchar
griozero:
        CLR.B     -1(A0)
        MOVE.L    A2,(A3)+
        SUBQ.W    #1,D1
        BEQ.S     griookquit
griospace:
        MOVE.B    (A0)+,D2
        CMP.B     D4,D2
        BEQ.S     griospace
        CMP.B     D7,D2
        BEQ.S     griospace
        CMP.B     D6,D2
        BEQ.B     griospace
        SUBQ.W    #1,A0
        BRA.S     grionewarg
griojestcu:
        CMP.B     -2(A0),D4
        BLT.S     griogetchar
        MOVEA.L   A0,A1
griocu:
        MOVE.B    (A1)+,D2
        BEQ.S     griogetchar
        CMP.B     D3,D2
        BEQ.S     griogetchar
        CMP.B     D5,D2
        BNE.S     griocu
        CMP.B     (A1),D4
        BLT.S     griocu
        MOVEA.L   A1,A0
        ADDQ.W    #1,A2
        BRA.S     griozero
griookquit:
        EXG       D1,A6
        SUB.W     A6,D1
	CLR.L     (A3)
	MOVEA.L   D0,A0
	MOVE.L    D1,-4(A0)
grioquit:
        MOVEM.L   (A7)+,D3-D7
        RTS




        XDEF     endArgs_argsArray

endArgs_argsArray:

        MOVE.L   4(A7),D0
        BEQ.S    quitenda
        MOVEA.L  D0,A1
        MOVEA.L  (4).W,A6
        SUBQ.W   #8,A1
        MOVE.L   (A1),D0
        JSR      -210(A6)
quitenda:
	RTS





         XDEF       argFind_argsArray_pattern_type

         XDEF       BADUSAGE
         XDEF       SWITCH
         XDEF       KEYWORD


BADUSAGE	EQU	-1
SWITCH          EQU     0
KEYWORD         EQU     4


argFind_argsArray_pattern_type:

         MOVEM.L    4(A7),D1/D2/A3
	 MOVEM.L    D3-D5,-(A7)
         LEA        -4(A3),A2
         MOVE.L	    (A2),D0
         BEQ.S      endargfind
         MOVEQ      #32,D5
argfindgetnext:
	 MOVE.L     (A3)+,D0
	 BEQ.S      endargfind
         MOVEA.L    D0,A0
         MOVEA.L    D2,A1
argfcheckarg:
	 MOVE.B     (A1)+,D3
	 BEQ.S      argfendcheck
         MOVE.B     (A0)+,D4
	 BEQ.S      argfindgetnext
         OR.B       D5,D3
	 OR.B       D5,D4
	 CMP.B      D3,D4
	 BEQ.S      argfcheckarg
	 BRA.S      argfindgetnext
argfendcheck:
	 TST.B      (A0)
	 BNE.S      argfindgetnext
	 MOVEQ      #1,D3
	 TST.W      D1
	 BEQ.S      nokeyword
         MOVE.L     (A3),D0
         BNE.S      noemptykey
         MOVEQ      #0,D1
         MOVEQ      #BADUSAGE,D0
         BRA.S      nokeyword
noemptykey:
         ADDQ.L     #1,D3
nokeyword:
	 LEA        -4(A3),A0
	 LEA        0(A3,D1.W),A1
looprestargs: 	       
	 MOVE.L     (A1)+,(A0)+
	 BNE.S      looprestargs
	 SUB.L      D3,(A2)
endargfind:
	 MOVE.L     (A2),D1
	 MOVEM.L    (A7)+,D3-D5
         RTS


