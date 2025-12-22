
L_GSForbid equ 10
L10
        movem.l a3-6,-(a7)
        move.l  4,a6
        jsr     _LVOForbid(a6)
        movem.l (a7)+,a3-6
        rts

L_GSPermit equ 11
L11
        movem.l a3-6,-(a7)
        move.l  4,a6
        jsr     _LVOPermit(a6)
        movem.l (a7)+,a3-6
        rts

L_GSTrackPlay1 equ 12
L12
        DLoad   a0
        move.l  (a3)+,LastPattern-MyBase(a0)
        move.l  (a3)+,FirstPattern-MyBase(a0)
        move.l  #-1,LastPattern2-MyBase(a0)
        move.l  #-1,FirstPattern2-MyBase(a0)
        move.l  (a3)+,d0
        movem.l a3-6,-(a7)
        Rjsr    L_Bnk.OrAdr
        move.l  d0,a2
        cmp.l   #"Trac",-8(a2)
        bne     .nobank
        cmp.l   #"ker ",-4(a2)
        bne     .nobank

        DLoad   a0
        move.l  a2,mt_data-MyBase(a0)
        DLoad   a6
        jsr     ResetCIAInt-MyBase(a6)
        movem.l (a7),a3-6
        DLoad   a6
        jsr     mt_init-MyBase(a6)
        movem.l (a7),a3-6
        DLoad   a6
        jsr     SetCIAInt-MyBase(a6)
        movem.l (a7),a3-6
        DLoad   a0
        st.b    mt_Enable-MyBase(a0)

        movem.l (a7)+,a3-6
        rts

.nobank
        movem.l (a7)+,a3-6
        moveq   #5,d0
        Rbra    L_Custom

L_GSTrackStop equ 13
L13
        movem.l a3-6,-(a7)

        DLoad   a6
        sf.b    mt_Enable-MyBase(a6)
        jsr     mt_end-MyBase(a6)
        movem.l (a7),a3-6
        DLoad   a6
        jsr     ResetCIAInt-MyBase(a6)

        movem.l (a7)+,a3-6
        rts

L_GSCMD8Data equ 14
L14
        DLoad   a2
        moveq   #0,d3
        move.w  FX8Mask-MyBase(a2),d3
        move.w  #0,FX8Mask-MyBase(a2)
        moveq   #0,d2
        rts

L_GSTrackTranspose equ 15
L15
        DLoad   a0
        move.l  (a3)+,d0
        move.b  d0,TransposeData-MyBase(a0)
        rts

L_GSTrackPlay2 equ 16
L16
        move.l  #-1,-(a3)
        Rbra    L_GSTrackPlay1

L_GSTrackPlay3 equ 17
L17
        move.l  #0,-(a3)
        Rbra    L_GSTrackPlay2

L_GSTrackLoopOn equ 18
L18
        DLoad   a0
        move.l  #1,TrackLoop-MyBase(a0)
        rts

L_GSTrackLoopOff equ 19
L19
        DLoad   a0
        move.l  #0,TrackLoop-MyBase(a0)
        rts

L_GSTrackLoop equ 20
L20
        move.l  #-1,-(a3)
        Rbra    L_GSTrackLoop2

L_GSTrackLoop2 equ 21
L21
        DLoad   a0
        move.l  #1,TrackLoop-MyBase(a0)
        move.l  (a3)+,LastPattern-MyBase(a0)
        move.l  (a3)+,FirstPattern-MyBase(a0)
        rts

L_GSTrackGosub equ 22
L22
        DLoad   a0
        sf      mt_Enable-MyBase(a0)
        moveq   #0,d0
        move.b  mt_SongPos-MyBase(a0),d0
        move.l  d0,FirstPattern-MyBase(a0)
        move.l  LastPattern-MyBase(a0),LastPattern2-MyBase(a0)
        move.l  (a3)+,LastPattern-MyBase(a0)
        move.l  (a3)+,d0
        move.b  d0,mt_SongPos-MyBase(a0)
        move.w  #0,mt_PatternPos-MyBase(a0)
        st      mt_Enable-MyBase(a0)
        rts

L_GSTrackGosub2 equ 23
L23
        move.l  (a3),d0
        move.l  d0,-(a3)
        Rbra    L_GSTrackGosub

L_GSTrackLoopDefer equ 24
L24
        DLoad   a0
        move.l  (a3)+,LastPattern2-MyBase(a0)
        move.l  (a3)+,FirstPattern-MyBase(a0)
        rts

L_GSTrackVolume equ 25
L25
        DLoad   a2
        move.l  (a3)+,d0
        move.w  d0,MasterVolume-MyBase(a2)
        rts

L26
L27
L28
L29
L30
L31
L32
L33
L34
L35

