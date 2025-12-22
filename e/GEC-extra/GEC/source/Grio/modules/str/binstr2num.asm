   


    xdef      binStr2Num_binstr


binStr2Num_binstr:

    movea.l   4(a7),a0
    moveq     #0,d0
    moveq     #0,d1
    moveq     #"0",d2
bstrloop:
    add.l     d0,d0
    bcc.s     bstrok
bstrerror:
    moveq     #-1,d0
    rts
bstrok:
    move.b    (a0)+,d1
    cmp.b     d2,d1
    bcs.s     bstrerror
    cmpi.b    #"1",d1
    bhi.s     bstrerror
    sub.b     d2,d1
    add.l     d1,d0
    tst.b     (a0)
    bne.b     bstrloop
bstrend:
    rts


