#ifndef  CLIB_COLOURS_PROTOS_H
#define  CLIB_COLOURS_PROTOS_H

/*
**   $VER: colours_protos.h V1.0
**
**   C prototypes.
**
**   (C) Copyright 1998 DreamWorld Productions.
**       All Rights Reserved.
*/

#ifndef _INCLUDE_PRAGMA_COLOURS_LIB_H
#include <pragmas/colours_pragmas.h>
#endif

/*
#ifndef MODULES_COLOURBASE_H
#include <modules/colourbase.h>
#endif
*/

#ifndef _USE_DPKBASE

void BlurArea(struct Bitmap *Bitmap, WORD StartX, WORD StartY, WORD EndX, WORD EndY, WORD Setting);
LONG CalcBrightness(LONG RGB);
LONG ClosestColour(LONG RGB, struct RGBPalette *Palette);
LONG ConvertHSVToRGB(struct HSV *);
void ConvertRGBToHSV(LONG RGB, struct HSV *);
LONG CopyPalette(LONG argSrcPalette, LONG argDestPalette, LONG ColStart, LONG AmtColours, LONG DestCol);
void DarkenArea(struct Bitmap *Bitmap, WORD StartX, WORD StartY, WORD EndX, WORD EndY, WORD Percent);
void DarkenPixel(struct Bitmap *, WORD XCoord, WORD YCoord, WORD Percent);
void LightenArea(struct Bitmap *Bitmap, WORD StartX, WORD StartY, WORD EndX, WORD EndY, WORD Percent);
void LightenPixel(struct Bitmap *, WORD XCoord, WORD YCoord, WORD Percent);
LONG RemapBitmap(LONG Source, LONG Dest, WORD Performance);

#else /*** Definitions for inline library calls ***/

#endif /* _USE_DPKBASE */

#endif /* CLIB_BLITTER_PROTOS_H */
