    RawDoFmt= -522
    
    moveq.l #0,d0
    rts


PutCFunktion:
    move.b d0,(a3)+
    rts


Sprint_F[a3,a0,a1]:
    lea PutCFunktion,a2
    RawDoFmt(a0,a1,a2,a3)
    RTS
