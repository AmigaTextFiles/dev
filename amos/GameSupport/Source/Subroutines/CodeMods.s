L_GSLoadCodeMod equ 90
L90
        move.l  (a3)+,a0
        DLoad   a1
        lea     CodeModules-MyBase(a1),a1
        moveq   #15,d7
.findloop
        move.l  (a1),d0
        beq     .found
        lea     8(a1),a1
        dbf     d7,.findloop
        moveq   #6,d0
        Rbra    L_Custom

.found
        moveq   #15,d1
        sub.l   d7,d1
        lea     CodeModSlot(pc),a1
        move.l  d1,(a1)

        movem.l a1-6/d1-7,-(a7)
        move.w  (a0)+,d0
        subq.w  #1,d0
        cmp.w   #128,d0
        blt     .nameok
        moveq   #23,d0
        movem.l (a7)+,a1-6/d1-7
        Rjmp    L_Error

.nameok
        move.l  Name1(a5),a1
.namecopyloop
        move.b  (a0)+,(a1)+
        dbra    d0,.namecopyloop
        clr.b   (a1)
        Rjsr    L_Dsk.PathIt

        move.l  Name1(a5),d1
        move.l  DosBase(a5),a6
        jsr     _LVOLoadSeg(a6)
        DLoad   a0
        lea     CodeModules-MyBase(a0),a0
        move.l  CodeModSlot(pc),d1
        lsl.l   #3,d1
        move.l  d0,(a0,d1)
        beq     .error
        lsl.l   #2,d0
        move.l  d0,a1
        moveq   #15,d7
.findheaderloop
        lea     2(a1),a1
        cmp.l   #"GSMo",(a1)
        beq     .foundheader
        dbf     d7,.findheaderloop
.foundheader
        move.l  a1,4(a0,d1)
        move.l  GSCMH_Initialise(a1),a0
        jsr     (a0)
.ok
        movem.l (a7)+,a1-6/d1-7
        move.l  CodeModSlot(pc),d3
        move.l  #0,d2
        rts

.error
        moveq   #23,d0
        movem.l (a7)+,a1-6/d1-7
        Rjmp    L_Error

CodeModSlot
        dc.l    0

L_GSUnloadCodeMod equ 91
L91
        DLoad   a2
        lea     CodeModules-MyBase(a2),a0
        move.l  (a3)+,d0
        movem.l a3-6,-(a7)
        lsl.l   #3,d0
        move.l  4(a0,d0),a1
        movem.l a0-a6/d0-d7,-(a7)
        move.l  GSCMH_CleanUp(a1),a0
        jsr     (a0)
        movem.l (a7)+,a0-a6/d0-d7
        move.l  (a0,d0),d1
        beq    .error
        move.l  #0,(a0,d0)
        move.l  #0,4(a0,d0)
        move.l  DosBase(a5),a6
        jsr     _LVOUnLoadSeg(a6)
        movem.l (a7)+,a3-6
        rts

.error
        movem.l (a7)+,a3-6
        rts

L_GSGetAttr equ 92
L92
        DLoad   a2
        lea     CodeModules-MyBase(a2),a2
        move.l  (a3)+,a0
        lea     2(a0),a0
        move.l  (a3)+,d0
        movem.l a3-6,-(a7)
        lsl.l   #3,d0
        move.l  4(a2,d0),a1
        move.l  GSCMH_AttributeHash(a1),a1
        bsr     .findstring

        tst.l   d0
        beq     .notfound

        move.l  d0,a0
        move.l  (a0),d3
        move.l  #0,d2
        movem.l (a7)+,a3-6
        rts

.notfound
        move.l  #7,d0
        movem.l (a7)+,a3-6
        Rbra    L_Custom

.findstring
        move.b  (a0),d0
        bclr    #5,d0
        sub.l   #65,d0
        bmi     .invalidstring
        cmp.l   #25,d0
        bgt     .invalidstring  ; the first character was between `A' and `Z'

        lsl.l   #2,d0
        move.l  (a1,d0),a2
        move.l  4(a1,d0),d7     ; If the next hash entry is the same as this one
        sub.l   a2,d7           ; there are no strings at this hashpoint.
        beq     .invalidstring
        lsr.l   #3,d7           ; d7 now contains the number of hashstrings to be
        subq    #1,d7           ; searched.
.searchloop
        move.l  a0,a1
        move.l  4(a2),a3

.compareloop
        move.b  (a1)+,d0
        move.b  (a3)+,d1
        beq     .found

        bclr    #5,d0
        bclr    #5,d1

        cmp.b   d0,d1
        beq     .compareloop

        lea     8(a2),a2
        dbf     d7,.searchloop

.invalidstring
        moveq   #0,d0
        rts

.found
        move.l  a2,d0
        rts

L_GSSetAttr equ 93
L93
        DLoad   a2
        lea     CodeModules-MyBase(a2),a2
        lea     .newvalue(pc),a1
        move.l  (a3)+,(a1)
        move.l  (a3)+,a0
        lea     2(a0),a0
        move.l  (a3)+,d0
        movem.l a3-6,-(a7)
        lsl.l   #3,d0
        move.l  4(a2,d0),a1
        move.l  GSCMH_AttributeHash(a1),a1
        bsr     .findstring

        tst.l   d0
        beq     .notfound

        movem.l (a7),a3-6
        move.l  d0,a0
        move.l  .newvalue(pc),(a0)
        move.l  #0,d2
        movem.l (a7)+,a3-6
        rts

.notfound
        move.l  #7,d0
        movem.l (a7)+,a3-6
        Rbra    L_Custom

.findstring
        move.b  (a0),d0
        bclr    #5,d0
        sub.l   #65,d0
        bmi     .invalidstring
        cmp.l   #25,d0
        bgt     .invalidstring  ; the first character was between `A' and `Z'

        lsl.l   #2,d0
        move.l  (a1,d0),a2
        move.l  4(a1,d0),d7     ; If the next hash entry is the same as this one
        sub.l   a2,d7           ; there are no strings at this hashpoint.
        beq     .invalidstring
        lsr.l   #3,d7           ; d7 now contains the number of hashstrings to be
        subq    #1,d7           ; searched.
.searchloop
        move.l  a0,a1
        move.l  4(a2),a3

.compareloop
        move.b  (a1)+,d0
        move.b  (a3)+,d1
        beq     .found

        bclr    #5,d0
        bclr    #5,d1

        cmp.b   d0,d1
        beq     .compareloop

        lea     8(a2),a2
        dbf     d7,.searchloop

.invalidstring
        moveq   #0,d0
        rts

.found
        move.l  a2,d0
        rts

.newvalue
        dc.l    0

L_GSFindAttr equ 94
L94
        DLoad   a2
        lea     CodeModules-MyBase(a2),a2
        move.l  (a3)+,a0
        lea     2(a0),a0
        move.l  (a3)+,d0
        movem.l a3-6,-(a7)
        lsl.l   #3,d0
        move.l  4(a2,d0),a1
        move.l  GSCMH_AttributeHash(a1),a1
        bsr     .findstring

        tst.l   d0
        beq     .notfound

        move.l  d0,a0
        move.l  a0,d3
        move.l  #0,d2
        movem.l (a7)+,a3-6
        rts

.notfound
        move.l  #7,d0
        movem.l (a7)+,a3-6
        Rbra    L_Custom

.findstring
        move.b  (a0),d0
        bclr    #5,d0
        sub.l   #65,d0
        bmi     .invalidstring
        cmp.l   #25,d0
        bgt     .invalidstring  ; the first character was between `A' and `Z'

        lsl.l   #2,d0
        move.l  (a1,d0),a2
        move.l  4(a1,d0),d7     ; If the next hash entry is the same as this one
        sub.l   a2,d7           ; there are no strings at this hashpoint.
        beq     .invalidstring
        lsr.l   #3,d7           ; d7 now contains the number of hashstrings to be
        subq    #1,d7           ; searched.
.searchloop
        move.l  a0,a1
        move.l  4(a2),a3

.compareloop
        move.b  (a1)+,d0
        move.b  (a3)+,d1
        beq     .found

        bclr    #5,d0
        bclr    #5,d1

        cmp.b   d0,d1
        beq     .compareloop

        lea     8(a2),a2
        dbf     d7,.searchloop

.invalidstring
        moveq   #0,d0
        rts

.found
        move.l  a2,d0
        rts

L_GSCallMod equ 95
L95
        DLoad   a2
        lea     CodeModules-MyBase(a2),a2
        move.l  (a3)+,a0
        lea     2(a0),a0
        move.l  (a3)+,d0
        movem.l a3-6,-(a7)
        lsl.l   #3,d0
        move.l  4(a2,d0),a1
        move.l  GSCMH_FunctionHash(a1),a1
        bsr     .findstring

        tst.l   d0
        beq     .notfound

        move.l  d0,a0
        move.l  (a0),a0
        jsr     (a0)
        movem.l (a7)+,a3-6
        rts

.notfound
        move.l  #8,d0
        movem.l (a7)+,a3-6
        Rbra    L_Custom

.findstring
        move.b  (a0),d0
        bclr    #5,d0
        sub.l   #65,d0
        bmi     .invalidstring
        cmp.l   #25,d0
        bgt     .invalidstring  ; the first character was between `A' and `Z'

        lsl.l   #2,d0
        move.l  (a1,d0),a2
        move.l  4(a1,d0),d7     ; If the next hash entry is the same as this one
        sub.l   a2,d7           ; there are no strings at this hashpoint.
        beq     .invalidstring
        lsr.l   #3,d7           ; d7 now contains the number of hashstrings to be
        subq    #1,d7           ; searched.
.searchloop
        move.l  a0,a1
        move.l  4(a2),a3

.compareloop
        move.b  (a1)+,d0
        move.b  (a3)+,d1
        beq     .found

        bclr    #5,d0
        bclr    #5,d1

        cmp.b   d0,d1
        beq     .compareloop

        lea     8(a2),a2
        dbf     d7,.searchloop

.invalidstring
        moveq   #0,d0
        rts

.found
        move.l  a2,d0
        rts


