/* $Id: gfx.h 20142 2003-11-18 18:06:36Z stegerg $ */
OPT NATIVE, PREPROCESS
PUBLIC MODULE 'target/graphics/gfx_shared2'
MODULE 'target/exec/types'
{#include <graphics/gfx.h>}
NATIVE {GRAPHICS_GFX_H} CONST

NATIVE {PLANEPTR} CONST
->"OBJECT tpoint" is on-purposely missing from here (it can be found in 'graphics/gfx_shared2')

NATIVE {BITSET} CONST BITSET = $8000
NATIVE {BITCLR} CONST BITCLR = 0

NATIVE {AGNUS} CONST
NATIVE {TOBB} CONST	->TOBB(x) ((LONG)(x))

->"OBJECT bitmap" is on-purposely missing from here (it can be found in 'graphics/gfx_shared2')

NATIVE {RASSIZE} CONST	->RASSIZE(w,h)   ( (h) * ( ((w)+15) >>3 & 0xFFFE ))
#define RASSIZE(w,h) Rassize(w,h)
PROC Rassize(w,h) IS h * (Shr(w+15,3) AND $FFFE)

->"OBJECT rectangle" is on-purposely missing from here (it can be found in 'graphics/gfx_shared2')

NATIVE {Rect32} OBJECT rect32
    {MinX}	minx	:VALUE
    {MinY}	miny	:VALUE
    {MaxX}	maxx	:VALUE
    {MaxY}	maxy	:VALUE
ENDOBJECT

NATIVE {BMB_CLEAR}            CONST BMB_CLEAR            = 0
NATIVE {BMF_CLEAR}       CONST BMF_CLEAR       = $1
NATIVE {BMB_DISPLAYABLE}      CONST BMB_DISPLAYABLE      = 1
NATIVE {BMF_DISPLAYABLE} CONST BMF_DISPLAYABLE = $2
NATIVE {BMB_INTERLEAVED}      CONST BMB_INTERLEAVED      = 2
NATIVE {BMF_INTERLEAVED} CONST BMF_INTERLEAVED = $4
NATIVE {BMB_STANDARD}         CONST BMB_STANDARD         = 3
NATIVE {BMF_STANDARD}    CONST BMF_STANDARD    = $8
NATIVE {BMB_MINPLANES}        CONST BMB_MINPLANES        = 4
NATIVE {BMF_MINPLANES}   CONST BMF_MINPLANES   = $10


/* Cybergfx flag */
NATIVE {BMB_SPECIALFMT}	     CONST BMB_SPECIALFMT	     = 7
NATIVE {BMF_SPECIALFMT}	CONST BMF_SPECIALFMT	= $80

NATIVE {BMF_HIJACKED}   CONST		->this seems to be defined in newer AROS SDKs, but not AmiDevCpp, so this is a work-around
->CONST BMF_HIJACKED = BMF_SPECIALFMT

NATIVE {BMB_PIXFMT_SHIFTUP} CONST BMB_PIXFMT_SHIFTUP = 24

/* AROS specific flags */
NATIVE {BMB_AROS_HIDD}        CONST BMB_AROS_HIDD        = 8
NATIVE {BMF_AROS_HIDD}	CONST BMF_AROS_HIDD	= $80

NATIVE {BMA_HEIGHT} CONST BMA_HEIGHT = 0
NATIVE {BMA_DEPTH}  CONST BMA_DEPTH  = 4
NATIVE {BMA_WIDTH}  CONST BMA_WIDTH  = 8
NATIVE {BMA_FLAGS}  CONST BMA_FLAGS  = 12
