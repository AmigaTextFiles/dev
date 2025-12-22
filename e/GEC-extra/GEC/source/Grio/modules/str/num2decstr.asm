

    xdef      num2DecStr_buf_num

num2DecStr_buf_num:
    
    movem.l   4(a7),d0/a0
    movea.l   a7,a1
    clr.b     -(a1)
    moveq     #10,d1
    bra.s     start
numloop:
    moveq     #0,d2
    move.w    d0,d2
    beq.b     zero
    divu.w    d1,d2
    move.w    d2,d0
zero:
    swap      d0
    move.w    d0,d2
    divu.w    d1,d2
    move.w    d2,d0
    swap      d2
    addi.b    #48,d2
    move.b    d2,-(a1)
start:
    swap      d0
    bne.b     numloop
    move.l    a7,d0
    sub.l     a1,d0
    subq.l    #1,d0
copyloop:
    move.b    (a1)+,(a0)+
    bne.s     copyloop
    rts


    
