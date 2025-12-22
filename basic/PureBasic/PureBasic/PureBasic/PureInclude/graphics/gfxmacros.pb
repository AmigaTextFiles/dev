;
; ** $VER: gfxmacros.h 39.3 (31.5.93)
; ** Includes Release 40.15
; **
; **
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

#IncludeFile <exec/types\h>

#IncludeFile <graphics/RastPort\h>

#ON_DISPLAY = custom\dmacon = #BitSet|DMAF_RASTER
#OFF_DISPLAY = custom\dmacon = #BitClr|DMAF_RASTER
#ON_SPRITE = custom\dmacon = #BitSet|DMAF_SPRITE
#OFF_SPRITE = custom\dmacon = #BitClr|DMAF_SPRITE

#ON_VBLANK = custom\intena = #BitSet|INTF_VERTB
#OFF_VBLANK = custom\intena = #BitClr|INTF_VERTB

#SetDrPt(w,p) = (w)\LinePtrn = p(w)\Flags |= FRST_DOT(w)\linpatcnt=15}
#SetAfPt(w,p,n) = (w)\AreaPtrn = p(w)\AreaPtSz = n}

#SetOPen(w,c) = (w)\AOlPen = c(w)\Flags |= AREAOUTLINE}
#SetWrMsk(w,m) = (w)\Mask = m}

;  the SafeSetxxx macros are backwards (pre V39 graphics) compatible versions
;  using these macros will make your code do the right thing under V39 AND V37
#SafeSetOutlinePen(w,c)   = If (GfxBase\LibNode\lib_Version<39)  (w)\AOlPen = c(w)\Flags |= AREAOUTLINE} Else SetOutli
nePen(w,c) }
#SafeSetWriteMask(w,m) = If (GfxBase\LibNode\lib_Version<39)  (w)\Mask = (m)} Else SetWriteMask(w,m) }

;  synonym for GetOPen for consistency with SetOutlinePen
;  #define GetOutlinePen(rp) GetOPen(rp)

#BNDRYOFF(w) = (w)\Flags &= ~AREAOUTLINE}

#CINIT(c,n)   = UCopperListInit(c,n)
#CMOVE(c,a,b)  = CMove(c,&a,b)CBump(c) }
#CWAIT(c,a,b)  = CWait(c,a,b)CBump(c) }
#CEND(c)  = CWAIT(c,10000,255) }

#DrawCircle(rp,cx,cy,r) = DrawEllipse(rp,cx,cy,r,r)
#AreaCircle(rp,cx,cy,r) = AreaEllipse(rp,cx,cy,r,r)

