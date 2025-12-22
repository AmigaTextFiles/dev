#ifndef GRAPHICS_PICTURES_H
#define GRAPHICS_PICTURES_H TRUE

/*
**  $VER: pictures.h
**
**  Picture Definitions.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

/***************************************************************************
** The picture structure for loading and depacking of pictures
*/

#define VER_PICTURE  2
#define TAGS_PICTURE ((ID_SPCTAGS<<16)|ID_PICTURE)

typedef struct Picture {
  struct Head Head;      /* [00] Standard header structure */
  struct Bitmap *Bitmap; /* [12] Bitmap details */
  LONG   Options;        /* [16] Flags like IMG_REMAP */
  APTR   Source;         /* [20] Filename for this picture, if any */
  WORD   ScrMode;        /* [24] Intended screen mode for picture */
  WORD   ScrHeight;      /* [26] Screen height */
  WORD   ScrWidth;       /* [28] Screen width */

  /*** Private flags below ***/

  APTR   prvHeader;      /* Information header */
  APTR   prvPalette;     /* Palette allocation pointer */
  APTR   prvData;        /* */
} OBJ_PICTURE;

/***************************************************************************
** Picture Tags.
*/

#define PCA_BitmapTags (TSTEPIN|12)
#define PCA_Options    (TLONG|16)
#define PCA_Source     (TAPTR|20)
#define PCA_ScrMode    (TWORD|24)
#define PCA_ScrHeight  (TWORD|26)
#define PCA_ScrWidth   (TWORD|28)

/***************************************************************************
** Image Flags.
*/

#define IMG_RESIZEX   0x00000001      /* Allow resize on X axis */
#define IMG_NOCOMPARE 0x00000002      /* Do not compare palettes */
#define IMG_REMAP     0x00000004      /* Allow remapping */
#define IMG_RESIZEY   0x00000008      /* Allow resize on Y axis */
#define IMG_RESIZE    (IMG_RESIZEX|IMG_RESIZEY)

#endif /* GRAPHICS_PICTURES_H */
