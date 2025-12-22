;
; ** $VER: clip.h 39.0 (2.12.91)
; ** Includes Release 40.15
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "graphics/gfx.pb"
XIncludeFile "graphics/rastport.pb"  ; Added for compiling !
XIncludeFile "graphics/regions.pb"  ; Added for compiling !
XIncludeFile "graphics/layers.pb"  ; Added for compiling !
XIncludeFile "exec/semaphores.pb"
XIncludeFile "utility/hooks.pb"

Structure Layer
    *front.Layer
    *back.Layer
    *ClipRect.ClipRect  ;  read by roms to find first cliprect
    *rp.RastPort
    bounds.Rectangle
    reserved.b[4]
    priority.w      ;  system use only
    Flags.w      ;  obscured ?, Virtual BitMap?
    *SuperBitMap.BitMap
    *SuperClipRect.ClipRect ;  super bitmap cliprects if VBitMap != 0
      ;  else damage cliprect list for refresh
    *Window.l    ;  reserved for user interface use
    Scroll_X.w
    Scroll_Y.w
    *cr.ClipRect
    *cr2.ClipRect
    *crnew.ClipRect ;  used by dedice
    *SuperSaveClipRects.ClipRect ;  preallocated cr's
    *_cliprects.ClipRect ;  system use during refresh
    *LayerInfo.Layer_Info ;  points to head of the list
    Lock.SignalSemaphore
    *BackFill.Hook
    reserved1.l
    *ClipRegion.Region
    *saveClipRects.Region ;  used to back out when in trouble
    Width.w
    Height.w  ;  system use
    reserved2.b[18]
    ;  this must stay here
    *DamageList.Region    ;  list of rectangles to refresh
;            through
EndStructure


Structure ClipRect
    *_Next.ClipRect     ;  roms used to find next ClipRect
    *prev.ClipRect     ;  Temp use in layers (private)
    *lobs.Layer     ;  Private use for layers
    *BitMap.BitMap     ;  Bitmap for layers private use
    bounds.Rectangle     ;  bounds of cliprect
    *_p1.l      ;  Layers private use!!!
    *_p2.l      ;  Layers private use!!!
    reserved.l      ;  system use (Layers private)
;#ifdef NEWCLIPRECTS_1_1
    Flags.l      ;  Layers private field for cliprects
        ;  that layers allocates...
EndStructure

;  internal cliprect flags
#CR_NEEDS_NO_CONCEALED_RASTERS  = 1
#CR_NEEDS_NO_LAYERBLIT_DAMAGE   = 2

;  defines for code values for getcode
#ISLESSX = 1
#ISLESSY = 2
#ISGRTRX = 4
#ISGRTRY = 8

