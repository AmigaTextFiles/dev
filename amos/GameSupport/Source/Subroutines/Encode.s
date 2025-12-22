        lea     .RawLength(pc),a0
        move.l  (a3)+,(a0)
        lea     .RawDataPtr(pc),a0
        move.l  (a3)+,(a0)
        lea     .GameIDPtr(pc),a0
        move.l  (a3)+,(a0)
        bsr     .SumRawData
        move.l  .RawDataPtr(pc),a0
        lea     .PassCode+1(pc),a1
        move.l  .RawLength(pc),d7
        subq    #1,d7
        moveq   #1,d6
.encodeloop1
        move.l  (a0)+,d0
.encodeloop2
        move.b  d0,d1
        and.l   #15,d1
        lsr.l   #4,d0
        beq     .encodeskip
        bset    #4,d1
.encodeskip
        move.b  d1,(a1)+
        addq    #1,d6
        btst    #4,d1
        bne     .encodeloop2
        dbf     d7,.encodeloop1
.encodedone
        move.b  #0,(a1)+
        lea     .PassCodeLength(pc),a0
        addq    #1,d6
        move.w  d6,(a0)

        lea     .seed2(pc),a0
        move.l  .RawSum(pc),(a0)

        bsr     .DigestID

        lea     .PassCode(pc),a0
        move.b  .PassCodeLength+1(pc),(a0)
        move.w  .PassCodeLength(pc),d7
        subq    #2,d7
.encryptloop
        move.b  (a0),d1
        moveq   #31,d0
        bsr     .random
        eor     d0,d1
        add.l   #65,d1
        cmp.l   #90,d1
        ble     .oknotnum
        sub.l   #39,d1
.oknotnum
        move.b  d1,(a0)+
        dbf     d7,.encryptloop
.encryptdone
        move.l  a0,-(a7)
        bsr     .SumDestData
        move.l  (a7)+,a0
        move.l  .RawSum(pc),d0
        sub.l   .DestSum(pc),d0
        and.l   #31,d0
        add.l   #65,d0
        cmp.l   #90,d0
        ble     .csoknotnum
        sub.l   #39,d0
.csoknotnum
        move.b  d0,(a0)+

        lea     .PassCodeLength(pc),a0
        move.w  (a0),d3
        and.l   #$FFFE,d3               * Only EVEN!
        addq.w  #2,d3
        Rjsr    L_Demande
        move.l  a0,d3
        lea     .PassCodeLength(pc),a0
        move.w  (a0),(a1)+
        move.w  (a0)+,d7
        subq    #1,d7
.copyloop
        move.b  (a0)+,(a1)+
        dbf     d7,.copyloop
        move.l  a1,HiChaine(a5)

        moveq   #2,d2

        rts

.random
        ;       Generate a `random' number in the range 0 to n-1
        ;       n is supplied in d0
        ;       random number returned in d0
        movem.l d1-d3/a0-1,-(a7); Save scratch registers
        lea     .seed(pc),a0
        lea     .seed2(pc),a1
        move.l  d0,d3           ; copy range before we go over it
        move.l  (a1),d0         ; The 32 bit longword from last time.
        move.l  (a0),d1         ; A 32 bit seed, default $52616E64 ('Rand')
        rol.l   #1,d0           ; Rotate seed 1 bit left
        eor.l   d1,d0           ; Exclusive or seed into seed 2
        move.b  d0,d2           ; make copy and mask out
        and.l   #15,d2          ; all but bits 0-3 to give 1 hex digit
        bchg    d2,d1           ; toggle whichever bit in the seed..
        move.l  d1,(a0)         ; and store for next time.
        move.l  d0,(a1)         ; store seed 2 for next time.
        and.l   d3,d0           ; modulus by the range supplied by caller
        movem.l (a7)+,d1-d3/a0-1; restore scratch registers
        rts

.SumRawData
        move.l  .RawDataPtr(pc),a0
        move.l  .RawLength(pc),d7
        subq    #1,d7
        moveq   #0,d0
.loop   add.l   (a0)+,d0
        dbf     d7,.loop
.done
        move.l  d0,d1
        lsr.l   #8,d1
        add.l   d1,d0
        lsr.l   #8,d1
        add.l   d1,d0
        lsr.l   #8,d1
        add.l   d1,d0
        and.l   #31,d0
        lea     .RawSum(pc),a0
        move.l  d0,(a0)
        rts

.SumDestData
        lea     .PassCode(pc),a0
        moveq   #0,d0
        moveq   #0,d1
.sdloop   move.b  (a0)+,d1
        beq     .sddone
        add.l   d1,d0
        bra     .sdloop
.sddone
        move.l  d0,d1
        lsr.l   #8,d1
        add.l   d1,d0
        lsr.l   #8,d1
        add.l   d1,d0
        lsr.l   #8,d1
        add.l   d1,d0
        and.l   #31,d0
        lea     .DestSum(pc),a0
        move.l  d0,(a0)
        rts

.DigestID
        move.l  .GameIDPtr(pc),a0
        moveq   #0,d0
        move.w  (a0)+,d7
        subq    #1,d7
.digestloop
        add.b   (a0)+,d0
        rol.l   #7,d0
        dbf     d7,.digestloop
        lea     .seed(pc),a0
        move.l  d0,(a0)
        rts

.RawSum
        dc.l    0
.DestSum
        dc.l    0
.seed    dc.l    0
.seed2   dc.l    0

.RawDataPtr
        dc.l    0
.RawLength
        dc.l    0
.GameIDPtr
        dc.l    0

.PassCodeLength
        dc.w    0
.PassCode
        dcb.b   30,0
        EVEN

