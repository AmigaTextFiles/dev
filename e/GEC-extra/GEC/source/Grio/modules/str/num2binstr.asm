

    xdef        num2BinStr_buf_num

num2BinStr_buf_num:

    movem.l     4(a7),d0/a0
    movea.l     a7,a1
    clr.b       -(a1)
binloop:
    move.b      d0,d1
    andi.b      #1,d1	
    addi.b      #48,d1
    move.b      d1,-(a1)
    lsr.l       #1,d0
    bne.b       binloop
    move.l      a7,d0
    sub.l       a1,d0
    subq.l      #1,d0
copybin:
    move.b      (a1)+,(a0)+
    bne.b       copybin
    rts

