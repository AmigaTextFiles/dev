//Converting: ram:gfx.h
//dest: ram:gfx.m
#ifndef	GRAPHICS_GFX_H
#define	GRAPHICS_GFX_H

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#define BITSET	$8000
#define BITCLR	0
#define AGNUS
#ifdef AGNUS
#define TOBB(a)      ((a))
#else
#define TOBB(a)      ((a)>>1)  
#endif
OBJECT Rectangle

    MinX:WORD
MinY:WORD
    MaxX:WORD
MaxY:WORD
ENDOBJECT

OBJECT Rect32

    MinX:LONG
MinY:LONG
    MaxX:LONG
MaxY:LONG
ENDOBJECT

OBJECT Point

    x:WORD
y:WORD
ENDOBJECT 
->#define Point tPoint

  
#define PLANEPTR PTR TO UBYTE

OBJECT BitMap

    BytesPerRow:UWORD
    Rows:UWORD
    Flags:UBYTE
    Depth:UBYTE
    pad:UWORD
    Planes[8]:PLANEPTR
ENDOBJECT


#define RASSIZE(w,h)	((h)* ( ((w)+15)>>3 AND $FFFE))

#define BMB_CLEAR 0
#define BMB_DISPLAYABLE 1
#define BMB_INTERLEAVED 2
#define BMB_STANDARD 3
#define BMB_MINPLANES 4
#define BMF_CLEAR 1<<BMB_CLEAR
#define BMF_DISPLAYABLE 1<<BMB_DISPLAYABLE
#define BMF_INTERLEAVED 1<<BMB_INTERLEAVED
#define BMF_STANDARD 1<<BMB_STANDARD
#define BMF_MINPLANES 1<<BMB_MINPLANES

#define BMA_HEIGHT 0
#define BMA_DEPTH 4
#define BMA_WIDTH 8
#define BMA_FLAGS 12
#endif	
