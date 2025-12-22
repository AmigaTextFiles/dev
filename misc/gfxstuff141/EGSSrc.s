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
      move.l #0,EgsBase
      lea EgsName,a1
      moveq #6,d0
      move.l $4,a6
      CALLSYS OpenLibrary
      cmp.l #0,d0
      beq .Exit
      move.l d0,EgsBase
      move.l EgsBase,a6
      CALLSYS E_LockEGSVideo
      CALLSYS E_GetHardInfo
      move.l d0,a3
      CALLSYS E_UnlockEGSVideo
      move.l #1,d0
      move.l ehi_Drivers(a3),a0
      lea edd_Node(a0),a0
      move.l LN_SUCC(a0),a0
      cmp.l #0,LN_SUCC(a0)
      beq .Exit
      cmp.l #1,d0
      bne.s .LookRB3a
      move.l LN_NAME(a0),a1
      cmp.l #'PICO',(a1)
      bne.s .LookRB3a
      bsr .Found
.LookRB3a:
      cmp.l #1,d0
      bne.s .LookRB3b
      move.l LN_NAME(a0),a1
      cmp.l #'RB3a',(a1)
      bne.s .LookRB3b
      bsr .Found
.LookRB3b:
      cmp.l #1,d0
      bne.s .LookA2410
      move.l LN_NAME(a0),a1
      cmp.l #'RB3b',(a1)
      bne.s .LookA2410
      bsr .Found
.LookA2410:
      cmp.l #1,d0
      bne.s .LookRB2a
      move.l LN_NAME(a0),a1
      cmp.l #'A241',(a1)
      bne.s .LookRB2a
      bsr .Found
.LookRB2a:
      cmp.l #1,d0
      bne.s .LookRB2b
      move.l LN_NAME(a0),a1
      cmp.l #'RB2a',(a1)
      bne.s .LookRB2b
      bsr .Found
.LookRB2b:
      cmp.l #1,d0
      bne.s .LookG110
      move.l LN_NAME(a0),a1
      cmp.l #'RB2b',(a1)
      bne.s .LookG110
      bsr .Found
.LookG110:
      cmp.l #1,d0
      bne.s .LookGVP
      move.l LN_NAME(a0),a1
      cmp.l #'G110',(a1)
      bne.s .LookGVP
      bsr .Found
.LookGVP:
      cmp.l #1,d0
      bne.s .LookLoop
      move.l LN_NAME(a0),a1
      cmp.l #'LEGS',(a1)
      bne.s .LookLoop
      bsr .Found
.LookLoop:
      cmp.l #0,d0
      beq .QuitLoop
      cmp.l #0,LN_SUCC(a0)
      beq .Exit
      lea edd_Node(a0),a0
      move.l LN_SUCC(a0),a0
      cmp.l #1,d0
      bne.s .SearchRB3a
      move.l LN_NAME(a0),a1
      cmp.l #'PICO',(a1)
      bne.s .SearchRB3a
      bsr .Found
.SearchRB3a:
      cmp.l #1,d0
      bne.s .SearchRB3b
      move.l LN_NAME(a0),a1
      cmp.l #'RB3a',(a1)
      bne.s .SearchRB3b
      bsr .Found
.SearchRB3b:
      cmp.l #1,d0
      bne.s .SearchA2410
      move.l LN_NAME(a0),a1
      cmp.l #'RB3b',(a1)
      bne.s .SearchA2410
      bsr.s .Found
.SearchA2410:
      cmp.l #1,d0
      bne.s .SearchRB2a
      move.l LN_NAME(a0),a1
      cmp.l #'A241',(a1)
      bne.s .SearchRB2a
      bsr .Found
.SearchRB2a:
      cmp.l #1,d0
      bne.s .SearchRB2b
      move.l LN_NAME(a0),a1
      cmp.l #'RB2a',(a1)
      bne.s .SearchRB2b
      bsr .Found
.SearchRB2b:
      cmp.l #1,d0
      bne.s .SearchG110
      move.l LN_NAME(a0),a1
      cmp.l #'RB2b',(a1)
      bne.s .SearchG110
      bsr .Found
.SearchG110:
      cmp.l #1,d0
      bne.s .SearchGVP
      move.l LN_NAME(a0),a1
      cmp.l #'G110',(a1)
      bne.s .SearchGVP
      bsr.s .Found
.SearchGVP:
      cmp.l #1,d0
      bne .LookLoop
      move.l LN_NAME(a0),a1
      cmp.l #'LEGS',(a1)
      bne .LookLoop
      bsr.s .Found
      bra .LookLoop
.Found:
      move.l #0,d0
      rts
.QuitLoop:
      movem.l (sp)+,a0-a6/d0-d7
      move.l #1,d0
      rts
.Exit:
      movem.l (sp)+,a0-a6/d0-d7
.CloseEGS:
      move.l $4,a6
      move.l EgsBase,a1
      CALLSYS CloseLibrary
      move.l #0,d0
      rts
EgsBase: dc.l 0
EgsName: dc.b 'egs.library',0

GetScreenmodes:
      movem.l a3/a6,-(sp)
      move.l EgsBase,a6
      CALLSYS E_LockEGSVideo
      CALLSYS E_GetHardInfo
      move.l d0,a3
      CALLSYS E_UnlockEGSVideo
      move.l ehi_Modes(a3),d0
      movem.l (sp)+,a3/a6
      rts

FreeScreenmodes:
      rts

CloseLibs:
      cmp.l #0,EgsBase
      beq .Exit
      move.l $4,a6
.CloseEGS:
      move.l $4,a6
      move.l EgsBase,a1
      CALLSYS CloseLibrary
.Exit:
      move.l #0,d0
      rts

STRUCTURE  E_ScreenMode,0
 STRUCT  esm_Node,LN_SIZE ; in esmNode.ln_Name you will find the name of the Screenmode
 UWORD   esm_Horiz ; Horizontal resolution
 UWORD   esm_Vert ; Vertical resolution
 UWORD   esm_Pad
 ULONG   esm_Depths ; Color depths (this code supports 1, 8 and 24 Bit)
 APTR    esm_Driver ; Some infos, that you probably not need :)
 STRUCT  esm_Specs,24*4 ; More things that you probably do not need...
LABEL   esm_SIZEOF

STRUCTURE RtgScreenEGS,0
 APTR   rsEGS_MyScreen  ; The EGS Screen handle
 ULONG  rsEGS_ActiveMap ; The Buffer number of the active Buffer
 APTR   rsEGS_MapA      ; Buffer 0 E_EBitmap
 APTR   rsEGS_MapB      ; Buffer 1 E_EBitmap
 APTR   rsEGS_MapC      ; Buffer 2 E_EBitmap
 APTR   rsEGS_FrontMap  ; Buffer address of Buffer rsEGS_ActiveMap
 ULONG  rsEGS_Bytes     ; 0 = 1 Bit, 1 = 8 Bit, 4 = 24 Bit
 ULONG  rsEGS_Width     ; Width of the RtgScreen for fast access on it
 ULONG  rsEGS_NumBuf    ; Number of Buffers of this RtgScreens
 UWORD  rsEGS_Locks     ; The Screen Lock Word
LABEL rsEGS_SIZEOF

STRUCTURE ScreenQuery,0
 ULONG sq_ScreenMode ; Pointer to the *NAME* of the wanted Screenmode
 UWORD sq_Width      ; The Width
 UWORD sq_Height     ; The Height
 UWORD sq_Depth      ; The color depth
 ULONG sq_Buffers    ; How many Buffers...
 ULONG sq_Port       ; An eDCMP Messageport (if not used 0)
 ULONG sq_EdcmpFlags ; The used Edcmp-Flags of the Screen (if no eDCMP : 0)
LABEL sq_SIZEOF

CloseRtgScreen:
      movem.l a2/a3/a6,-(sp)
      move.l a0,a3
      move.l rsEGS_ActiveMap(a0),d0
      cmp.l #0,d0
      beq.s .NoFlip
      move.l rsEGS_MyScreen(a0),a0
      move.l EgsBase,a6
      CALLSYS E_WaitTOF
      move.l a3,a0
      move.l rsEGS_MapA(a0),a1
      move.l rsEGS_MyScreen(a0),a0
      CALLSYS E_FlipMap
.NoFlip:
      move.l EgsBase,a6
      move.l rsEGS_MyScreen(a3),a0
      CALLSYS E_CloseScreen
      move.l rsEGS_MapB(a3),a0
      cmp.l #0,a0
      beq.s .NoB
      CALLSYS E_DisposeBitMap
.NoB:
      move.l rsEGS_MapC(a3),a0
      cmp.l #0,a0
      beq.s .NoC
      CALLSYS E_DisposeBitMap
.NoC:
      move.l $4,a6
      move.l a3,a1
      move.l #rsEGS_SIZEOF,d0
      CALLSYS FreeMem
      movem.l (sp)+,a2/a3/a6
      rts

RtgScreenAtFront:
    movem.l a4-a6,-(sp)
    move.l a6,a5
    move.l EgsBase(a5),a6
    move.l rsEGS_MyScreen(a0),a0
    move.l a0,a4
    CALLSYS E_WhichMonitor
    move.l d0,a0
    CALLSYS E_WhichScreen
    move.l #0,d1
    cmp.l a4,d0
    bne .Not
    move.l #$ffffffff,d1
.Not:
    move.l d1,d0
    movem.l (sp)+,a4-a6
    rts

GetRtgScreenData:
    movem.l a2-a6,-(sp)
    move.l a1,a4
    cmp.l #0,a0
    beq .Exit
    cmp.l #0,a1
    beq .Exit
    move.l a0,a3
    move.l a1,a0
    move.l #grd_Buffers,d0
    move.l UtilityBase,a6
    CALLSYS FindTagItem
    cmp.l #0,d0
    beq .NoBuffers
    move.l rsEGS_MapB(a3),d1
    cmp.l #0,d1
    beq .NoB
    move.l rsEGS_MapC(a3),d1
    cmp.l #0,d1
    beq .NoC
    move.l d0,a0
    move.l #3,ti_Data(a0)
    bra .NoBuffers
.NoC:
    move.l d0,a0
    move.l #2,ti_Data(a0)
    bra .NoBuffers
.NoB:
    move.l d0,a0
    move.l #1,ti_Data(a0)
.NoBuffers:
    move.l a4,a0
    move.l #grd_Width,d0
    CALLSYS FindTagItem
    cmp.l #0,d0
    beq .BranchMinWidth
    move.l rsEGS_MyScreen(a3),a0
    move.l esc_Map(a0),a0
    move.l d0,a1
    sub.l d0,d0
    move.w ebm_Width(a0),d0
    ext.l d0
    move.l d0,ti_Data(a1)
.BranchMinWidth:
    move.l a4,a0
    move.l #grd_Height,d0
    CALLSYS FindTagItem
    cmp.l #0,d0
    beq .BranchMinHeight
    move.l rsEGS_MyScreen(a3),a0
    move.l esc_Map(a0),a0
    move.l d0,a1
    move.w ebm_Height(a0),d0
    ext.l d0
    move.l d0,ti_Data(a1)
.BranchMinHeight:
    move.l a4,a0
    move.l #grd_Depth,d0
    CALLSYS FindTagItem
    cmp.l #0,d0
    beq .BranchChunky
    move.l rsEGS_MyScreen(a3),a0
    move.l esc_Map(a0),a0
    sub.l d1,d1
    move.b ebm_Depth(a0),d1
    ext.w d1
    ext.l d1
    move.l d0,a0
    move.l d1,ti_Data(a0)
.BranchChunky:
    move.l a4,a0
    move.l #grd_PixelLayout,d0
    CALLSYS FindTagItem
    cmp.l #0,d0
    beq .BranchColor
    sub.l d1,d1
    move.l rsEGS_MyScreen(a3),a0
    move.l esc_Map(a0),a0
    move.b ebm_Depth(a0),d1
    ext.w d1
    ext.l d1
    cmp.b #1,d1
    beq .TheOne
    cmp.b #8,d1
    beq .TheEight
.The24:
    move.l #grd_TRUECOL32,d1
    move.l d0,a0
    move.l d1,ti_Data(a0)
    bra .BranchColor
.TheEight:
    move.l #grd_CHUNKY,d1
    move.l d0,a0
    move.l d1,ti_Data(a0)
    bra .BranchColor
.TheOne:
    move.l #grd_PLANAR,d1
    move.l d0,a0
    move.l d1,ti_Data(a0)
.BranchColor:
    move.l a4,a0
    move.l #grd_ColorSpace,d0
    CALLSYS FindTagItem
    cmp.l #0,d0
    beq .Exit
    sub.l d1,d1
    move.l rsEGS_MyScreen(a3),a0
    move.l esc_Map(a0),a0
    move.b ebm_Depth(a0),d1
    ext.w d1
    ext.l d1
    cmp.b #1,d1
    beq .TheOne2
    cmp.b #8,d1
    beq .TheEight2
.The242:
    move.l #grd_RGB,d1
    move.l d0,a0
    move.l d1,ti_Data(a0)
    bra .Exit
.TheEight2:
    move.l #grd_Palette,d1
    move.l d0,a0
    move.l d1,ti_Data(a0)
    bra .Exit
.TheOne2:
    move.l #grd_Palette,d1
    move.l d0,a0
    move.l d1,ti_Data(a0)
.Exit:
    move.l a4,a1
    movem.l (sp)+,a2-a6
    rts

UnlockRtgScreen:
      cmp.w #0,rsEGS_Locks(a0)
      beq.s .Exit
      move.l rsEGS_MapA(a0),a1
      sub.b #1,ebm_Lock(a1)
      move.l rsEGS_MapB(a0),a1
      cmp.l #0,a1
      beq .NoB
      sub.b #1,ebm_Lock(a1)
.NoB:
      move.l rsEGS_MapC(a0),a1
      cmp.l #0,a1
      beq .NoC
      sub.b #1,ebm_Lock(a1)
.NoC:
      sub.w #1,rsEGS_Locks(a0)
.Exit:
      rts

LoadRGBRtg:
    movem.l d3-d7/a2-a6,-(sp)
    move.l a6,a5
    cmp.l #4,rsEGS_Bytes(a0)
    beq .Exit
    cmp.l #0,a1
    beq .Exit
.NewStart:
    move.l a0,a3
    move.l rsEGS_Bytes(a0),d0
    cmp.l #0,d0
    beq .OneBit
    cmp.l #1,d0
    beq .OneByte
    bra .Exit
.OneBit:
    clr.l d3
    clr.l d4
    move.w (a1)+,d3
    move.w (a1)+,d4
    cmp.l #0,d3
    beq .Exit
    cmp.l #3,d3
    bge .Exit
    cmp.l #0,d4
    beq .StartZero
    cmp.l #1,d4
    beq .StartOne
    bra .Exit
.StartZero:
    move.l a3,a0
    move.l rsEGS_MyScreen(a0),a0
    move.l #0,d0
    move.l (a1)+,d1
    move.l (a1)+,d2
    move.l (a1)+,d3
    swap d1
    swap d2
    swap d3
    and.l #$ffff,d1
    and.l #$ffff,d2
    and.l #$ffff,d3
    divu #257,d1
    divu #257,d2
    divu #257,d3
    and.l #$ffff,d1
    and.l #$ffff,d2
    and.l #$ffff,d3
    move.l a1,d7
    move.l EgsBase(a5),a6
    CALLSYS E_SetRGB8
    move.l d7,a1
    cmp.l #1,d3
    beq .Exit
.StartOne:
    move.l a3,a0
    move.l rsEGS_MyScreen(a0),a0
    move.l #1,d0
    move.l (a1)+,d1
    move.l (a1)+,d2
    move.l (a1)+,d3
    swap d1
    swap d2
    swap d3
    and.l #$ffff,d1
    and.l #$ffff,d2
    and.l #$ffff,d3
    divu #257,d1
    divu #257,d2
    divu #257,d3
    and.l #$ffff,d1
    and.l #$ffff,d2
    and.l #$ffff,d3
    CALLSYS E_SetRGB8
    bra .Exit
.OneByte:
    move.l a1,a4
    clr.l d1
    clr.l d0
    move.w (a4)+,d1
    cmp.l #0,d1
    beq .Exit
    cmp.l #257,d1
    bge .Exit
    move.w (a4)+,d0
    cmp.l #256,d0
    bge .Exit
    move.l d1,d2
    sub.l #1,d1
    move.l d1,d6
    move.l d0,d5
    move.l EgsBase(a5),a6
.Loop:
    move.l (a4)+,d1
    move.l (a4)+,d2
    move.l (a4)+,d3
    swap d1
    swap d2
    swap d3
    and.l #$ffff,d1
    and.l #$ffff,d2
    and.l #$ffff,d3
    divu #257,d1
    divu #257,d2
    divu #257,d3
    and.l #$ffff,d1
    and.l #$ffff,d2
    and.l #$ffff,d3
    move.l d5,d0
    move.l a3,a0
    move.l rsEGS_MyScreen(a0),a0
    CALLSYS E_SetRGB8
    add.l #1,d5
    dbra d6,.Loop
    move.w (a4),d0
    move.l a4,a1
    move.l a3,a0
    cmp.w #0,d0
    bne .NewStart
.Exit:
    move.l #0,d0
    movem.l (sp)+,d3-d7/a2-a6
    rts

OpenRtgScreen:
      movem.l d2-d7/a2-a6,-(sp)
      cmp.l #0,EgsBase
      beq .Exit
      move.l a2,a4
      move.l sq_Buffers(a4),d4
      cmp.l #0,d4
      beq .Exit
      move.l #3,d0
      cmp.l d0,d4
      bgt .Exit
.BufferDone:
      move.w sq_Depth(a4),d0
      move.w sq_Width,-(sp)
      move.w sq_Height,-(sp)
      cmp.l #24,d0
      beq .TrueColor
      cmp.l #8,d0
      beq .Chunky
      bra .Mask
.TrueColor:
      move.l #E_PIXELMAP,d5
      move.w #24,d6
      bra.s .Continue
.Chunky:
      move.l #E_PIXELMAP,d5
      move.w #8,d6
      bra.s .Continue
.Mask:
      move.l #E_BITPLANEMAP,d5
      move.w #1,d6
.Continue:
      move.l #rsEGS_SIZEOF,d0
      move.l #MEMF_CLEAR,d1
      move.l $4,a6
      CALLSYS AllocMem
      cmp.l #0,d0
      beq .Error1
      move.l d0,a3
      move.l EgsBase,a6
      move.l #ens_SIZEOF,d0
      move.l #MEMF_CLEAR,d1
      move.l $4,a6
      CALLSYS AllocMem
      cmp.l #0,d0
      beq .Error3
      move.l d0,a0
      move.l sq_ScreenMode(a4),a1
      move.l a1,ens_Mode(a0)
      move.w d6,ens_Depth(a0)
      move.w #0,ens_Pad_1(a0)
      move.l #0,ens_Colors(a0)
      move.l #0,ens_Map(a0)
      move.l #0,ens_Flags(a0)
      move.l #0,ens_Flags(a0)
      move.l #0,ens_Mouse(a0)
      move.l sq_EdcmpFlags(a4),d0
      move.l d0,ens_EdcmpFlags(a0)
      move.l sq_Port(a4),d0
      move.l d0,ens_Port(a0)
      move.l EgsBase,a6
      move.l a0,d7
      CALLSYS E_OpenScreen
      cmp.l #0,d0
      beq .Error4
      move.l d0,rsEGS_MyScreen(a3)
      move.l d7,a1
      move.l #ens_SIZEOF,d0
      move.l $4,a6
      CALLSYS FreeMem
      move.l #0,rsEGS_ActiveMap(a3)
      cmp.l #2,d4
      bge.s .DBuff
      move.l #0,rsEGS_MapB(a3)
      move.l #0,rsEGS_MapC(a3)
      tst.l (sp)+
      bra .NoDBuff
.AnotherLabel:
      sub.l d0,d0
      sub.l d1,d1
      move.w (sp)+,d1
      move.w (sp)+,d0
      sub.l d2,d2
      move.w d6,d2
      move.l d5,d3
      move.l #0,d4
      add.l #E_EB_DISPLAYABLE,d4
      add.l #E_EB_BLITABLE,d4
      add.l #E_EB_SWAPABLE,d4
      add.l #E_EB_CLEARMAP,d4
      move.l rsEGS_MyScreen(a3),a0
      move.l esc_Map(a0),a0
      move.l EgsBase,a6
      CALLSYS E_AllocBitMap
      cmp.l #0,d0
      beq .Error5
      move.l d0,rsEGS_MapC(a3)
      move.l d0,a0
      CALLSYS E_ClearBitMap
      bra .NoDBuff
.DBuff:
      move.w (sp)+,d1
      move.w (sp)+,d0
      sub.l d2,d2
      move.w d6,d2
      move.l d5,d3
      move.l d4,-(sp)
      move.l #0,d4
      add.l #E_EB_DISPLAYABLE,d4
      add.l #E_EB_BLITABLE,d4
      add.l #E_EB_SWAPABLE,d4
      add.l #E_EB_CLEARMAP,d4
      move.l rsEGS_MyScreen(a3),a0
      move.l esc_Map(a0),a0
      move.l EgsBase,a6
      move.w d0,-(sp)
      move.w d1,-(sp)
      CALLSYS E_AllocBitMap
      move.w (sp)+,d3
      move.w (sp)+,d2
      move.l (sp)+,d4
      cmp.l #0,d0
      beq .Error5
      move.w d2,-(sp)
      move.w d3,-(sp)
      move.l d0,rsEGS_MapB(a3)
      move.l d0,a0
      CALLSYS E_ClearBitMap
      cmp.l #3,d4
      beq .AnotherLabel
      move.l #0,rsEGS_MapC(a3)
      tst.l (sp)+
.NoDBuff:
      move.l EgsBase,a6
      move.l rsEGS_MyScreen(a3),a0
      move.l esc_Map(a0),a0
      move.l a0,rsEGS_MapA(a3)
      move.l a0,rsEGS_FrontMap(a3)
      CALLSYS E_ClearBitMap
      move.l rsEGS_MapA(a3),a0
      move.w ebm_Width(a0),d0
      ext.l d0
      move.l d0,rsEGS_Width(a3)
      move.b ebm_Depth(a0),d0
      move.l d5,rsEGS_Type(a3)
      cmp.b #8,d0
      beq.s .OneByte
      cmp.b #1,d0
      beq.s .OneBit
      move.l #4,rsEGS_Bytes(a3)
      bra.s .ALabel
.OneBit:
      move.l #0,rsEGS_Bytes(a3)
      bra .ALabel
.NoB:
      move.l rsEGS_MapC(a3),d0
      cmp.l #0,d0
      bne .NoC
      move.l #2,rsEGS_NumBuf(a3)
      bra .SetLock
.NoC:
      move.l #3,rsEGS_NumBuf(a3)
      bra .SetLock
.OneByte:
      move.l #1,rsEGS_Bytes(a3)
.ALabel:
      move.l rsEGS_MapB(a3),d0
      cmp.l #0,d0
      bne .NoB
      move.l #1,rsEGS_NumBuf(a3)
.SetLock:
      move.w #0,rsEGS_Locks(a3)
      move.l a3,d0
      movem.l (sp)+,d2-d7/a2-a6
      rts
.Exit:
      move.l #0,d0
      movem.l (sp)+,d2-d7/a2-a6
      rts
.Error1:
      tst.l (sp)+
.Raus:
      movem.l (sp)+,d2-d7/a2-a6
      move.l #0,d0
      rts
.Error3:
      tst.l (sp)+
      move.l a3,a1
      move.l #rsEGS_SIZEOF,d0
      CALLSYS FreeMem
      move.l (sp)+,a0
      move.l EgsBase,a6
      CALLSYS E_DisposeBitMap
      movem.l (sp)+,d2-d7/a2-a6
      move.l #0,d0
      rts

.Error4:
      tst.l (sp)+
      move.l ens_Map(a4),a0
      move.l EgsBase,a6
      CALLSYS E_DisposeBitMap
      move.l a4,a1
      move.l #ens_SIZEOF,d0
      move.l $4,a6
      CALLSYS FreeMem
      move.l a3,a1
      move.l #rsEGS_SIZEOF,d0
      CALLSYS FreeMem
      movem.l (sp)+,d2-d7/a2-a6
      move.l #0,d0
      rts

.Error5:
      move.l rsEGS_MyScreen(a3),a0
      CALLSYS E_CloseScreen
      move.l rsEGS_MapC(a3),a0
      cmp.l #0,a0
      beq .Error6
      CALLSYS E_DisposeBitMap
.Error6:
      move.l a3,a1
      move.l #rsEGS_SIZEOF,d0
      move.l $4,a6
      CALLSYS FreeMem
      movem.l (sp)+,d2-d7/a2-a6
      move.l #0,d0
      rts
.Error2:
      tst.l (sp)+
      tst.l (sp)+
      move.l a3,a1
      move.l #rsEGS_SIZEOF,d0
      CALLSYS FreeMem
      movem.l (sp)+,d2-d7/a2-a6
      move.l #0,d0
      rts

SwitchScreens:
      movem.l a2/a3/a6/d7,-(sp)
      cmp.l rsEGS_ActiveMap(a0),d0
      beq .Exit
      move.l rsEGS_NumBuf(a0),d1
      cmp.l d1,d0
      bge .Exit
      cmp.l #0,d0
      beq.s .BufferOK
      cmp.l #1,d0
      beq.s .BufferOK
      cmp.l #2,d0
      bne .Exit
.BufferOK:
      move.l a0,a3
      move.l EgsBase,a6
      move.l rsEGS_MyScreen(a3),a0
      cmp.l #0,d0
      bne.s .NotA
      move.l rsEGS_MapA(a3),a1
      bra .NotC
.NotA:
      cmp.l #1,d0
      bne.s .NotB
      move.l rsEGS_MapB(a3),a1
      bra .NotC
.NotB:
      move.l rsEGS_MapC(a3),a1
.NotC:
      move.l d0,d7
      move.l a1,rsEGS_FrontMap(a3)
      CALLSYS E_FlipMap
      move.l d7,rsEGS_ActiveMap(a3)
.Exit:
      movem.l (sp)+,a2/a3/a6/d7
      rts

GetBufAdr:
      cmp.l #0,d0
      beq.s .MapA
      cmp.l #1,d0
      beq.s .MapB
      move.l rsEGS_MapC(a0),a0
      bra .FindPlane
.MapA:
      move.l rsEGS_MapA(a0),a0
      bra .FindPlane
.MapB:
      move.l rsEGS_MapB(a0),a0
.FindPlane:
      move.l ebm_Plane(a0),d0
      rts

LockRtgScreen:
      movem.l a4/a6,-(sp)
      move.l rsEGS_MapA(a0),a1
      add.b #1,ebm_Lock(a1)
      add.w #1,rsEGS_Locks(a0)
      move.l rsEGS_MapB(a0),a1
      cmp.l #0,a1
      beq.s .NoB
      add.b #1,ebm_Lock(a1)
.NoB:
      move.l rsEGS_MapC(a0),a1
      cmp.l #0,a1
      beq.s .NoC
      add.b #1,ebm_Lock(a1)
.NoC:
      move.l a0,a4
      move.l DosBase,a6
      move.l #5,d1
      jsr -198(a6)
      move.l a4,a0
      movem.l (sp)+,a4/a6
      move.l rsEGS_MapA(a0),a0
      move.l ebm_Plane(a0),d0
      rts

BlitRtg:
    movem.l d6/a3/a6,-(sp)
    move.l a0,a3
    move.l rsEGS_MyScreen(a0),a1
    movem.l d2/d3,-(sp)
    move.l d4,d2
    move.l d5,d3
    movem.l (sp)+,d4/d5
    cmp.l #0,d6
    beq .Buffer0Src
    cmp.l #1,d6
    beq .Buffer1Src
    bra .Buffer2Src
.Buffer0Src:
    move.l rsEGS_MapA(a3),a0
    bra .Weiter
.Buffer1Src:
    move.l rsEGS_MapB(a3),a0
    bra .Weiter
.Buffer2Src:
    move.l rsEGS_MapC(a3),a0
.Weiter:
    move.l #0,d6
    cmp.l #0,d7
    beq .Buffer0Dest
    cmp.l #1,d7
    beq .Buffer1Dest
    bra .Buffer2Dest
.Buffer0Dest:
    move.l rsEGS_MapA(a3),a1
    bra .WeiterD
.Buffer1Dest:
    move.l rsEGS_MapB(a3),a1
    bra .WeiterD
.Buffer2Dest:
    move.l rsEGS_MapC(a3),d1
.WeiterD:    
    move.l EgsBlitBase,a6
    CALLSYS EB_CopyBitMap
    movem.l (sp)+,d6/a3/a6
    rts
