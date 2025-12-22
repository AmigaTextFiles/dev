_LVOOpenLibrary EQU -552
_LVOCloseLibrary EQU -414
_LVOAllocMem EQU -198
_LVOFreeMem EQU -210
grd_Buffers EQU $80000001
grd_Width   EQU $80000002
grd_Height  EQU $80000003
grd_Depth   EQU $80000004
grd_PixelLayout EQU $80000005
grd_ColorSpace EQU $80000006

grd_PLANAR     EQU 0
grd_PLANARI    EQU 1
grd_CHUNKY     EQU 2
grd_HICOL15    EQU 3
grd_HICOL16    EQU 4
grd_TRUECOL24  EQU 5
grd_TRUECOL24P EQU 6
grd_TRUECOL32  EQU 7
grd_GRAFFITI   EQU 8
grd_TRUECOL32B EQU 9

grd_Palette    EQU 0
grd_RGB        EQU 1
grd_BGR        EQU 2
grd_RGBPC      EQU 3
grd_BGRPC      EQU 4

;    ;  0  TrueColor  LONG   RGB   %00000000 rrrrrrrr gggggggg bbbbbbbb   grd_TRUECOL32B + grd_RGB
;    ;  1  TrueColor 3 BYTE  RGB   %rrrrrrrr gggggggg bbbbbbbb            grd_TRUECOL24 + grd_RGB
;    ;  2  TrueColor  WORD   RGB   %rrrrrggg gggbbbbb                     grd_HICOL16 + grd_RGB
;    ;  3  TrueColor  WORD   RGB   %0rrrrrgg gggbbbbb                     grd_HICOL15 + grd_RGB
;    ;  4  TrueColor  LONG   BGR   %00000000 bbbbbbbb gggggggg rrrrrrrr   grd_TRUECOL32B + grd_BGR
;    ;  5  TrueColor 3 BYTE  BGR   %bbbbbbbb gggggggg rrrrrrrr            grd_TRUECOL24 + grd_BGR
;    ;  6  TrueColor  WORD   BGR   %bbbbbggg gggrrrrr                     grd_HICOL16 + grd_BGR
;    ;  7  TrueColor  WORD   BGR   %0bbbbbgg gggrrrrr                     grd_HICOL15 + grd_BGR
;    ;  8  TrueColor  LONG   RGB   %rrrrrrrr gggggggg bbbbbbbb 00000000   grd_TRUECOL32 + grd_RGB
;    ;  9  ColorMap   BYTE   -     -                                      grd_CHUNKY + grd_Palette
;    ; 10  Graffiti   BYTE   -     - (Graffiti style chunky, very special)grd_GRAFFITI + grd_Palette
;    ; 11  TrueColor  WORD   RGB   %gggbbbbb 0rrrrrgg                     grd_HICOL15 + grd_RGBPC
;    ; 12  TrueColor  WORD   BGR   %gggrrrrr 0bbbbbgg                     grd_HICOL15 + grd_BGRPC
;    ; 13  TrueColor  WORD   RGB   %gggbbbbb rrrrrggg                     grd_HICOL16 + grd_BGR
;    ; 14  TrueColor 3 BYTE  BGR   %bbbbbbbb gggggggg rrrrrrrr            grd_TRUECOL24 + grd_BGR
;    ; 15  TrueColor  LONG   BGR   %bbbbbbbb gggggggg rrrrrrrr 00000000   grd_TRUECOL32 + grd_BGR
;    ; 16  TrueColor  LONG   RGB   %rrrrrrrr gggggggg bbbbbbbb 00000000   grd_TRUECOL32 + grd_RGB
;    ; 17  TrueColor  WORD   BGR   %gggrrrrr bbbbbggg                     grd_HICOL16 + grd_BGRPC


CALLSYS MACRO
      jsr _LVO\1(a6)
     ENDM

XLIB MACRO
        XREF _LVO\1
        ENDM

OpenLibs:
        movem.l a0-a6/d0-d7,-(sp)
        move.l $4,a6
        move.l #0,CGXBase
        lea     CyberName,a1
        moveq   #40,d0
        jsr     -552(a6)
        move.l  d0,CGXBase(a5)
        beq.s   .Error
        move.l #-1,d6
.Next   Move.l  d6,d0
        move.l a6,-(sp)
        move.l GfxBase(a5),a6
        Jsr     -732(a6)
        move.l (sp)+,a6
        Move.l  d0,d6
        move.l a6,-(sp)
        move.l CGXBase(a5),a6
        move.l d6,d0
        jsr -54(a6)
        move.l (sp)+,a6
        cmp.l #0,d0
        bne .CyberFound
        Cmp.l   #-1,d6
        Beq     .Error
        bra .Next
.CyberFound
        Move.l  a5,d0
        Bra.s   .Ok
.Error  movem.l (sp)+,a0-a6/d0-d7
        Moveq   #0,d0
        rts
.Ok     Movem.l (sp)+,a0-a6/d0-d7
        moveq #1,d0
        Rts
CyberName: dc.b 'cybergraphics.library',0
        even
CGXBase: dc.l 0

SwitchScreens:
       
; This function works STARTING WITH cybergraphics.library V40.65
; It performs REAL DOUBLEBUFFERING, NO MOVESCREEN ANYMORE !!!

        movem.l d2-d7/a4-a6,-(sp)
        move.l GfxBase,a6
        move.l rsCGX_ActiveMap(a0),d1
        cmp.l d0,d1
        beq .Exit
        move.l d0,rsCGX_ActiveMap(a0)
        sub.l d7,d7
        move.w rsCGX_Height(a0),d7
        move.l rsCGX_MyScreen(a0),a0
        lea sc_ViewPort(a0),a1
        move.l vp_RasInfo(a1),a2

        cmp.l #0,d0
        beq .BufOne
        cmp.l #1,d0
        beq .BufTwo
        cmp.l #2,d0
        beq .BufThree
        bra .Exit
.BufOne:
        move.w #0,ri_RyOffset(a2)
        bra .Swap
.BufTwo:
        move.w d7,ri_RyOffset(a2)
        bra .Swap
.BufThree:
        move.w d7,ri_RyOffset(a2)
        add.w d7,ri_RyOffset(a2)
        bra .Swap

.Swap:
        move.l a1,a0
        jsr -588(a6)
.Exit:
        movem.l (sp)+,d2-d7/a4-a6
        rts

STRUCTURE RtgScreenCGX,0
  APTR   rsCGX_MyScreen  ; An Intuition Screen
  ULONG  rsCGX_ActiveMap ; Number of active buffer
  APTR   rsCGX_MapA ; Video Mem Adress of Buffer 0 (at front at the beginning...)
  APTR   rsCGX_MapB ; The same for buffer 1
  APTR   rsCGX_MapC ; The same for buffer 2
  APTR   rsCGX_FrontMap ; The address of the Buffer in front...
  ULONG  rsCGX_Bytes ; How many bytes one pixel fills (2 for 16 Bit for example)
  ULONG  rsCGX_Width ; The Width (Caution! Longword!)
  UWORD  rsCGX_Height; The Height (Caution! Now word... sorry for that :) )
  ULONG  rsCGX_NumBuf ; Number of buffers of that screen...
  UWORD  rsCGX_Locks ; The Rtg Locks...
  APTR   rsCGX_ModeID ; The ModeID of this screen ...
  ULONG  rsCGX_RealMapA ; The graphics.library Bitmap structure (modified by Cyber to support Chunky)
  STRUCT rsCGX_Tags,16 ; Some place for OpenRtgScreen to put something there :)
LABEL rsCGX_SIZEOF

STRUCTURE ScreenQuery,0
 ULONG sq_ModeID ; ModeID of the to be used Screenmode
 ULONG sq_Width      ; The Width
 ULONG sq_Height     ; The Height
 UWORD sq_Depth      ; The color depth
 ULONG sq_Buffers    ; How many Buffers...
LABEL sq_SIZEOF

OpenRtgScreen:
        movem.l d3-d7/a2-a6,-(sp)
        cmp.l #0,CGXBase
        beq .Exit
        move.l a2,a4
        move.w sq_Width(a2),-(sp)
        move.w sq_Height(a2),-(sp)
        move.l a2,a4
        move.l a3,a0
        move.l sq_Buffers(a2),d4
        move.l #3,d0
        cmp.l d0,d4
        bgt .Error1
.BufferDone:
        move.l #rsCGX_SIZEOF,d0
        move.l #MEMF_CLEAR,d1
        move.l $4,a6
        CALLSYS AllocMem
        cmp.l #0,d0
        beq .Error1
        move.l d0,a3
        move.l #136,d0
        move.l #MEMF_CLEAR,d1
        CALLSYS AllocMem
        cmp.l #0,d0
        beq .Error2
        move.l d0,d7
        move.l d0,a0
        move.l #SA_Left,(a0)+
        move.l #0,(a0)+
        move.l #SA_Top,(a0)+
        move.l #0,(a0)+
        move.l #SA_Height,(a0)+
        clr.l d0
        move.w (sp)+,d0
        clr.l d5
        move.w d0,d5
        move.l d0,d1
        cmp.l #1,d4
        beq .OneBuffer
        cmp.l #2,d4
        beq .TwoBuffer
        cmp.l #3,d4
        beq .ThreeBuffer
        bra .Error3
.ThreeBuffer:
        add.l d1,d0
        add.l d1,d5
        add.l d1,d5
        add.l d1,d0
        bra .OneBuffer
.TwoBuffer:
        add.l d1,d0
        add.l d1,d5
.OneBuffer:
        move.l d0,(a0)+
        move.l #SA_Width,(a0)+
        clr.l d0
        move.w (sp)+,d0
        clr.l d3
        move.w d0,d3
        move.l d3,(a0)+
        clr.l d0
        move.w sq_Depth(a4),d0
        move.l #SA_Depth,(a0)+
        move.l d0,(a0)+
        move.l #SA_Title,(a0)+
        move.l #0,(a0)+
        move.l #SA_DisplayID,(a0)+
        move.l sq_ModeID(a4),a1
        move.l a1,(a0)+

        ; No Autoscroll for CyberGraphX,
        ; so the user can't watch the
        ; DBuffering Buffers...
        ; No overscan, too...
        ; And no interleaved...
        ; Draggable HAS to be enabled...
        ; as it is per default...

        move.l #SA_Quiet,(a0)+
        move.l #1,(a0)+
        move.l #SA_DClip,(a0)+
        move.l d7,a2
        add.l #128,a2
        move.l a2,a1
        move.w #0,(a1)+
        move.w #0,(a1)+
        move.w #640,(a1)+
        move.w #480,(a1)+
        move.l a2,(a0)+
        move.l #TAG_END,(a0)+
        move.l #0,(a0)+
        move.l d7,a1
        move.l #0,a0
        move.l IntBase,a6
        jsr -612(a6) ; OpenScreenTagList
        cmp.l #0,d0
        beq .Error3
        move.l d7,a1
        move.l d0,rsCGX_MyScreen(a3)
        move.l #136,d0
        move.l $4,a6
        CALLSYS FreeMem
        move.l #0,rsCGX_ActiveMap(a3)
        move.l rsCGX_MyScreen(a3),a0
        clr.l d0
        move.w sc_Width(a0),d0
        ext.l d0
        move.l d0,rsCGX_Width(a3)
        move.w d5,rsCGX_Height(a3)
        move.l d4,rsCGX_NumBuf(a3)
        move.w #0,rsCGX_Locks(a3)
        move.l rsCGX_MyScreen(a3),a0
        lea sc_RastPort(a0),a0
        move.l rp_BitMap(a0),a0
        move.l a0,rsCGX_RealMapA(a3)
        move.l sq_ModeID(a4),d1
        move.l d1,rsCGX_ModeID(a3)
        move.l #CYBRIDATTR_PIXFMT,d0
        move.l CGXBase,a6
        jsr -102(a6) ; GetCyberIDAttr
        cmp.l #0,d0
        beq .OneByte
        cmp.l #9,d0
        blt .TwoBytes
        cmp.l #11,d0
        blt .ThreeBytes
        cmp.l #10,d0
        bgt .FourBytes
        bra .Error4 ; Unknown Pixelformat
.OneByte:
        move.l #1,rsCGX_Bytes(a3)
        bra .GetMap
.TwoBytes:
        move.l #2,rsCGX_Bytes(a3)
        bra .GetMap
.ThreeBytes:
        move.l #3,rsCGX_Bytes(a3)
        bra .GetMap
.FourBytes:
        move.l #4,rsCGX_Bytes(a3)
.GetMap:
        move.l #0,rsCGX_MapB(a3)
        move.l #0,rsCGX_MapC(a3)

        ;move.l rsCGX_RealMapA(a3),a0
        ;lea rsCGX_Tags(a3),a1
        ;move.l a1,a2
        ;move.l #LBMI_BASEADDRESS,(a2)+
        ;move.l #0,(a2)+
        ;move.l #0,(a2)+
        ;move.l #0,(a2)
        ;move.l a6,-(sp)
        ;move.l CGXBase,a6
        ;jsr -168(a6) ; LockBitMapTagList
        ;move.l d0,a0
        ;cmp.l #0,d0
        ;beq .Error4
        ;lea rsCGX_Tags(a3),a1
        ;move.l 4(a1),d0
        ;move.l d0,rsCGX_MapA(a3)
        ;move.l d0,d7
        ;jsr -174(a6) ; UnLockBitmap
        ;move.l (sp)+,a6

        lea Hook,a0
        move.l rsCGX_MyScreen(a3),a1
        lea sc_RastPort(a1),a1
        move.l #0,a2
        move.l a6,-(sp)
        move.l CGXBase,a6
        jsr -156(a6) ; DoCDrawMethodTagList
        move.l (sp)+,a6
        move.l d7,rsCGX_MapA(a3)

        move.l d7,rsCGX_FrontMap(a3)
        cmp.l #1,d4
        beq .OnlyOne
        move.l rsCGX_Width(a3),d0
        clr.l d1
        move.w rsCGX_Height(a3),d1
        cmp.l #2,d4
        beq .Zwoo
        divu #3,d1
        bra .Go
.Zwoo:
        divu #2,d1
.Go:
        move.w d1,rsCGX_Height(a3)
        mulu d1,d0
        add.l d0,d7
        move.l d7,rsCGX_MapB(a3)
        cmp.l #2,d4
        beq .OnlyOne
        move.l rsCGX_Width(a3),d0
        mulu d1,d0
        add.l d0,d7
        move.l d7,rsCGX_MapC(a3)
.OnlyOne:
        move.l a3,d0
        clr.l d1
        clr.l d2
        move.w rsCGX_Height(a3),d1
        move.l d1,d2
        move.l #0,rsCGX_OffA(a3)
        move.l d1,rsCGX_OffB(a3)
        add.l d2,d1
        cmp.l #2,d4
        beq .SaveMap2
        move.l d1,rsCGX_OffC(a3)
.SaveMap2:
        movem.l (sp)+,d3-d7/a2-a6
        rts
.Exit:
        move.l #0,d0
        movem.l (sp)+,d3-d7/a2-a6
        rts
.Error1:
        tst.l (sp)+
.Raus:
        movem.l (sp)+,d3-d7/a2-a6
        move.l #0,d0
        rts
.Error2:
        move.l $4,a6
        move.l a3,a1
        move.l #rsCGX_SIZEOF,d0
        CALLSYS FreeMem
        bra .Error1
.Error3:
        move.l $4,a6
        move.l d7,a1
        move.l #136,d0
        CALLSYS FreeMem
        bra .Error2
.Error4:
        move.l rsCGX_MyScreen(a3),a0
        move.l IntBase,a6
        jsr -66(a6)
        bra .Error2
Hook:
        dc.l 0,0,HookFunc,0,0
HookFunc:
        movem.l d0-d6,-(sp)
        move.l (a1),d7 ; Address
        move.l 4(a1),d1 ; X-Offset
        move.l 8(a1),d2 ; Y-Offset
        clr.l d3
        clr.l d4
        move.w 20(a1),d3 ; BytesPerRow
        move.w 22(a1),d4 ; BytesPerPixel
        clr.l d6
        mulu d4,d1
        add.l d1,d6
        mulu d2,d3
        add.l d3,d6
        ror.l #2,d6
        add.l d6,d7
        movem.l (sp)+,d0-d6
        rts

GetRtgScreenData:
    Move.l  a0,a2
    Move.l  a1,a3
    Move.l  rsCGX_MyScreen(a2),a4
    move.l  a6,a5
    Move.l  UtilityBase,a6
    Move.l  #grd_Width,d0
    Move.l  a3,a0
    Jsr     -30(a6) Utility - FindTagItem
    Tst.l   d0
    Beq.s   .NoWidth
    move.l d0,a1
    move.l rsCGX_RealMapA(a4),a0
    move.l #CYBRMATTR_WIDTH,d1
    move.l CGXBase,a6
    move.l a1,-(sp)
    jsr -96(a6); GetCyberMapAttr
    move.l (sp)+,a1
    move.l UtilityBase,a6
    move.l d0,ti_Data(a1)
.NoWidth
    Move.l  #grd_Height,d0
    Move.l  a3,a0
    Jsr     -30(a6) Utility - FindTagItem
    Tst.l   d0
    Beq.s   .NoHeight
    move.l d0,a1
    move.l rsCGX_RealMapA(a4),a0
    move.l #CYBRMATTR_HEIGHT,d1
    move.l CGXBase,a6
    move.l a1,-(sp)
    jsr -96(a6); GetCyberMapAttr
    move.l (sp)+,a1
    move.l UtilityBase,a6
    move.l d0,ti_Data(a1)
.NoHeight
    Move.l  #grd_PixelLayout,d0
    Move.l  a3,a0
    Jsr     -30(a6) Utility - FindTagItem
    Tst.l   d0
    Beq   .NoPixelLayout
    move.l d0,a1
    move.l rsCGX_RealMapA(a4),a0
    move.l #CYBRMATTR_PIXFMT,d1
    move.l CGXBase,a6
    move.l a1,-(sp)
    jsr -96(a6) ; GetCyberMapAttr
    move.l (sp)+,a1
    move.l UtilityBase,a6
    cmp.l #0,d0
    beq .FmtChunky
    cmp.l #5,d0
    blt .FmtHi15
    cmp.l #9,d0
    blt .FmtHi16
    cmp.l #11,d0
    blt .FmtTrue24
    cmp.l #11,d0
    beq .FmtTrue32B
    cmp.l #12,d0
    beq .FmtTrue32
    cmp.l #13,d0
    beq .FmtTrue32
    bra .NoPixelLayout ; Unsupported Pixellayout
.FmtChunky:
    move.l #grd_CHUNKY,d0
    bra .ValueReturn
.FmtHi15:
    move.l #grd_HICOL15,d0
    bra .ValueReturn
.FmtHi16:
    move.l #grd_HICOL16,d0
    bra .ValueReturn
.FmtTrue24:
    move.l #grd_TRUECOL24,d0
    bra .ValueReturn
.FmtTrue32:
    move.l #grd_TRUECOL32,d0
    bra .ValueReturn
.FmtTrue32B:
    move.l #grd_TRUECOL32B,d0
    bra .ValueReturn
.ValueReturn:
    move.l d0,ti_Data(a1)
.NoPixelLayout
    Move.l  #grd_ColorSpace,d0
    Move.l  a3,a0
    Jsr     -30(a6) Utility - FindTagItem
    Tst.l   d0
    Beq   .NoColorSpace
    move.l d0,a1
    move.l rsCGX_RealMapA(a4),a0
    move.l #CYBRMATTR_PIXFMT,d1
    move.l CGXBase,a6
    move.l a1,-(sp)
    jsr -96(a6) ; GetCyberMapAttr
    move.l (sp)+,a1
    move.l UtilityBase,a6
    cmp.l #0,d0
    beq .FmtPalette
    cmp.l #1,d0
    beq .FmtRGB
    cmp.l #5,d0
    beq .FmtRGB
    cmp.l #9,d0
    beq .FmtRGB
    cmp.l #11,d0
    beq .FmtRGB
    cmp.l #2,d0
    beq .FmtBGR
    cmp.l #6,d0
    beq .FmtBGR
    cmp.l #10,d0
    beq .FmtBGR
    cmp.l #12,d0
    beq .FmtBGR
    cmp.l #3,d0
    beq .FmtRGBPC
    cmp.l #7,d0
    beq .FmtRGBPC
    cmp.l #4,d0
    beq .FmtBGRPC
    cmp.l #8,d0
    beq .FmtBGRPC
    cmp.l #13,d0
    beq .FmtRGB
    bra .NoColorSpace ; Unknown Format
.FmtPalette
    move.l #grd_Palette,d0
    bra .ReturnValue
.FmtRGB
    move.l #grd_RGB,d0
    bra .ReturnValue
.FmtBGR
    move.l #grd_BGR,d0
    bra .ReturnValue
.FmtRGBPC
    move.l #grd_RGBPC,d0
    bra .ReturnValue
.FmtBGRPC
    move.l #grd_BGRPC,d0
    bra .ReturnValue
.ReturnValue
    move.l d0,ti_Data(a1)
.NoColorSpace
    Move.l  #grd_Depth,d0
    Move.l  a3,a0
    Jsr     -30(a6) Utility - FindTagItem
    Tst.l   d0
    Beq.s   .NoDepth
    move.l d0,a1
    move.l rsCGX_RealMapA(a4),a0
    move.l #CYBRMATTR_DEPTH,d1
    move.l CGXBase,a6
    move.l a1,-(sp)
    jsr -96(a6); GetCyberMapAttr
    move.l (sp)+,a1
    move.l UtilityBase,a6
    move.l d0,ti_Data(a1)
.NoDepth
    Move.l  #grd_Buffers,d0
    Move.l  a3,a0
    Jsr     -30(a6) Utility - FindTagItem
    Tst.l   d0
    Beq.s   .NoBuffers
    move.l d0,a1
    move.l rsCGX_NumBuf(a4),d0
    move.l d0,ti_Data(a1)
.NoBuffers
    Movem.l (sp)+,a2-a5/a6
    rts

BlitRtg:
    movem.l d6-d7/a3/a6,-(sp)
    move.l a0,a3
    move.l rsCGX_RealMapA(a0),a1
    move.l a1,a0
    move.l #0,a2
    cmp.l #0,d6
    beq .Weiter
    cmp.l #1,d6
    beq .Buffer1Src
    bra .Buffer2Src
.Buffer1Src:
    movem.l d4/d5,-(sp)
    move.l rsCGX_Width(a3),d4
    clr.l d4
    clr.l d5
    move.w rsCGX_Height(a3),d5
    mulu d5,d4
    add.l d4,d1
    movem.l (sp)+,d4/d5
    bra .Weiter
.Buffer2Src:
    movem.l d4/d5,-(sp)
    move.l rsCGX_Width(a3),d4
    clr.l d4
    clr.l d5
    move.w rsCGX_Height(a3),d5
    mulu d5,d4
    add.l d4,d1
    add.l d4,d1
    movem.l (sp)+,d4/d5
.Weiter:
    clr.l d6
    cmp.l #0,d7
    beq .WeiterD
    cmp.l #1,d7
    beq .Buffer1Dest
    bra .Buffer2Dest
.Buffer1Dest:
    movem.l d4/d5,-(sp)
    move.l rsCGX_Width(a3),d4
    clr.l d4
    clr.l d5
    move.w rsCGX_Height(a3),d5
    mulu d5,d4
    add.l d4,d3
    movem.l (sp)+,d4/d5
    bra .WeiterD
.Buffer2Dest:
    movem.l d4/d5,-(sp)
    move.l rsCGX_Width(a3),d4
    clr.l d4
    clr.l d5
    move.w rsCGX_Height(a3),d5
    mulu d5,d4
    add.l d4,d3
    add.l d4,d3
    movem.l (sp)+,d4/d5
.WeiterD:
    clr.l d7
    move.b #$C0,d6
    move.b #$FF,d7
    move.l GfxBase,a6
    jsr -30(a6) ; BltBitMap
    jsr -228(a6) ; WaitBlit
    movem.l (sp)+,d6-d7/a3/a6
    rts

STRUCTURE CyberModeNode,0
 STRUCT  cmn_Node,LN_SIZE
 STRUCT  cmn_ModeText,DISPLAYNAMELEN ; Screenmodename
 ULONG   cmn_DisplayID ; ModeID
 UWORD   cmn_Width ; Width
 UWORD   cmn_Height ; Height
 UWORD   cmn_Depth ; Depth
 APTR    cmn_DisplayTagList ; Ignore this at the moment
LABEL   cmn_SIZEOF

CloseRtgScreen:
      movem.l a6,-(sp)
      move.l IntBase,a6
      move.l rsCGX_MyScreen(a0),d0
      beq .ScreenClosed
      move.l d0,a0
      jsr -66(a6)
.ScreenClosed:
      movem.l (sp)+,a6
      rts

ScreenAtFront:
    Move.l  IntBase,a1
    Move.l  60(a1),d0
    Cmp.l   rsCGX_MyScreen(a0),d0
    Beq.s   .AtFront
    Moveq   #0,d0
    Rts
.AtFront
    Moveq   #-1,d0
    Rts

CloseLibs:
      cmp.l #0,CGXBase
      beq .Exit
      move.l $4,a6
      move.l CGXBase,a1
      CALLSYS CloseLibrary
.Exit:
      move.l #0,d0
      rts

LockRtgScreen:
      add.w #1,rsCGX_Locks(a0)
      move.l rsCGX_MapA(a0),d0
      rts

UnlockRtgScreen:

    clr.l d0
    move.w rsCGX_Locks(a0),d0
    cmp.w #0,d0
    beq .Exit
    subq.w #1,rsCGX_Locks(a0)
.Exit
    rts

LoadRGBRtg:

        Movem.l d2-d5/a2-a3/a6,-(sp)

        Move.l  GfxBase(a6),a6
        Move.l  rsCGX_MyScreen(a0),a2
        Lea     44(a2),a2
        Move.l  a1,a3
.Loop2  Move.w  (a3)+,d4
        Beq.s   .Exit
        Move.w  (a3)+,d5
        Bra.s   .Wend

.Loop   Move.l  a2,a0
        Move.w  d5,d0
        Addq.w  #1,d5
        Move.l  (a3)+,d1
        Move.l  (a3)+,d2
        Move.l  (a3)+,d3
        Jsr     -852(a6)        Graphics - SetRGB32
.Wend   Dbra    d4,.Loop
        Bra.s   .Loop2
.Exit   Movem.l (sp)+,d2-d5/a2-a3/a6
        Rts

GetScreenmodes:
    move.l a6,-(sp)
    move.l CGXBase,a6
    lea tags,a1
    jsr -72(a1) ; AllocCModeListTagList
    move.l (sp)+,a6
    rts
tags:
    dc.l CYBRMREQ_MinWidth,MinWidth
    dc.l CYBRMREQ_MaxWidth,MaxWidth
    dc.l CYBRMREQ_MinHeight,MinHeight
    dc.l CYBRMREQ_MaxHeight,MaxHeight
    dc.l CYBRMREQ_MinDepth,MinDepth
    dc.l CYBRMREQ_MaxDepth,MaxDepth


FreeScreenmodes:
 move.l a6,-(sp)
 move.l CGXBase,a6
 move.l Modes,a0
 jsr -78(a6) ; FreeCModeList
 move.l (sp)+,a6
 rts

GetBufAdr:
        Lsl.w   #2,d0
        Move.l  rsCGX_MapA(a0,d0.w),d0
        Rts
