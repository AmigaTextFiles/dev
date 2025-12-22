/* $Id: gfxmacros.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/graphics/rastport'
{#include <graphics/gfxmacros.h>}
NATIVE {GRAPHICS_GFXMACROS_H} CONST

/* Some macros which should be functions... */
NATIVE {SetDrPt} PROC	->SetDrPt(w,p) do { (w)->LinePtrn = p; (w)->Flags |= FRST_DOT|0x10; (w)->linpatcnt = 15; } while (0)
PROC SetDrPt(w:PTR TO rastport, p:UINT) IS NATIVE {SetDrPt(} w {,} p {)} ENDNATIVE

NATIVE {SetAfPt} PROC	->SetAfPt(w,p,n) do { (w)->AreaPtrn = p; (w)->AreaPtSz = n; } while (0)
PROC SetAfPt(w:PTR TO rastport, p:PTR TO UINT, n:BYTE) IS NATIVE {SetAfPt(} w {,} p {,} n {)} ENDNATIVE

NATIVE {SetOPen} PROC	->SetOPen(w,c) do { (w)->AOlPen = c; (w)->Flags |= AREAOUTLINE; } while (0)
PROC SetOPen(w:PTR TO rastport, c:BYTE) IS NATIVE {SetOPen(} w {,} c {)} ENDNATIVE

NATIVE {SetAOlPen} PROC	->SetAOlPen(w,p)  SetOutlinePen(w,p)
->Not supported for some reason: PROC SetAOlPen( rp:PTR TO rastport, pen:ULONG ) IS NATIVE {SetAOlPen(} rp {,} pen {)} ENDNATIVE !!ULONG

NATIVE {SetWrMsk} PROC	->SetWrMsk(w,m)   SetWriteMask(w,m)
->Not supported for some reason: PROC SetWrMsk(w:PTR TO rastport, m:UBYTE) IS NATIVE {SetWrMsk(} w {,} m {)} ENDNATIVE

NATIVE {BNDRYOFF} CONST	->BNDRYOFF(w) do { (w)->Flags &= ~AREAOUTLINE; } while (0)
#define BNDRYOFF(w) Bndryoff(w)
PROC Bndryoff(w:PTR TO rastport) IS NATIVE {BNDRYOFF(} w {)} ENDNATIVE


/* Shortcuts */
NATIVE {DrawCircle} PROC	->DrawCircle(rp,cx,cy,r)  DrawEllipse(rp,cx,cy,r,r);
->Not supported for some reason: PROC DrawCircle(rp:PTR TO rastport, cx:VALUE, cy:VALUE, r:VALUE) IS NATIVE {DrawCircle(} rp {,} cx {,} cy {,} r {)} ENDNATIVE
NATIVE {AreaCircle} PROC	->AreaCircle(rp,cx,cy,r)  AreaEllipse(rp,cx,cy,r,r);
->Not supported for some reason: PROC AreaCircle(rp:PTR TO rastport, cx:VALUE, cy:VALUE, r:VALUE) IS NATIVE {AreaCircle(} rp {,} cx {,} cy {,} r {)} ENDNATIVE !!LONG
