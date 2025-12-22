OPT MODULE


EXPORT PROC findTagItem(tag,taglist)
    MOVE.L  taglist,D0
    BEQ.S   quitf
    MOVEA.L D0,A0
loopf:
    MOVE.L  (A0)+,D0
    BEQ.S   quitf
    MOVE.L  D0,D1
    MOVE.L  (A0)+,D0
    CMP.L   tag,D1
    BNE.S   loopf
quitf:
ENDPROC D0


EXPORT PROC countTagItems(taglist)
    MOVE.L  taglist,D0
    BEQ.S   quitc
    MOVEA.L D0,A0
    MOVEQ   #0,D0
loopc:
    TST.L   (A0)+
    BEQ.S   quitc
    ADDQ.L  #4,A0
    ADDQ.L  #1,D0
    BRA.S   loopc
quitc:
ENDPROC D0




