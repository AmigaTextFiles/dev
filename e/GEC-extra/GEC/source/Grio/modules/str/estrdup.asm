


     xdef  estrdup_estr

estrdup_estr:

    movea.l   4(a7),a0
    moveq     #0,d0
    move.w    -4(a0),d0
    move.l    d0,-(a7)
    beq.s     quit
    dc.w      $4eb9,$3,$2b	;  String
    move.l    d0,(a7)
    beq.s     quit
    move.l    8(a7),-(a7)
    pea       (-1).w
    dc.w      $4eb9,$3,$26      ;  StrCopy
    addq.w    #8,a7
quit:
    addq.w    #4,a7
    rts


    