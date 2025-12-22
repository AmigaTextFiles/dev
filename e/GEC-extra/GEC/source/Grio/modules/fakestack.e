OPT MODULE


EXPORT PROC fakestack(stackswap=NIL)

 MOVEA.L  stackswap,A3
 MOVE.L   A3,D0
 BNE.S    nofake
   FastNew  (12)
   MOVE.L   D0,-(A7)
   FreeStack()
   MOVEA.L  (A7)+,A3
   MOVE.L   A7,8(A3)   -> Point
   MOVE.L   A7,D1
   SUB.L    D0,D1
   MOVE.L   D1,(A3)    -> Lower
   MOVEQ    #12,D0
   ADD.L    A7,D0
   MOVE.L   D0,4(A3)   -> Upper
 nofake:

 MOVEA.L  execbase,A6
 SUBA.L   A1,A1
 JSR      FindTask(A6)
 MOVEA.L  D0,A2
 JSR      Forbid(A6)
 MOVEA.L  A3,A0
 MOVE.L   (A0)+,58(A2)  -> SPLower
 MOVE.L   (A0)+,62(A2)  -> SPUpper
 MOVE.L   (A0)+,54(A2)  -> SPReg
 JSR      Permit(A6)
 MOVE.L   A3,D0

ENDPROC D0




