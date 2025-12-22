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
   BE