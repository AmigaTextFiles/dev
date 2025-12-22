OPT MODULE


CONST RASTPORT=50,
      BORDERLEFT=54,
      BORDERTOP=55,
      BORDERRIGHT=56,
      BORDERBOTTOM=57,
      WIDTH=8,
      HEIGHT=10,
      FGPEN=25,
      LIBVER=20
      


EXPORT PROC fillwindow(window,colour)
 MOVE.L    window,D0
 BEQ.B     quit
 MOVEA.L   gfxbase,A6
 MOVEA.L   D0,A2
 MOVEA.L   RASTPORT(A2),A3
 CMP.W     #39,LIBVER(A6)
 BMI.S     low_os
 MOVEA.L   A3,A0
 JSR       GetAPen(A6)
 MOVE.L    D0,D2
 BRA.S     keep
low_os:
 MOVEQ     #0,D2
 MOVE.B    FGPEN(A3),D2    -> fake GetAPen()
keep:
 MOVEA.L   A3,A1
 MOVE.L    colour,D0
 JSR       SetAPen(A6)
 MOVEM.L   D2-D4,-(A7)
 MOVE.L    A3,A1
 MOVEQ     #0,D0
 MOVE.B    BORDERLEFT(A2),D0
 MOVEQ     #0,D1
 MOVE.B    BORDERTOP(A2),D1
 MOVEQ     #0,D4
 MOVEQ     #0,D2
 MOVE.W    WIDTH(A2),D2
 MOVE.B    BORDERRIGHT(A2),D4
 SUB.W     D4,D2
 SUBQ.W    #1,D2
 CMP.W     D0,D2
 BLS.B     nofill
 MOVEQ     #0,D3
 MOVE.W    HEIGHT(A2),D3
 MOVE.B    BORDERBOTTOM(A2),D4
 SUB.W     D4,D3
 SUBQ.W    #1,D3
 CMP.W     D1,D3
 BLS.B     nofill
 JSR       RectFill(A6)
nofill:
 MOVEM.L   (A7)+,D2-D4
 MOVEA.L   A3,A1
 MOVE.L    D2,D0
 JSR       SetAPen(A6)
quit:
ENDPROC NIL
