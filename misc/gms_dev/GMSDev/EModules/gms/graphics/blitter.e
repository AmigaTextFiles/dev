/*
**  $VER: blitter.e V2.0
**
**  Blitter Object Definitions.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'gms/dpkernel/dpkernel','gms/graphics/pictures',
       'gms/system/register','gms/graphics/screens'

/****************************************************************************
** Bitmap Object. 
*/

CONST VER_BITMAP  = 3,
      TAGS_BITMAP = $FFFB0000 OR ID_BITMAP

OBJECT bitmap
  head[1]    :ARRAY OF head /* Standard structure header */
  data       :PTR TO CHAR   /* Pointer to bitmap data area */
  width      :INT           /* Width */
  bytewidth  :INT           /* ByteWidth */
  height     :INT           /* Height */
  type       :INT           /* Screen type */
  linemod    :LONG          /* Line differential */
  planemod   :LONG          /* Plane differential */
  parent     :PTR TO head   /* Bitmap owner */
  restore    :LONG          /* Restore list for this bitmap, if any */
  size       :LONG          /* Total size of the bitmap in bytes */
  memtype    :LONG          /* Memory type to use in allocation */
  planes     :INT           /* Amount of planes */
  emp        :INT           /* Reserved */
  amtcolours :LONG          /* Maximum amount of colours available */
  palette    :PTR TO LONG   /* Pointer to the Bitmap's palette */
  flags      :LONG          /* Optional flags */
ENDOBJECT

CONST BMA_Data       = TAPTR OR 12,
      BMA_Width      = TWORD OR 16,
      BMA_Height     = TWORD OR 20,
      BMA_Type       = TWORD OR 22,
      BMA_Size       = TLONG OR 40,
      BMA_MemType    = TLONG OR 44,
      BMA_Planes     = TWORD OR 48,
      BMA_AmtColours = TLONG OR 52,
      BMA_Palette    = TAPTR OR 56,
      BMA_Flags      = TLONG OR 60

/***************************************************************************
** Bitmap Types
*/

CONST INTERLEAVED = 1,    /* Notice that these are numbers, not flags */
      ILBM        = 1,
      PLANAR      = 2,
      CHUNKY8     = 3,
      CHUNKY16    = 4,    /* %RRRRRGGG.GGGBBBBB */
      TRUECOLOUR  = 5     /* $AARR.GGBB */

/***************************************************************************
** Bitmap Flags
*/

CONST BMF_BLANKPALETTE = $00000001,  /* For a blank/black palette */
      BMF_EXTRAHB      = $00000002,  /* Extra half brite */
      BMF_HAM          = $00000004   /* HAM mode */

/***************************************************************************
** Pen shapes.
*/

CONST PSP_CIRCLE = 1,
      PSP_SQUARE = 2,
      PSP_PIXEL  = 3

/**************************************************************************/

CONST PALETTE_ARRAY = $28000001

OBJECT hsv
  hue :INT
  sat :INT
  val :INT
ENDOBJECT

/***************************************************************************
** Restore Object.
*/

CONST VER_RASTER   = 1,
      TAGS_RESTORE = $FFFB0000 OR ID_RESTORE

OBJECT restore
  head[1] :ARRAY OF head /* Standard header */
  buffers :INT           /* Amount of screen buffers */
  entries :INT           /* Amount of entries */
  owner   :PTR TO head   /* Owner of the restorelist, ie bitmap */
ENDOBJECT

CONST RSA_Buffers = 12 OR TWORD,
      RSA_Entries = 14 OR TWORD,
      RSA_Owner   = 16 OR TAPTR

/**************************************************************************/

OBJECT mbentry  /* MBob Entry Structure */
  xcoord :INT
  ycoord :INT
  frame  :INT
ENDOBJECT

OBJECT framelist
   gfx_xcoord :INT
   gfx_ycoord :INT
   msk_xcoord :INT
   msk_ycoord :INT
ENDOBJECT

/***************************************************************************
** Bob Object.
*/

CONST VER_BOB  = 1,
      TAGS_BOB = $FFFB0000 OR ID_BOB

OBJECT bob
   head[1]      :ARRAY OF head    -> Standard structure header.
   emp1         :LONG             ->
   emp2         :LONG             ->
   gfxcoords    :PTR TO framelist -> Pointer to frame list.
   frame        :INT              -> Current frame.
   emp3         :INT              ->
   width        :INT              -> Width in pixels.
   bytewidth    :INT              -> Width in bytes.
   xcoord       :INT              -> To X pixel.
   ycoord       :INT              -> To Y pixel.
   height       :INT              -> Height in pixels.
   clipLX       :INT              -> Left X border in bytes (0/8)
   clipTY       :INT              -> Top Y border (0)
   clipRX       :INT              -> Right X border in bytes (320/8)
   clipBY       :INT              -> Bottom Y border (256)
   fplane       :INT              -> 1st Plane to blit to (planar only)
   planes       :INT              -> Amount of planes
   propheight   :INT              -> Expected height of source bitmap.
   propwidth    :INT              -> Expected width of source bitmap.
   buffers      :INT
   planesize    :LONG             -> Size Of Plane Source (planar only)
   attrib       :LONG             -> Attributes like CLIP and MASK.
   srcbitmap    :PTR TO bitmap
   mbobreserved :INT
   emp4         :INT
   source       :LONG
   directgfx    :PTR TO LONG
   destbitmap   :PTR TO bitmap
   maskcoords   :PTR TO framelist
   directmasks  :LONG
   maskbitmap   :PTR TO bitmap
   amtframes    :INT
ENDOBJECT

CONST BBA_GfxCoords  = 20 OR TAPTR,
      BBA_Frame      = 24 OR TWORD,
      BBA_Width      = 28 OR TWORD,
      BBA_XCoord     = 32 OR TWORD,
      BBA_YCoord     = 34 OR TWORD,
      BBA_Height     = 36 OR TWORD,
      BBA_ClipLX     = 38 OR TWORD,
      BBA_ClipTY     = 40 OR TWORD,
      BBA_ClipRX     = 42 OR TWORD,
      BBA_ClipBY     = 44 OR TWORD,
      BBA_FPlane     = 46 OR TWORD,
      BBA_Planes     = 48 OR TWORD,
      BBA_PropHeight = 50 OR TWORD,
      BBA_PropWidth  = 52 OR TWORD,
      BBA_Buffers    = 54 OR TWORD,
      BBA_Attrib     = 60 OR TLONG,
      BBA_SrcBitmap  = 64 OR TWORD,
      BBA_Source     = 72 OR TAPTR,
      BBA_MaskCoords = 84 OR TAPTR,
      BBA_MaskBitmap = 92 OR TAPTR

CONST BBA_SourceTags   = TSTEPIN OR TTRIGGER OR 72

/***********************************************************************************
** Multple Bob object.
*/

CONST VER_MBOB  = 1,
      TAGS_MBOB = $FFFB0000 OR ID_MBOB

OBJECT mbob
   head[1]      :ARRAY OF head    -> Standard header.
   emp1         :LONG             ->
   emp2         :LONG             ->
   gfxcoords    :PTR TO framelist -> Pointer to frame list.
   amtentries   :INT              -> Amount of entries.
   emp3         :INT              ->
   width        :INT              -> Width in pixels.
   bytewidth    :INT              -> Width in bytes.
   height       :INT              -> Height in pixels.
   entrylist    :LONG             -> Pointer to entry list.
   clipLX       :INT              -> Left X border in bytes (0/8)
   clipTY       :INT              -> Top Y border (0)
   clipRX       :INT              -> Right X border in bytes (320/8)
   clipBY       :INT              -> Bottom Y border (256)
   fplane       :INT              -> 1st Plane to blit to (planar only)
   planes       :INT              -> Amount of planes
   planesize    :LONG             -> Size Of Plane Source (planar only)
   attrib       :LONG             -> Attributes like CLIP and MASK.
   srcbitmap    :PTR TO bitmap    -> Pointer to a picture struct (bob origin).
   entrysize    :INT              -> Size of each entry in the list.
   emp4         :INT              -> 
   source       :PTR TO picture   ->
   directgfx    :LONG             -> 
   destbitmap   :PTR TO bitmap    -> Pointer to Bob's destination Bitmap.
   maskcoords   :PTR TO framelist -> Pointer to frame list for masks.
   directmasks  :PTR TO LONG      ->
   maskbitmap   :PTR TO bitmap    ->
   amtframes    :INT              -> 
ENDOBJECT

CONST MBA_GfxCoords   = 20 OR TAPTR,
      MBA_AmtEntries  = 24 OR TWORD,
      MBA_Width       = 28 OR TWORD,
      MBA_EntryList   = 32 OR TAPTR,
      MBA_Height      = 36 OR TWORD,
      MBA_ClipLX      = 38 OR TWORD,
      MBA_ClipTY      = 40 OR TWORD,
      MBA_ClipRX      = 42 OR TWORD,
      MBA_ClipBY      = 44 OR TWORD,
      MBA_FPlane      = 46 OR TWORD,
      MBA_Planes      = 48 OR TWORD,
      MBA_PropHeight  = 50 OR TWORD,
      MBA_PropWidth   = 52 OR TWORD,
      MBA_Buffers     = 54 OR TWORD,
      MBA_Attrib      = 60 OR TLONG,
      MBA_SrcBitmap   = 64 OR TAPTR,
      MBA_EntrySize   = 68 OR TWORD,
      MBA_Source      = 72 OR TAPTR,
      MBA_MaskCoords  = 84 OR TAPTR,
      MBA_MaskBitmap  = 92 OR TAPTR

/**************************************************************************/

CONST BBF_CLIP      = $00000001,
      BBF_MASK      = $00000002,
      BBF_STILL     = $00000004,
      BBF_CLEAR     = $00000008,
      BBF_RESTORE   = $00000010,
      BBF_FILLMASK  = $00000040,
      BBF_GENMASK   = $00000082,
      BBF_GENMASKS  = $00000082,
      BBF_CLRMASK   = $00000100,
      BBF_CLRNOMASK = $00000000

/****************************************************************************
** Pixel list structures.
*/

OBJECT pixelentry
  xcoord :INT
  ycoord :INT
  colour :LONG
ENDOBJECT

OBJECT pixellist
  amtentries :INT
  entrysize  :INT
  pixels     :PTR TO pixelentry
ENDOBJECT

CONST SKIPIMAGE = 32000,
      SKIPPIXEL = -32000

/***************************************************************************/

CONST BSORT_X         = $00000001,
      BSORT_Y         = $00000002,
      BSORT_DOWNTOP   = $00000004,  /* From Bottom to top */
      BSORT_RIGHTLEFT = $00000008,  /* Right to Left */
      BSORT_LEFTRIGHT = $00000000,  /* Default */
      BSORT_TOPDOWN   = $00000000  /* Default */

