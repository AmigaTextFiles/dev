#ifndef MODULES_BLTBASE_H
#define MODULES_BLTBASE_H

/*
**  $VER: bltbase.h V1.0
**
**  Definition of the BLTBase structure for making calls to the blitter
**  module.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

/*****************************************************************************
** BLTBase structure.
*/

typedef struct BLTBase {
  LIBPTR APTR (*AllocBlitMem)(mreg(__d0) LONG Size, mreg(__d1) LONG Flags);
  LIBPTR void (*DrawRGBPixel)(mreg(__a0) struct Bitmap *, mreg(__d1) WORD XCoord, mreg(__d2) WORD YCoord, mreg(__d3) LONG RGB);
  LIBPTR void (*SortBobList)(mreg(__a0) APTR List, mreg(__d0) LONG Flags);
  LIBPTR void (*SortMBob)(mreg(__a0) struct MBob *, mreg(__d0) LONG Flags);
  LIBPTR void (*CopyBuffer)(mreg(__a0) struct GScreen *, mreg(__d0) WORD SrcBuffer, mreg(__d1) WORD DestBuffer);
  LIBPTR LONG (*CreateMasks)(mreg(__a1) APTR Bob);
  LIBPTR void (*DrawBob)(mreg(__a1) APTR Bob);
  LIBPTR void (*DrawBobList)(mreg(__a1) LONG *BobList);
  LIBPTR void (*DrawLine)(mreg(__a0) struct Bitmap *, mreg(__d1) WORD SX, mreg(__d2) WORD SY, mreg(__d3) WORD EX, mreg(__d4) WORD EY, mreg(__d5) LONG Colour, mreg(__d6) LONG Mask);
  LIBPTR void (*DrawPixel)(mreg(__a0) struct Bitmap *, mreg(__d1) WORD XCoord, mreg(__d2) WORD YCoord, mreg(__d3) LONG Colour);
  LIBPTR void (*DrawPixelList)(mreg(__a0) struct Bitmap *, mreg(__a1) struct PixelList *);
  LIBPTR void (*DrawUCLine)(mreg(__a0) struct Bitmap *, mreg(__d1) WORD SX, mreg(__d2) WORD SY, mreg(__d3) WORD EX, mreg(__d4) WORD EY, mreg(__d5) LONG Colour, mreg(__d6) LONG Mask);
  LIBPTR void (*DrawUCPixelList)(mreg(__a0) struct Bitmap *, mreg(__a1) struct PixelList *);
  LIBPTR void (*DrawUCPixel)(mreg(__a0) struct Bitmap *, mreg(__d1) WORD XCoord, mreg(__d2) WORD YCoord, mreg(__d3) LONG Colour);
  LIBPTR void (*FreeBlitMem)(mreg(__d0) APTR MemBlock);
  LIBPTR void (*DrawUCRGBPixel)(mreg(__a0) struct Bitmap *, mreg(__d1) WORD XCoord, mreg(__d2) WORD YCoord, mreg(__d3) LONG RGB);
  LIBPTR LONG (*ReadPixel)(mreg(__a0) struct Bitmap *, mreg(__d0) WORD XCoord, mreg(__d1) WORD YCoord);
  LIBPTR void (*ReadPixelList)(mreg(__a0) struct Bitmap *, mreg(__a1) struct PixelList *);
  LIBPTR void (*SetBobDimensions)(mreg(__a0) APTR Bob, mreg(__d0) WORD Width, mreg(__d1) WORD Height, mreg(__d2) WORD Depth);
  LIBPTR LONG (*SetBobDrawMode)(mreg(__a0) APTR Bob, mreg(__d0) LONG Attrib);
  LIBPTR LONG (*SetBobFrames)(mreg(__a0) APTR Bob);
  LIBPTR void (*TakeOSBlitter)(void);
  LIBPTR void (*GiveOSBlitter)(void);
  LIBPTR LONG (*ReadRGBPixel)(mreg(__a0) struct Bitmap *, mreg(__d1) WORD XCoord, mreg(__d2) WORD YCoord);
  LIBPTR void (*DrawRGBLine)(mreg(__a0) struct Bitmap *, mreg(__d1) WORD SX, mreg(__d2) WORD SY, mreg(__d3) WORD EX, mreg(__d4) WORD EY, mreg(__d5) LONG RGB, mreg(__d6) LONG Mask);
  LIBPTR void (*DrawUCRGBLine)(mreg(__a0) struct Bitmap *, mreg(__d1) WORD SX, mreg(__d2) WORD SY, mreg(__d3) WORD EX, mreg(__d4) WORD EY, mreg(__d5) LONG RGB, mreg(__d6) LONG Mask);
  LIBPTR void (*DrawRGBPixelList)(mreg(__a0) struct Bitmap *, mreg(__a1) struct PixelList *);
  LIBPTR LONG (*GetBmpType)(void);
  LIBPTR LONG (*CopyPalette)(mreg(__a0) LONG *SrcPalette, mreg(__a1) LONG *DestPalette, mreg(__d0) LONG ColStart, mreg(__d1) LONG AmtColours, mreg(__d2) LONG DestCol);
} OBJ_BLTBASE;

#endif /* MODULES_BLTBASE_H */
