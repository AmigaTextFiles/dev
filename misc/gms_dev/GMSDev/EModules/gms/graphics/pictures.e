/*
**  $VER: pictures.e V1.0
**
**  Picture Object Definitions.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'gms/dpkernel/dpkernel','gms/system/register'
MODULE 'gms/graphics/blitter','gms/files/files'

/****************************************************************************
** The picture structure for loading and depacking of pictures.
*/

CONST VER_PICTURE  = 2,
      TAGS_PICTURE = $FFFB0000 OR ID_PICTURE

OBJECT picture
  head[1]    :ARRAY OF head    /* [00] Standard header structure */        
  bitmap     :PTR TO bitmap    /* [12] Bitmap details */
  options    :LONG             /* [16] Flags like IMG_REMAP */
  source     :PTR TO filename  /* [20] Filename for this picture, if any */
  scrmode    :INT              /* [24] Intended screen mode for picture */
  scrheight  :INT              /* [26] Screen height */
  scrwidth   :INT              /* [28] Screen width */
ENDOBJECT

/***************************************************************************
** Picture Tags.
*/

CONST PCA_BitmapTags = TSTEPIN OR 12,
      PCA_Options    = TLONG OR 16,
      PCA_Source     = TAPTR OR 20,
      PCA_ScrMode    = TWORD OR 24,
      PCA_ScrHeight  = TWORD OR 26,
      PCA_ScrWidth   = TWORD OR 28

/***************************************************************************
** Image Flags.
*/

CONST IMG_RESIZEX   = $00000001,   /* Allow resize on X axis */
      IMG_NOCOMPARE = $00000002,   /* Do not compare palettes */
      IMG_REMAP     = $00000004,   /* Allow remapping */
      IMG_RESIZEY   = $00000008    /* Allow resize on Y axis */

CONST IMG_RESIZE    = IMG_RESIZEX OR IMG_RESIZEY

