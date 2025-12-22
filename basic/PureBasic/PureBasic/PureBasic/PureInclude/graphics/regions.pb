;
; ** $VER: regions.h 39.0 (21.8.91)
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

Structure RegionRectangle
     *Next.RegionRectangle
    *Prev.RegionRectangle
    bounds.Rectangle
EndStructure

Structure Region
    bounds.Rectangle
    *RegionRectangle.RegionRectangle
EndStructure

