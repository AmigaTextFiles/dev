;
; ** $VER: rastport.h 39.0 (21.8.91)
; ** Includes Release 40.15
; **
; **
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/types.pb"
XIncludeFile "graphics/gfx.pb"
XIncludeFile "graphics/gels.pb"
XIncludeFile "graphics/layers.pb"

Structure AreaInfo
    *VctrTbl.w      ;  ptr to start of vector table
    *VctrPtr.w      ;  ptr to current vertex
    *FlagTbl.b       ;  ptr to start of vector flag table
    *FlagPtr.b       ;  ptrs to areafill flags
    Count.w      ;  number of vertices in list
    MaxCount.w      ;  AreaMove/Draw will not allow Count>MaxCount
    FirstX.w
    FirstY.w    ;  first point for this polygon
EndStructure

Structure TmpRas

    *RasPtr.b
    Size.l
EndStructure

;  unoptimized for 32bit alignment of pointers
Structure GelsInfo

    sprRsrvd.b       ;  flag of which sprites to reserve from
;      vsprite system
    Flags.b       ;  system use
    *gelHead.VSprite
    *gelTail.VSprite ;  dummy vSprites for list management
    ;  pointer to array of 8 WORDS for sprite available lines
    *nextLine.w
    ;  pointer to array of 8 pointers for color-last-assigned to vSprites
    *lastColor.w
    *collHandler.collTable     ;  addresses of collision routines
    leftmost.w
    rightmost.w
    topmost.w
    bottommost.w
    *firstBlissObj.l
    *lastBlissObj.l    ;  system use only
EndStructure


Structure RastPort
    *Layer.Layer
    *BitMap.BitMap
    *AreaPtrn.w      ;  ptr to areafill pattern
    *TmpRas.TmpRas
    *AreaInfo.AreaInfo
    *GelsInfo.GelsInfo
    Mask.b       ;  write mask for this raster
    FgPen.b       ;  foreground pen for this raster
    BgPen.b       ;  background pen
    AOlPen.b       ;  areafill outline pen
    DrawMode.b       ;  drawing mode for fill, lines, and text
    AreaPtSz.b       ;  2^n words for areafill pattern
    linpatcnt.b       ;  current line drawing pattern preshift
    dummy.b
    Flags.w      ;  miscellaneous control bits
    LinePtrn.w      ;  16 bits for textured lines
    cp_x.w
    cp_y.w      ;  current pen position
    minterms.b[8]
    PenWidth.w
    PenHeight.w
    *Font.TextFont   ;  current font address
    AlgoStyle.b       ;  the algorithmically generated style
    TxFlags.b       ;  text specific flags
    TxHeight.w       ;  text height
    TxWidth.w       ;  text nominal width
    TxBaseline.w       ;  text baseline
    TxSpacing.w       ;  text spacing (per character)
    *RP_User.l
    longreserved.l[2]
    wordreserved.w[7]  ;  used to be a node
    reserved.b[8]      ;  for future use
EndStructure

;  drawing modes
#JAM1     = 0       ;  jam 1 color into raster
#JAM2     = 1       ;  jam 2 colors into raster
#COMPLEMENT  = 2       ;  XOR bits into raster
#INVERSVID   = 4       ;  inverse video for drawing modes

;  these are the flag bits for RastPort flags
#FRST_DOT    = $01      ;  draw the first dot of this line ?
#ONE_DOT     = $02      ;  use one dot mode for drawing lines
#DBUFFER     = $04      ;  flag set when RastPorts
;      are double-buffered

      ;  only used for bobs

#AREAOUTLINE = $08      ;  used by areafiller
#NOCROSSFILL = $20      ;  areafills have no crossovers

;  there is only one style of clipping: raster clipping
;  this preserves the continuity of jaggies regardless of clip window
;  When drawing into a RastPort, if the ptr to ClipRect is nil then there
;  is no clipping done, this is dangerous but useful for speed

