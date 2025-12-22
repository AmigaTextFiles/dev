OPT MODULE
EXPORT PROC stringf(str,format,listptr=NIL:PTR TO LONG)
   MOVEA.L str,A0
   MOVE.L A0,A6
   MOVEA.L format,A1
   MOVEA.L listptr,A2
nxt:
   MOVE.B (A1)+,(A0)+
   BEQ.S  done
   CMPI.B  #"%",-1(A0)
   BNE.S nxt
   MOVE.B (A1)+,(A0)+
   CMPI.B  #"l",-1(A1)
   BEQ.S gotl
   CMPI.B  #"s",-1(A1)
   BNE.S nxt
   SUBQ.W #2,A0 	 /* eat the %s	*/
   MOVEA.L (A2)+,A3     /* must be a string pointer  */
dcopy:
   MOVE.B  (A3)+,(A0)+    /* copy byte  */
   BNE.S dcopy
   SUBQ.W  #1,A0	  /* write over 0  */
   BRA.S  nxt

done:
   SUBA.L A6,A0
   SUBQ.L #1,A0 	/* length  */
   EXG A6,A0		/* A0 points to str, A6 to length  */
   CMPA.W -4(A0),A6      /* compare with maxlength  */
   BHI.S toolong
   MOVE.W A6,-2(A0)      /* equivalent to SetStr()  */
toolong:
   MOVE.L A6,D1
   MOVE.L A0,D0
   BRA endstringf

gotl:
   MOVE.B (A1)+,D0
   MOVE.B D0,(A0)+
   CMPI.B #"d",D0
   BEQ.S gotdec
   CMPI.B #"x",D0
   BEQ gothex
   CMPI.B #"c",D0
   BEQ.S gotchar
   CMPI.B #"b",D0
   BNE.S nxt
   SUBQ.W #3,A0    /* eat %lb  */ /* bin routine starts here  */
   MOVE.L (A2)+,D0
   BEQ.S binzero
   MOVEQ #31,D1
next0:
   BTST  D1,D0
   DBNE D1,next0
nextbit:
   BTST D1,D0
   BEQ.S bit0
   MOVE.B #"1",(A0)+
   BRA.S bit1
bit0:
   MOVE.B #"0",(A0)+
bit1:
   DBRA D1,nextbit
   BRA nxt

binzero:
   MOVE.B #"0",(A0)+
   BRA nxt

gotchar:
   SUBQ.W #3,A0
   MOVE.L (A2)+,D0
   MOVE.B D0,(A0)+
   BRA nxt

gotdec:
   SUBQ.W #3,A0
   MOVE.L (A2)+,D0
   SUBA.W  #14,A7
   MOVEA.L A7,A3
   MOVE.L D0,D2
   BGE.S repeat
   NEG.L D0
repeat:
   MOVEQ  #0,D1
   LONG $4C7C0401,$A   /* DIVU.L #10,D1:D0	*/
   ADDI.B #"0",D1
   MOVE.B D1,(A3)+
   TST.L D0
   BGT.S repeat
   TST.L D2
   BGE.S notneg
   MOVE.B #"-",(A3)+
notneg:
   MOVE.B  -(A3),(A0)+
   CMPA.L  A3,A7
   BLT.S notneg
   ADDA.W #14,A7
   BRA nxt

gothex:
   MOVE.L (A2)+,D0
   SUBQ.W #3,A0
   MOVEA.L A7,A3
   SUBA.W  #14,A3
   MOVEQ #-1,D2
nextltr:
   MOVE.B D0,D1
   ANDI.B #$0F,D1
   ADDI.B #48,D1
   CMPI.B #57,D1
   BLE.S around
   ADDQ.B #7,D1
around:
   MOVE.B D1,(A3)+
   LSR.L #4,D0
   DBEQ D2,nextltr
   NOT.L D2
loadstr:
   MOVE.B -(A3),(A0)+    /* reverse buffer  */
   DBF D2,loadstr
   BRA nxt
endstringf:
ENDPROC D0
