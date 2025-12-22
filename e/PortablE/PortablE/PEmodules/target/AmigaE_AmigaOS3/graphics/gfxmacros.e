/* $VER: gfxmacros.h 39.3 (31.5.1993) */
OPT NATIVE, INLINE, PREPROCESS
MODULE 'target/exec/types', 'target/graphics/rastport', 'target/graphics/gfxbase', 'target/hardware/custom', 'target/hardware/dmabits'
MODULE 'target/graphics', 'target/graphics/copper'
{MODULE 'graphics/gfxmacros'}

NATIVE {ON_DISPLAY}	CONST
NATIVE {OFF_DISPLAY}	CONST
NATIVE {ON_SPRITE}	CONST
NATIVE {OFF_SPRITE}	CONST

NATIVE {ON_VBLANK}	CONST
NATIVE {OFF_VBLANK}	CONST

-> These need 'graphics/gfx', 'hardware/custom', 'hardware/dmabits'
#define ON_DISPLAY      PutInt(CUSTOMADDR+DMACON,BITSET OR DMAF_RASTER)
#define OFF_DISPLAY     PutInt(CUSTOMADDR+DMACON,BITCLR OR DMAF_RASTER)
#define ON_SPRITE       PutInt(CUSTOMADDR+DMACON,BITSET OR DMAF_SPRITE)
#define OFF_SPRITE      PutInt(CUSTOMADDR+DMACON,BITCLR OR DMAF_SPRITE)

-> Same, but 'hardware/intbits' instead of 'hardware/dmabits'
#define ON_VBLANK       PutInt(CUSTOMADDR+INTENA,BITSET OR INTF_VERTB)
#define OFF_VBLANK      PutInt(CUSTOMADDR+INTENA,BITCLR OR INTF_VERTB)


NATIVE {SetDrPt} PROC
PROC SetDrPt(w:PTR TO rastport, p:UINT) IS NATIVE {SetDrPt(} w {,} p {)} ENDNATIVE

NATIVE {SetAfPt} PROC
PROC SetAfPt(w:PTR TO rastport, p:PTR TO UINT, n:BYTE) IS NATIVE {SetAfPt(} w {,} p {,} n {)} ENDNATIVE

NATIVE {SetOPen} PROC
PROC SetOPen(w:PTR TO rastport, c:BYTE) IS NATIVE {SetOPen(} w {,} c {)} ENDNATIVE

NATIVE {SetWrMsk} PROC
PROC SetWrMsk(w:PTR TO rastport, m:UBYTE) IS NATIVE {SetWrMsk(} w {,} m {)} ENDNATIVE

/* the SafeSetxxx macros are backwards (pre V39 graphics) compatible versions */
/* using these macros will make your code do the right thing under V39 AND V37 */

NATIVE {SafeSetOutlinePen} PROC
PROC SafeSetOutlinePen(w:PTR TO rastport, c:BYTE) IS NATIVE {SafeSetOutlinePen(} w {,} c {)} ENDNATIVE

NATIVE {SafeSetWriteMask} PROC
PROC SafeSetWriteMask(w:PTR TO rastport, m:UBYTE) IS NATIVE {SafeSetWriteMask(} w {,} m {)} ENDNATIVE

NATIVE {BNDRYOFF} CONST
#define BNDRYOFF(w) Bndryoff(w)
PROC Bndryoff(w:PTR TO rastport) IS NATIVE {BNDRYOFF(} w {)} ENDNATIVE


NATIVE {CINIT} CONST
#define CINIT(c,n) Cinit(c,n)
PROC Cinit(c:PTR TO ucoplist, n:VALUE) IS NATIVE {CINIT(} c {,} n {)} ENDNATIVE

NATIVE {CMOVE} CONST
#define CMOVE(c,a,b) cmove(c,a,b)
PROC cmove(c:PTR TO ucoplist, a:VALUE, b:VALUE) IS NATIVE {CMOVE(} c {,} a {,} b {)} ENDNATIVE
NATIVE {CMOVEA} CONST
#define CMOVEA(c,d,b) cmovea(c,d,b)
PROC cmovea(c:PTR TO ucoplist, d:APTR, b:VALUE) IS NATIVE {CMOVEA(} c {,} d {,} b {)} ENDNATIVE

NATIVE {CWAIT} CONST
#define CWAIT(c,a,b) cwait(c,a,b)
PROC cwait(c:PTR TO ucoplist, a:VALUE, b:VALUE) IS NATIVE {CWAIT(} c {,} a {,} b {)} ENDNATIVE

NATIVE {CEND} CONST
#define CEND(c) Cend(c)
PROC Cend(c:PTR TO ucoplist) IS NATIVE {CEND(} c {)} ENDNATIVE


NATIVE {DrawCircle} PROC
PROC DrawCircle(rp:PTR TO rastport, cx:VALUE, cy:VALUE, r:VALUE) IS NATIVE {DrawCircle(} rp {,} cx {,} cy {,} r {)} ENDNATIVE
NATIVE {AreaCircle} PROC
PROC AreaCircle(rp:PTR TO rastport, cx:VALUE, cy:VALUE, r:VALUE) IS NATIVE {AreaCircle(} rp {,} cx {,} cy {,} r {)} ENDNATIVE
