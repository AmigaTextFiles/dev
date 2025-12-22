   


    xdef      hexStr2Num_hexstr
    
    
hexStr2Num_hexstr:

    movea.l   4(a7),a0
    moveq     #0,d0
    moveq     #0,d1
    moveq     #48,d2
hstrvalloop:
    lsl.l     #4,d0
    bcc.s     hstrvalok
hstrvalerror:
    moveq     #-1,d0
    rts
hstrvalok:
    move.b    (a0)+,d1
    cmp.b     d2,d1
    bcs.s     hstrvalerror
    cmpi.b    #57,d1
    bls.s     hstrnohex
    andi.b    #223,d1
    cmp.b     #65,d1
    bcs.s     hstrvalerror
    cmp.b     #70,d1
    bhi.s     hstrvalerror
    subq.b    #7,d1        
hstrnohex:
    sub.b     d2,d1
    add.l     d1,d0
    tst.b     (a0)
    bne.b     hstrvalloop
hstrvalend:
    rts




