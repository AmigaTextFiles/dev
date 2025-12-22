;
; ** $VER: gfx.h 39.5 (19.3.92)
; ** Includes Release 40.15
; **
; ** general include file for application programs
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/types.pb"

#_BITSET = $8000
#_BITCLR = 0

;#ifdef AGNUS
;#TOBB(a) .l#TOBB(a) .l
;#Else
;#TOBB(a) .l##TOBB(a) .l  ;  convert Chip adr to Bread Board Adr

Structure Rectangle

    MinX.w
    MinY.w
    MaxX.w
    MaxY.w
EndStructure

Structure Rect32

    MinX.l
    MinY.l
    MaxX.l
    MaxY.l
EndStructure

Structure Point
    x.w
    y.w
EndStructure

Structure BitMap
    BytesPerRow.w
    Rows.w
    Flags.b
    Depth.b
    pad.w
    *Planes.l[8]
EndStructure

;typedef *PLANEPTR.b

;  This macro is obsolete as of V39. AllocBitMap() should be used for allocating
;    bitmap data, since it knows about the machine's particular alignment
;    restrictions.
;

;  flags for AllocBitMap, etc.
#BMB_CLEAR = 0
#BMB_DISPLAYABLE = 1
#BMB_INTERLEAVED = 2
#BMB_STANDARD = 3
#BMB_MINPLANES = 4

#BMF_CLEAR = (1 << #BMB_CLEAR)
#BMF_DISPLAYABLE = (1 << #BMB_DISPLAYABLE)
#BMF_INTERLEAVED = (1 << #BMB_INTERLEAVED)
#BMF_STANDARD = (1 << #BMB_STANDARD)
#BMF_MINPLANES = (1 << #BMB_MINPLANES)

;  the following are for GetBitMapAttr()
#BMA_HEIGHT = 0
#BMA_DEPTH = 4
#BMA_WIDTH = 8
#BMA_FLAGS = 12

