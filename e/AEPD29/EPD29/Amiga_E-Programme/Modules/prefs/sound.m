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
   MOVE.B (A