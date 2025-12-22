#ifndef	GRAPHICS_GFXMACROS_H
#define	GRAPHICS_GFXMACROS_H

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef  GRAPHICS_RASTPORT_H
MODULE  'graphics/rastport'
#endif
/*
#ifndef  GRAPHICS_H
MODULE  'graphics'
#endif
*/
#define ON_DISPLAY	custom.dmacon := BITSETORDMAF_RASTER
#define OFF_DISPLAY	custom.dmacon := BITCLRORDMAF_RASTER
#define ON_SPRITE	custom.dmacon := BITSETORDMAF_SPRITE
#define OFF_SPRITE	custom.dmacon := BITCLRORDMAF_SPRITE

#define ON_VBLANK	custom.intena := BITSETORINTF_VERTB
#define OFF_VBLANK	custom.intena := BITCLRORINTF_VERTB

#define SetDrPt(w,p)		w.LinePtrn:=p \
								w.Flags|=FRST_DOT \
								w.linpatcnt:=15 
#define SetAfPt(w,p,n)	w.AreaPtrn:=p \
								w.AreaPtSz:=n 

#define SetOPen(w,c)		w.AOlPen:=c ; w.Flags|=AREAOUTLINE 

#define SetWrMsk(w,m)	w.Mask:=m

#define SafeSetOutlinePen(w,c) \
	IF GfxBase.LibNode.Version<39\
		w.AOlPen:=c\
		w.Flags|=AREAOUTLINE\
  ELSE\
    SetOutlinePen(w,c)\
  ENDIF

#define SafeSetWriteMask(w,m) IF GfxBase.LibNode.Version<39 THEN w.Mask:=(m) ELSE SetWriteMask(w,m)

#define GetOutlinePen(rp) GetOPen(rp)
#define BNDRYOFF(w)	w.Flags &= ~AREAOUTLINE
#define CINIT(c,n)	  UCopperListInit(c,n)
#define CMOVE(c,a,b)	 CMove(c,&a,b) ; Bump(c)
#define CWAIT(c,a,b)	 CWait(c,a,b) ; Bump(c)
#define CEND(c)	 CWAIT(c,10000,255)
#define DrawCircle(rp,cx,cy,r)	DrawEllipse(rp,cx,cy,r,r)
#define AreaCircle(rp,cx,cy,r)	AreaEllipse(rp,cx,cy,r,r)

#endif	
