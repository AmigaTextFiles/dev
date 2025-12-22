

    xdef        num2HexStr_buf_num

num2HexStr_buf_num:

    movem.l     4(a7),d0/a0
    movea.l     a7,a1
    clr.b       -(a1)
hexloop:
    move.b      d0,d1
    andi.b      #15,d1	
    cmpi.b      #9,d1
    ble.b       hexdig
    addq.b      #7,d1
hexdig:
    addi.b      #48,d1
    move.b      d1,-(a1)
    lsr.l       #4,d0
    bne.b       hexloop
    move.l      a7,d0
    sub.l       a1,d0
    subq.l      #1,d0
copyhex:
    move.b      (a1)+,(a0)+
    bne.b       copyhex
    rts


