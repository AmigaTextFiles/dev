
; Pools.c 1.0 (11.97.94) © D. Göhler
; This source was *NEVER* tested and just typed in from the
; Amiga magazine, 10/94. Handle it with care.
; Adapted to match the definitions of LibAllocPooled() and
; LibFreePooled() by Jochen Wiedmann.
; adapted to use with O2M (AmigaE) and some bugfixes by Piotr Gapiïski
; (_libFreePooled__iii)

        include exec/lists.i

        XDEF  _libCreatePool__iii
        XDEF  _libDeletePool__i
        XDEF  _libAllocPooled__ii
        XDEF  _libFreePooled__iii

        SECTION "START",CODE


_AllocMemHeader
; d0: size, d1: flags
        movem.l d2/d3/a2/a6,-(a7)
        move.l  d0,d2
L23     move.l  d2,d0
        add.l   #$20,d0
        move.l  $4.w,a6
        jsr     -$C6(a6)
        move.l  d0,a0
        cmp.w   #0,a0
        beq.b   L25
L24     lea     $20(a0),a1
        clr.l   (a1)
        move.l  d2,4(a1)
        move.b  #$A,$8(a0)
        clr.l   $A(a0)
        clr.l   (a0)
        clr.l   4(a0)
        clr.b   $9(a0)
        move.l  a1,$10(a0)
        move.l  a1,$14(a0)
        lea     0(a1,d2.l),a1
        move.l  a1,$18(a0)
        move.l  d2,$1C(a0)
L25     move.l  a0,d0
        movem.l (a7)+,d2/d3/a2/a6
        rts

_FreeMemHeader
; a0: PTR TO mh
        movem.l a6,-(a7)
        move.l  a0,a1
L26     cmp.w   #0,a1
        beq.b   L28
L27     move.l  $18(a1),d0
        sub.l   $14(a1),d0
        add.l   #$20,d0
        move.l  $4.w,a6
        jsr     -$D2(a6)
L28     movem.l (a7)+,a6
        rts

_AllocPuddle
; a0: PTR TO pool
; d0: size
        movem.l d2/d3/a6,-(a7)
        move.l  a0,a6
L45     move.l  d0,d1
        addq.l  #$8,d1
        move.l  $12(a6),d2
        cmp.l   d1,d2
        bls.b   L47
L46     move.l  $12(a6),d0
        bra.b   L48
L47     addq.l  #$8,d0
L48     move.l  $E(a6),d1
        jsr     _AllocMemHeader
        move.l  d0,a1
        cmp.w   #0,a1
        bne.b   L50
L49     moveq   #0,d0
        movem.l (a7)+,d2/d3/a6
        rts
L50     move.l  a6,a0
        move.l  $4.w,a6
        jsr     -$F0(a6)
        moveq   #1,d0
        movem.l (a7)+,d2/d3/a6
        rts

_libCreatePool__iii
        movem.l d2-d4/a6,-(a7)
        move.l  $1C(a7),d4   ; memFlags
        move.l  $18(a7),d3   ; puddle
        move.l  $14(a7),d2   ; tresh
L29     move.l  $4.w,a0
        move.w  $14(a0),d0
        cmp.w   #$27,d0
        blo.b   L31
L30     move.l  $4.w,a6
        move.l  d4,d0
        move.l  d3,d1
        jsr     -$2B8(a6)
        movem.l (a7)+,d2-d4/a6
        rts
L31     sub.l   a6,a6
        cmp.l   d3,d2
        bhi.b   L35
L32     move.l  $4.w,a6
        moveq   #$1A,d0
        moveq   #0,d1
        jsr     -$C6(a6)
        move.l  d0,a6
        cmp.w   #0,a6
        beq.b   L35
L33     move.l  d4,$E(a6)
        move.l  d3,$12(a6)
        move.l  d2,$16(a6)
        NEWLIST a6
        move.b  #$A,$C(a6)
L34
L35
        move.l  a6,d0
        movem.l (a7)+,d2-d4/a6
        rts

_libDeletePool__i
        movem.l a2/a3/a6,-(a7)
        move.l  $10(a7),a2   ; pool
L36     move.l  $4.w,a0
        move.w  $14(a0),d0
        cmp.w   #$27,d0
        blo.b   L38
L37     move.l  $4.w,a6
        move.l  a2,a0
        jsr     -$2BE(a6)
        bra.b   L44
L38     cmp.w   #0,a2
        beq.b   L44
L39     bra.b   L41
L40     move.l  a2,a0
        move.l  (a0),a3
        move.l  $4.w,a6
        move.l  a3,a1
        jsr     -$FC(a6)
        move.l  a3,a0
        jsr     _FreeMemHeader
L41     move.l  a2,a1
        move.l  $8(a1),a0
        cmp.l   a2,a0
        bne.b   L40
L42     move.l  $4.w,a6
        moveq   #$1A,d0
        move.l  a2,a1
        jsr     -$D2(a6)
L43
L44
        movem.l (a7)+,a2/a3/a6
        rts


_libAllocPooled__ii
        movem.l d2/a2/a3/a6,-(a7)
        move.l  $18(a7),a3   ; pool
        move.l  $14(a7),d2   ; size
L51     move.l  $4.w,a0
        move.w  $14(a0),d0
        cmp.w   #$27,d0
        blo.b   L53
L52     move.l  $4.w,a6
        move.l  d2,d0
        move.l  a3,a0
        jsr     -$2C4(a6)
        movem.l (a7)+,d2/a2/a3/a6
        rts
L53     move.l  a3,a1
        move.l  $8(a1),a0
        cmp.l   a3,a0
        beq.b   L55
L54     move.l  a3,a0
        cmp.l   $16(a0),d2
        blo.b   L58
L55     move.l  d2,d0
        move.l  a3,a0
        jsr     _AllocPuddle
        tst.w   d0
        bne.b   L58
L56     moveq   #0,d0
        movem.l (a7)+,d2/a2/a3/a6
        rts
L57
L58
        move.l  a3,a0
        move.l  (a0),a2
        bra.b   L62
L59     move.l  $4.w,a6
        move.l  d2,d0
        move.l  a2,a0
        jsr     -$BA(a6)
        move.l  d0,a0
        cmp.w   #0,a0
        beq.b   L61
L60     move.l  a0,d0
        movem.l (a7)+,d2/a2/a3/a6
        rts
L61     move.l  a2,a0
        move.l  (a0),a2
L62     move.l  a2,a1
        tst.l   (a1)
        bne.b   L59
L63     move.l  d2,d0
        move.l  a3,a0
        jsr     _AllocPuddle
        tst.w   d0
        bne.b   L65
L64     moveq   #0,d0
        movem.l (a7)+,d2/a2/a3/a6
        rts
L65     move.l  a3,a0
        move.l  $4.w,a6
        move.l  d2,d0
        move.l  (a0),a0
        jsr     -$BA(a6)
        movem.l (a7)+,d2/a2/a3/a6
        rts

_libFreePooled__iii
        movem.l a6,-(a7)
        move.l  $10(a7),a0   ; pool
        move.l  $C(a7),a1    ; mem
        move.l  $8(a7),d0    ; size
        movem.l d0/a0-a1,-(a7)
        move.l  $4.w,a0
        move.w  $14(a0),d0
        cmp.w   #$27,d0
        blo.b   L66
        move.l  $4.w,a6
        movem.l (a7)+,d0/a0-a1
        jsr     -714(a6)
        bra.b   L67
L66     movem.l (a7)+,d0/a0-a1
   cmp.w   #0,a1
        bne.b   L68
L67     movem.l (a7)+,a6
        rts
L68     move.l  (a0),a0
        bra.b   L73
L69     cmp.l   $14(a0),a1
        blo.b   L72
L70     cmp.l   $18(a0),a1
        bhs.b   L72
L71     move.l  $4.w,a6
        jsr     -$C0(a6)
        movem.l (a7)+,a6
        rts
L72     move.l  (a0),a0
L73     tst.l   (a0)
        bne.b   L69
L74     movem.l (a7)+,a6
        rts

   END
