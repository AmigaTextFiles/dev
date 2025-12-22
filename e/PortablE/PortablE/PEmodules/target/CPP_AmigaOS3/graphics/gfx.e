/* $VER: gfx.h 39.5 (19.3.1992) */
OPT NATIVE, PREPROCESS
PUBLIC MODULE 'target/graphics/gfx_shared2'
MODULE 'target/exec/types'
{#include <graphics/gfx.h>}
NATIVE {GRAPHICS_GFX_H} CONST


NATIVE {BITSET}	CONST BITSET	= $8000
NATIVE {BITCLR}	CONST BITCLR	= 0

NATIVE {AGNUS} CONST
NATIVE {TOBB} CONST	->TOBB(a)      ((long)(a))

->"OBJECT rectangle" is on-purposely missing from here (it can be found in 'graphics/gfx_shared2')

NATIVE {Rect32} OBJECT rect32
    {MinX}	minx	:VALUE
	{MinY}	miny	:VALUE
    {MaxX}	maxx	:VALUE
	{MaxY}	maxy	:VALUE
ENDOBJECT

->"OBJECT tpoint" is on-purposely missing from here (it can be found in 'graphics/gfx_shared2')

NATIVE {PLANEPTR} CONST

->"OBJECT bitmap" is on-purposely missing from here (it can be found in 'graphics/gfx_shared2')

/* This macro is obsolete as of V39. AllocBitMap() should be used for allocating
   bitmap data, since it knows about the machine's particular alignment
   restrictions.
*/
NATIVE {RASSIZE} CONST	->RASSIZE(w,h)	((ULONG)(h)*( ((ULONG)(w)+15)>>3&0xFFFE))
#define RASSIZE(w,h) Rassize(w,h)
PROC Rassize(w,h) IS h * (Shr(w+15,3) AND $FFFE)

/* flags for AllocBitMap, etc. */
NATIVE {BMB_CLEAR} CONST BMB_CLEAR = 0
NATIVE {BMB_DISPLAYABLE} CONST BMB_DISPLAYABLE = 1
NATIVE {BMB_INTERLEAVED} CONST BMB_INTERLEAVED = 2
NATIVE {BMB_STANDARD} CONST BMB_STANDARD = 3
NATIVE {BMB_MINPLANES} CONST BMB_MINPLANES = 4

NATIVE {BMF_CLEAR} CONST BMF_CLEAR = $1
NATIVE {BMF_DISPLAYABLE} CONST BMF_DISPLAYABLE = $2
NATIVE {BMF_INTERLEAVED} CONST BMF_INTERLEAVED = $4
NATIVE {BMF_STANDARD} CONST BMF_STANDARD = $8
NATIVE {BMF_MINPLANES} CONST BMF_MINPLANES = $10

/* the following are for GetBitMapAttr() */
NATIVE {BMA_HEIGHT} CONST BMA_HEIGHT = 0
NATIVE {BMA_DEPTH} CONST BMA_DEPTH = 4
NATIVE {BMA_WIDTH} CONST BMA_WIDTH = 8
NATIVE {BMA_FLAGS} CONST BMA_FLAGS = 12
