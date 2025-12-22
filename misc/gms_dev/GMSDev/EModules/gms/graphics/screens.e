/*
**  $VER: screens.e
**
**  Screen Definitions.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'gms/dpkernel/dpkernel','gms/graphics/blitter','gms/system/register',
       'gms/system/tasks'

/****************************************************************************
** Screen object. 
*/

CONST VER_SCREEN  = 2,
      TAGS_SCREEN = $FFFB0000 OR ID_SCREEN

OBJECT screen
    head[1]    :ARRAY OF head  /* Standard structure header */
    memptr1    :LONG           /* Ptr to screen 1 */
    memptr2    :LONG           /* Ptr to screen 2 (double buffer) */
    memptr3    :LONG           /* Ptr to screen 3 (triple buffer) */
    link       :LONG           /* Ptr to a linked screen */
    raster     :PTR TO raster  /* Ptr to a rasterlist */
    width      :INT            /* The width of the visible screen */
    height     :INT            /* The height of the visible screen */
    xoffset    :INT            /* Hardware co-ordinate for TOS */
    yoffset    :INT            /* Hardware co-ordinate for LOS */
    bmpxoffset :INT            /* Offset of the horizontal axis */
    bmpyoffset :INT            /* Offset of the vertical axis */
    scrmode    :INT            /* What screen mode is it? */
    empty      :INT            /* Reserved. */
    attrib     :LONG           /* Special Attributes are? */
    prvtask    :PTR TO dpktask /* Private */
    bitmap     :PTR TO bitmap  /* Bitmap */
    switch     :INT            /* Set to switch the buffers */       
ENDOBJECT

CONST BUFFER1 = 12,
      BUFFER2 = 16,
      BUFFER3 = 20

/*** Screen Attributes ***/

CONST SCR_DBLBUFFER    = $00000001,  -> For double buffering 
      SCR_TPLBUFFER    = $00000002,  -> Triple buffering!! 
      SCR_HSCROLL      = $00000008,  -> Gotta set this to do scrolling 
      SCR_VSCROLL      = $00000010,  -> For vertical scrolling 
      SCR_SBUFFER      = $00000040,  -> Creates a scroll buff for up to 100 screens.
      SCR_CENTRE       = $00000080,  -> Centres the screens (sets XOffset/YOffset).
      SCR_BLKBDR       = $00000100,  -> Gives a blackborder on AGA machines 
      SCR_NOSCRBDR     = $00000200   -> For putting sprites in the border 

/*** Screen modes ***/

CONST SM_HIRES   = $0001,     -> High resolution 
      SM_SHIRES  = $0002,     -> Super-High resolution 
      SM_LACED   = $0004,     -> Interlaced 
      SM_LORES   = $0008,     -> Low resolution (default) 
      SM_EXTRAHB = $0010,     -> Extra HalfBrite
      SM_SLACED  = $0020,     -> Super-Laced resolution.
      SM_HAM     = $0040      -> For HAM mode 

/*** Screen tags ***/

CONST GSA_MemPtr1    = 12 OR TAPTR,
      GSA_MemPtr2    = 16 OR TAPTR,
      GSA_MemPtr3    = 20 OR TAPTR,
      GSA_Raster     = 28 OR TAPTR,
      GSA_Width      = 32 OR TWORD,
      GSA_Height     = 34 OR TWORD,
      GSA_XOffset    = 36 OR TWORD,
      GSA_YOffset    = 38 OR TWORD,
      GSA_BmpXOffset = 40 OR TWORD,
      GSA_BmpYOffset = 42 OR TWORD,
      GSA_ScrMode    = 44 OR TWORD,
      GSA_Attrib     = 48 OR TLONG,
      GSA_BitmapTags = 56 OR TSTEPIN

/****************************************************************************
** Raster object.
*/

CONST VERRASTER  = 1,
      TAGS_RASTER = $FFFB0000 OR ID_RASTER

OBJECT raster
  head[1] :ARRAY OF head   /* Standard header */
  command :PTR TO rhead    /* Pointer to the first command */
  screen  :PTR TO screen   /* Pointer to our Screen owner */
  flags   :LONG            /* Special flags */
ENDOBJECT

CONST RSF_DISPLAYED = $00000001   /* If the raster is currently on display */

/****************************************************************************
** Rasterlist command header format.
*/

OBJECT rstats
  copsize :LONG
  coppos  :PTR TO INT
ENDOBJECT

OBJECT rhead
  id      :INT
  version :INT
  stats   :PTR TO rstats
  prev    :PTR TO rhead
  next    :PTR TO rhead
ENDOBJECT

/****************************************************************************
** These are the raster command structures.
*/

CONST ID_RASTWAIT       = 1,
      ID_RASTFLOOD      = 2,
      ID_RASTCOLOUR     = 3,
      ID_RASTCOLOURLIST = 4,
      ID_RASTMIRROR     = 5,
      ID_RASTEND        = 6

OBJECT rwait
  head[1] :ARRAY OF rhead
  line    :INT
ENDOBJECT

OBJECT rflood
  head[1] :ARRAY OF rhead
ENDOBJECT

OBJECT rcolour
  head[1] :ARRAY OF rhead
  colour  :LONG
  value   :LONG
ENDOBJECT

OBJECT rcolourlist
  head[1] :ARRAY OF rhead
  ycoord  :INT
  skip    :INT
  colour  :LONG
  values  :PTR TO LONG
ENDOBJECT

