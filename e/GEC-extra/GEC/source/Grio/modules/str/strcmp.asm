

   XDEF     strcmp_str1_str2_len

   
strcmp_str1_str2_len:

   MOVEM.L  4(A7),D1/A0/A1
   MOVE.L   D1,D0
   BEQ.S    quit
   MOVEA.L  D1,A2
   ADDQ.W   #1,A2
   MOVEQ    #0,D0
   BRA.S    start
loop:
   TST.B    D2
   BEQ.S    qlen
   SUBQ.L   #1,D1
   BEQ.S    qlen
start:
   MOVE.B   (A1)+,D2
   CMP.B    (A0)+,D2
   BEQ.S    loop
stop:
   SUB.B    D2,D0
   EXT.W    D0
   EXT.L    D0
qlen:
   SUBA.L   D1,A2
   MOVE.L   A2,D1
quit:
   RTS


