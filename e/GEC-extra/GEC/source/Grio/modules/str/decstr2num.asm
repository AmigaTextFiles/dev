   


    xdef      decStr2Num_decstr


decStr2Num_decstr:

    movea.l   4(a7),a0
    moveq     #0,d0
    moveq     #0,d1
    moveq     #48,d2
    bra.s     dstrvalgo
dstrvalloop:
    add.l     d0,d0
    move.l    d0,a1
    add.l     d0,d0
    add.l     d0,d0
    add.l     a1,d0
    bcc.s     dstrvalgo
dstrvalerror:
    moveq     #-1,d0
    rts
dstrvalgo:
    move.b    (a0)+,d1
    cmp.b     d2,d1
    bcs.s     dstrvalerror
    cmpi.b    #57,d1
    bhi.s     dstrvalerror
    sub.b     d2,d1
    add.l     d1,d0
    tst.b     (a0)
    bne.b     dstrvalloop
dstrvalend:
    rts



