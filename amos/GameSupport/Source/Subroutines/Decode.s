
        lea     .DestDataPtr(pc),a0
        move.l  (a3)+,(a0)
        lea     .EncDataPtr(pc),a0
        move.l  (a3)+,(a0)
        lea     .GameIDPtr(pc),a0
        move.l  (a3)+,(a0)

        bsr     .DecryptBuffer

        move.l  .EncDataPtr(pc),a0
        move.b  1(a0),d0
        cmp.b   2(a0),d0
        bne     .error

        bsr     .Decode

        bsr     .SumRawData

        move.l  .RawSum(pc),d0
        cmp.l   .FinalSum(pc),d0
        bne     .error

        move.l  .RawLength(pc),d3
        moveq   #0,d2
        rts

.error
        moveq   #0,d3
        moveq   #0,d2
        rts

.DecryptBuffer
        move.l  .EncDataPtr(pc),a0
        move.w  (a0)+,d0
        ext.l   d0
        adda.l  d0,a0
        moveq   #0,d0
        move.b  -1(a0),d0
        move.b  #0,-1(a0)
        sub.l   #65,d0
        bpl     .dontadd
        add.l   #39,d0
.dontadd
        lea     .seed2(pc),a1
        move.l  d0,(a1)
        bsr     .SumEncData
        lea     .seed2(pc),a0
        move.l  (a0),d0
        add.l   .DestSum(pc),d0
        and.l   #31,d0
        move.l  d0,(a0)
        lea     .FinalSum(pc),a0
        move.l  d0,(a0)

        bsr     .DigestID

        move.l  .EncDataPtr(pc),a0
        lea     2(a0),a0
.decryptloop
        move.b  (a0),d1
        sub.l   #65,d1
        bpl     .oknotnum
        add.l   #39,d1
.oknotnum
        moveq   #31,d0
        bsr     .random
        eor     d0,d1
        move.b  d1,(a0)+

        rts

.Decode
        move.l  .EncDataPtr(pc),a0
        lea     3(a0),a0
        move.l  .DestDataPtr(pc),a1
        moveq   #0,d2
        moveq   #0,d3
        moveq   #0,d7
.decodeloop
        moveq   #0,d1
        move.b  (a0)+,d1
        beq     .decodedone
        sub.l   #65,d1
        bpl     .oknotnum2
        add.l   #39,d1
.oknotnum2
        moveq   #31,d0
        bsr     .random
        eor     d0,d1
        move.b  d1,d4
        and.l   #15,d4
        lsl.l   d3,d4
        or.l    d4,d2
        btst    #4,d1
        beq     .decodestore
        addq    #4,d3
        bra     .decodeloop
.decodestore
        move.l  d2,(a1)+
        addq    #1,d7
        moveq   #0,d2
        moveq   #0,d3
        bra     .decodeloop
.decodedone
        lea     .RawLength(pc),a0
        move.l  d7,(a0)
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

.SumEncData
        move.l  .EncDataPtr(pc),a0
        lea     2(a0),a0
        moveq   #0,d0
        moveq   #0,d1
.sumdestloop
        move.b  (a0)+,d1
        beq     .sumdestdone
        add.l   d1,d0
        bra     .sumdestloop
.sumdestdone

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

.SumRawData
        move.l  .DestDataPtr(pc),a0
        move.l  .RawLength(pc),d7
        subq    #1,d7
        moveq   #0,d0
.srdloop
        add.l   (a0)+,d0
        dbf     d7,.srdloop
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
.seed   dc.l    0
.seed2  dc.l    0
.RawLength
        dc.l    0
.FinalSum
        dc.l    0
.EncDataPtr
        dc.l    0
.DestDataPtr
        dc.l    0
.GameIDPtr
        dc.l    0

