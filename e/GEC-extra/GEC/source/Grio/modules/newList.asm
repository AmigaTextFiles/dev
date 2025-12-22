


    XDEF    newList_mlh


newList_mlh:

    move.l    4(a7),d0
    beq.s     quit
    movea.l   d0,a0
    move.l    d0,8(a0)
    addq.w    #4,a0
    clr.l     (a0)
    move.l    a0,-(a0)
quit:
    rts

