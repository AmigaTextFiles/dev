#ifndef GRAPHICS_BLITTER_H
#define GRAPHICS_BLITTER_H TRUE

/*
**  $VER: blitter.h
**
**  Blitter Definitions
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

#define BlitModVersion  3
#define BlitModRevision 1

/***************************************************************************
** Bitmap Object.
*/

#define VER_BITMAP  3
#define TAGS_BITMAP ((ID_SPCTAGS<<16)|ID_BITMAP)

typedef struct Bitmap {
  struct Head Head;        /* [00] Standard structure header */
  APTR   Data;             /* [12] Pointer to bitmap data area */
  WORD   Width;            /* [16] Width */
  WORD   ByteWidth;        /* [18] ByteWidth */
  WORD   Height;           /* [20] Height */
  WORD   Type;             /* [22] Screen type */
  LONG   LineMod;          /* [24] Line differential */
  LONG   PlaneMod;         /* [28] Plane differential */
  struct Head    *Parent;  /* [32] Bitmap owner */
  struct Restore *Restore; /* [36] Restore list for this bitmap, if any */
  LONG   Size;             /* [40] Total size of the bitmap in bytes */
  LONG   MemType;          /* [44] Memory type to use in allocation */
  WORD   Planes;           /* [48] Amount of planes */
  WORD   prvRes1;          /* [50] Reserved */
  LONG   AmtColours;       /* [52] Maximum amount of colours available */
  LONG   *Palette;         /* [56] Pointer to the Bitmap's palette */
  LONG   Flags;            /* [60] Optional flags */
  LIBPTR void (*DrawUCPixel)(mreg(__a0) struct Bitmap *, mreg(__d1) WORD X, mreg(__d2) WORD Y, mreg(__d3) LONG Colour);
  LIBPTR void (*DrawUCRPixel)(mreg(__a0) struct Bitmap *, mreg(__d1) WORD X, mreg(__d2) WORD Y, mreg(__d3) LONG RGB);
  LIBPTR LONG (*ReadUCPixel)(mreg(__a0) struct Bitmap *, mreg(__d1) WORD X, mreg(__d2) WORD Y);
  LIBPTR LONG (*ReadUCRPixel)(mreg(__a0) struct Bitmap *, mreg(__d1) WORD X, mreg(__d2) WORD Y);
  LIBPTR void (*DrawPen)(mreg(__a0) struct Bitmap *, mreg(__d1) WORD X, mreg(__d2) WORD Y);
  LIBPTR void (*PenUCPixel)(mreg(__a0) struct Bitmap *, mreg(__d1) WORD X, mreg(__d2) WORD Y);

  /*** Private fields below ***/

  WORD   prvAFlags;        /* Allocation flags */
  LONG   *prvPalette;      /* Allocated palette pointer */
  LONG   prvBytePos;       /* Read/Write position */
  LONG   prvPen;           /* Pen colour */
  WORD   prvPenRadius;     /* Pen radius */
} OBJBitmap;

#define BMA_Data         (TAPTR|12)
#define BMA_Width        (TWORD|16)
#define BMA_Height       (TWORD|20)
#define BMA_Type         (TWORD|22)
#define BMA_Size         (TLONG|40)
#define BMA_MemType      (TLONG|44)
#define BMA_Planes       (TWORD|48)
#define BMA_AmtColours   (TLONG|52)
#define BMA_Palette      (TAPTR|56)
#define BMA_Flags        (TLONG|60)
#define BMA_DrawUCPixel  (TAPTR|64)
#define BMA_DrawUCRPixel (TAPTR|68)
#define BMA_ReadUCPixel  (TAPTR|72)
#define BMA_ReadUCRPixel (TAPTR|76)
#define BMA_DrawPen      (TAPTR|80)
#define BMA_PenUCPixel   (TAPTR|84)

/***************************************************************************
** Bitmap Types
*/

#define INTERLEAVED 1    /* Notice that these are numbers, not flags */
#define ILBM        1
#define PLANAR      2
#define CHUNKY8     3
#define CHUNKY16    4    /* %RRRRRGGG.GGGBBBBB */
#define CHUNKY32    5    /* $AA.RR.GG.BB */

#define TRUECOLOUR  CHUNKY32

/***************************************************************************
** Bitmap Flags.
*/

#define BMF_BLANKPALETTE 0x00000001  /* For a blank/black palette */
#define BMF_EXTRAHB      0x00000002  /* Extra half brite */
#define BMF_HAM          0x00000004  /* HAM mode */

/***************************************************************************
** Pen shapes.
*/

#define PSP_CIRCLE 1
#define PSP_SQUARE 2
#define PSP_PIXEL  3

/**************************************************************************/

struct RGB {
  BYTE  Alpha;
  UBYTE Red;
  UBYTE Green;
  UBYTE Blue;
};

struct HSV {
  WORD Hue; /* Between 0 and 359 */
  WORD Sat; /* Between 0 and 100 */
  WORD Val; /* Between 0 and 100 */
};

struct Palette {
  LONG ID;           /* PALETTE_ARRAY */
  LONG AmtColours;   /* Amount of Colours */
  LONG Colour[256];  /* RGB Palette */
};

struct RGBPalette {
  LONG ID;                 /* PALETTE_ARRAY */
  LONG AmtColours;         /* Amount of Colours */
  struct RGB Col[256];  /* RGB Palette */
};

#define PALETTE_ARRAY ((ID_PALETTE<<16)|01)

#define DecRGB(r,g,b) ((r<<16)|(g<<8)|(b))

#define COL_Black        DecRGB(0,0,0)
#define COL_White        DecRGB(255,255,255)
#define COL_BrightRed    DecRGB(255,0,0)
#define COL_BrightGreen  DecRGB(0,255,0)
#define COL_BrightBlue   DecRGB(0,0,255)
#define COL_Grey         DecRGB(128,128,128)
#define COL_LightGrey    DecRGB(192,192,192)
#define COL_DarkGrey     DecRGB(64,64,64)

/***************************************************************************
** Restore Object.
*/

#define VER_RESTORE  1
#define TAGS_RESTORE ((ID_SPCTAGS<<16)|ID_RESTORE)

typedef struct Restore {
  struct Head Head;      /* Standard header */
  WORD   Buffers;        /* Amount of screen buffers - 1, 2 or 3 */
  WORD   Entries;        /* Amount of entries 1 ... 32k */
  struct Head *Owner;    /* Owner of the restorelist, ie bitmap */

  /*** Private fields below ***/

  struct RstEntry *List1;
  struct RstEntry *List2;
  struct RstEntry *List3;
  struct RstEntry *ListPos1;
  struct RstEntry *ListPos2;
  struct RstEntry *ListPos3;
} OBJRestore;

/**** This structure is -completely- private ***/

struct RstEntry {
  struct RstEntry *Next;  /* Next restore entry in the chain */
  struct RstEntry *Prev;  /* Previous restore enty in the chain */
  APTR   Bob;             /* Bob structure belonging to the restore [*] */
  APTR   Address;         /* Screen pointer (top of screen) [*] */
  APTR   Storage;         /* Background storage or NULL */
  APTR   Control;         /* Controls from the lookup table */
  APTR   ConMask;         /* The control mask to use */
  WORD   Modulo1;         /* Modulo C */
  LONG   Modulo2;         /* Modulos A/D */
  WORD   BlitWidth;       /* [*] */
  WORD   BlitHeight;      /* [*] */
};

#define RSA_Buffers (12|TWORD)
#define RSA_Entries (14|TWORD)
#define RSA_Owner   (16|TAPTR)

/***************************************************************************
** Bob Object.
*/

#define VER_BOB  1
#define TAGS_BOB ((ID_SPCTAGS<<16)|ID_BOB)

typedef struct  FrameList {
  WORD  XCoord;
  WORD  YCoord;
} OBJFrameList;

typedef struct Bob {
  struct Head Head;             /* [00] Standard structure header */
  LONG   emp1;                  /* [12] */
  LONG   emp2;                  /* [16] */
  struct FrameList *GfxCoords;  /* [20] Pointer to graphic frame coordinates */
  WORD   Frame;                 /* [24] Current frame */
  WORD   emp3;                  /* [26] */
  WORD   Width;                 /* [28] Width in pixels */
  WORD   ByteWidth;             /* [30] Width in bytes */
  WORD   XCoord;                /* [32] To X pixel */
  WORD   YCoord;                /* [34] To Y pixel */
  WORD   Height;                /* [36] Height in pixels */
  WORD   ClipLX;                /* [38] Left X border */
  WORD   ClipTY;                /* [40] Top Y border */
  WORD   ClipRX;                /* [42] Right X border */
  WORD   ClipBY;                /* [44] Bottom Y border */
  WORD   FPlane;                /* [46] 1st Plane to blit to (planar only) */
  WORD   Planes;                /* [48] Amount of planes */
  WORD   PropHeight;            /* [50] Expected height of source bitmap */
  WORD   PropWidth;             /* [52] Expected width of source bitmap */
  WORD   Buffers;               /* [54] Relevant only to restore mode */
  LONG   PlaneSize;             /* [56] Size of source plane (planar only) */
  LONG   Attrib;                /* [60] Attributes like CLIP and MASK */
  struct Bitmap *SrcBitmap;     /* [64] Source Bitmap */
  WORD   MBReserved1;           /* [68] Reserved, in use by MBob */
  WORD   emp4;                  /* [70] */
  APTR   Source;                /* [72] Pointer to source object */
  APTR   *DirectGfx;            /* [76] Pointer to direct frame list */
  struct Bitmap    *DestBitmap; /* [80] Destination Bitmap */
  struct FrameList *MaskCoords; /* [84] Pointer to mask frame coordinates */
  APTR   *DirectMasks;          /* [88] Pointer to direct frame list */
  struct Bitmap *MaskBitmap;    /* [92] */
  WORD   AmtFrames;             /* [96] Amount of frames in frame/direct list */

  /*** Private fields start now ***/

  WORD   prvStoreSize;       /* 4/8/12 Sizeof one store entry (MBob's) */
  APTR   prvStoreBuffer;     /* A/B/C [0/4/8] storage pointer (MBob's) */
  WORD   prvStoreMax;        /* Maximum store position */
  APTR   prvStoreMemory;     /* Master storage pointer (for the freemem) */
  WORD   prvStoreCount;      /* Counter for store, 0, 4, 8 */
  BYTE   *prvStoreA;         /* Storage buffer 1 */
  BYTE   *prvStoreB;         /* Storage buffer 2 */
  BYTE   *prvStoreC;         /* Storage buffer 3 */
  APTR   prvDrawRoutine;     /* Routine for drawing/clearing/storing */
  APTR   prvClearRoutine;    /* Routine for clearing */
  APTR   prvRestoreRoutine;  /* Routine for restoring/clearing */
  APTR   prvHeightRoutine;   /* Replaces BS_DrawRoutine for large heights */
  LONG   prvScreenSize;      /* Size of destination plane */
  WORD   prvModulo;          /* Bob Modulo (PicWidth-BobWidth) */
  WORD   prvMaskModulo;      /* Mask Modulo (BobWidth-BobWidth for GENMASK) */
  APTR   prvMaskMemory;      /* Master mask pointer (for the freemem) */
  WORD   prvMaxHeight;       /* Maximum possible height, limited by blitter */
  WORD   prvScrLine;         /* Size of a line (for interleaved) */
  WORD   prvBobLine;         /* Size of a Bob line (Width*Planes) */
  WORD   prvMaskLine;        /* Size of a Mask Line (Width*Planes) */
  WORD   prvTrueWidth;       /* The true pixel width (++shift) */
  WORD   prvTrueBWidth;      /* The true byte width (++shift) */
  WORD   prvTrueWWidth;      /* The true word width (++shift) */
  WORD   prvClipBLX;         /* ClipLX, byte */
  WORD   prvClipBRX;         /* ClipRX, byte */
  WORD   prvModuloC;         /* Modulus (C) */ 
  WORD   prvModuloB;         /* Modulus (B) */ 
  WORD   prvModuloA;         /* Modulus (A) */
  WORD   prvModuloD;         /* Modulus (D) */
  WORD   prvNSModuloC;       /* NSModulus (C) */ 
  WORD   prvNSModuloB;       /* NSModulus (B) */ 
  WORD   prvNSModuloA;       /* NSModulus (A) */ 
  WORD   prvNSModuloD;       /* NSModulus (D) */ 
  WORD   prvWordWidth;       /* The word width */
  BYTE   prvAFlags;          /* Allocation flags */
  BYTE   prvPad;             /* Empty */
  struct GScreen *prvScreen; /* Destination Screen (Private) */
  BYTE   *prvMaskData;
  WORD   prvSrcWidth;         /* Source Page Width in bytes */
  WORD   prvSrcMaskWidth;     /* Mask page width in bytes */
} OBJBob;

#define BBA_GfxCoords    (20|TAPTR)
#define BBA_Frame        (24|TWORD)
#define BBA_Width        (28|TWORD)
#define BBA_XCoord       (32|TWORD)
#define BBA_YCoord       (34|TWORD)
#define BBA_Height       (36|TWORD)
#define BBA_ClipLX       (38|TWORD)
#define BBA_ClipTY       (40|TWORD)
#define BBA_ClipRX       (42|TWORD)
#define BBA_ClipBY       (44|TWORD)
#define BBA_FPlane       (46|TWORD)
#define BBA_Planes       (48|TWORD)
#define BBA_PropHeight   (50|TWORD)
#define BBA_PropWidth    (52|TWORD)
#define BBA_Buffers      (54|TWORD)
#define BBA_Attrib       (60|TLONG)
#define BBA_SrcBitmap    (64|TAPTR)
#define BBA_Source       (72|TAPTR)
#define BBA_MaskCoords   (84|TAPTR)
#define BBA_MaskBitmap   (92|TAPTR)

#define BBA_SourceTags   (TSTEPIN|TTRIGGER|72)

/***********************************************************************************/

#define VER_MBOB  1
#define TAGS_MBOB ((ID_SPCTAGS<<16)|ID_MBOB)

typedef struct MBob {
  struct Head Head;              /* [00] Standard structure header */
  APTR   emp1;                   /* [12] */
  APTR   emp2;                   /* [16] */
  struct FrameList *GfxCoords;   /* [20] Pointer to graphics frame list */
  WORD   AmtEntries;             /* [24] Amount of entries in the list */
  WORD   emp3;                   /* [26] */
  WORD   Width;                  /* [28] Width in pixels (optional) */
  WORD   ByteWidth;              /* [30] Width in bytes */
  struct MBEntry *EntryList;     /* [32] :MB: Pointer to entry list */
  WORD   Height;                 /* [36] Height in pixels */
  WORD   ClipLX;                 /* [38] Left X border */
  WORD   ClipTY;                 /* [40] Top Y border */
  WORD   ClipRX;                 /* [42] Right X border */
  WORD   ClipBY;                 /* [44] Bottom Y border */
  WORD   FPlane;                 /* [46] 1st Plane to blit to (planar only) */
  WORD   Planes;                 /* [48] Amount of planes */
  WORD   PropHeight;             /* [50] Expected height of source picture */
  WORD   PropWidth;              /* [52] Expected width of source picture */
  WORD   Buffers;                /* [54] Relevent only to restore mode */
  LONG   PlaneSize;              /* [56] Size of source plane (planar only) */
  LONG   Attrib;                 /* [60] Attributes like CLIP and MASK */
  struct Bitmap *SrcBitmap;      /* [64] Source Bitmap */
  WORD   EntrySize;              /* [68] Entry size (sizeof(struct MBEntry)) */
  WORD   emp4;                   /* [70] */
  APTR   Source;                 /* [72] Pointer to source object */
  LONG   *DirectGfx;             /* [76] Pointer to direct frame list (R) */
  struct Bitmap    *DestBitmap;  /* [80] The MBob's destination Bitmap */
  struct FrameList *MaskCoords;  /* [84] Pointer to masks frame list */
  LONG   *DirectMasks;           /* [88] Pointer to direct frame list (R) */
  struct Bitmap *MaskBitmap;     /* [92] */
  WORD   AmtFrames;              /* [96] Amount of frames in frame/direct list */

  /*** Private fields start now ***/

  WORD   prvStoreSize;        /* 4/8/12 Sizeof one store entry (MBob's) */
  APTR   prvStoreBuffer;      /* A/B/C [0/4/8] storage pointer (MBob's) */
  WORD   prvStoreMax;         /* Maximum store position */
  APTR   prvStoreMemory;      /* Master storage pointer (for the freemem) */
  WORD   prvStoreCount;       /* Counter for store, 0, 4, 8 */
  APTR   prvStoreA;           /* Storage buffer 1 */
  APTR   prvStoreB;           /* Storage buffer 2 */
  APTR   prvStoreC;           /* Storage buffer 3 */
  APTR   prvDrawRoutine;      /* Routine for drawing/clearing/storing */
  APTR   prvClearRoutine;     /* Routine for clearing */
  APTR   prvRestoreRoutine;   /* Routine for restoring/clearing */
  APTR   prvHeightRoutine;    /* Replaces BS_DrawRoutine for large heights */
  LONG   prvScreenSize;       /* Size of destination plane */
  WORD   prvModulo;           /* Bob Modulo (PicWidth-BobWidth) */
  WORD   prvMaskModulo;       /* Mask Modulo (BobWidth-BobWidth for GENMASK) */
  APTR   prvMaskMemory;       /* Master mask pointer (for the freemem) */
  WORD   prvMaxHeight;        /* Maximum possible height, limited by blitter */
  WORD   prvScrLine;          /* Size of a line (for interleaved) */
  WORD   prvBOBLine;          /* Size of a Bob line (Width*Planes) */
  WORD   prvMaskLine;         /* Size of a Mask Line (Width*Planes) */
  WORD   prvTrueWidth;        /* The true pixel width (++shift) */
  WORD   prvTrueBWidth;       /* The true byte width (++shift) */
  WORD   prvTrueWWidth;       /* The true word width (++shift) */
  WORD   prvClipBLX;          /* ClipLX, byte */
  WORD   prvClipBRX;          /* ClipRX, byte */
  LONG   prvModulo1;          /* Modulus (C/B) */ 
  LONG   prvModulo2;          /* Modulus (A/D) */ 
  LONG   prvNSModulo1;        /* Modulus (C/B) */ 
  LONG   prvNSModulo2;        /* Modulus (A/D) */ 
  WORD   prvWordWidth;        /* The word width */
  BYTE   prvAFlags;           /* Allocation flags */
  BYTE   prvPad;              /* Empty */
  struct GScreen *prvScreen;  /* The MBob's destination Screen */
  BYTE   *prvMaskData;
  WORD   prvSrcWidth;         /* Source Page Width in bytes */
  WORD   prvSrcMaskWidth;     /* Mask page width in bytes */
} OBJMBob;

#define MBA_GfxCoords    (20|TAPTR)
#define MBA_AmtEntries   (24|TWORD)
#define MBA_Width        (28|TWORD)
#define MBA_EntryList    (32|TAPTR)
#define MBA_Height       (36|TWORD)
#define MBA_ClipLX       (38|TWORD)
#define MBA_ClipTY       (40|TWORD)
#define MBA_ClipRX       (42|TWORD)
#define MBA_ClipBY       (44|TWORD)
#define MBA_FPlane       (46|TWORD)
#define MBA_Planes       (48|TWORD)
#define MBA_PropHeight   (50|TWORD)
#define MBA_PropWidth    (52|TWORD)
#define MBA_Buffers      (54|TWORD)
#define MBA_Attrib       (60|TLONG)
#define MBA_SrcBitmap    (64|TAPTR)
#define MBA_EntrySize    (68|TWORD)
#define MBA_Source       (72|TAPTR)
#define MBA_MaskCoords   (84|TAPTR)
#define MBA_MaskBitmap   (92|TAPTR)

/***************************************************************************/

typedef struct MBEntry {        /* MBob Entry Structure */
  WORD XCoord;
  WORD YCoord;
  WORD Frame;
} OBJMBEntry;

#define MBE_SIZEOF (sizeof(struct MBEntry))

/* Bob Attributes (Bob.Attrib) */

#define BBF_CLIP      0x00000001 /* Allow border clipping */
#define BBF_MASK      0x00000002 /* Allow masking */
#define BBF_STILL     0x00000004 /* This bob is not moving */
#define BBF_CLEAR     0x00000008 /* Allow automatic clearing */
#define BBF_RESTORE   0x00000010 /* Allow automatic background restore */
/*#define           0x00000020   */
#define BBF_FILLMASK  0x00000040 /* Fill any holes in the mask on generation */
#define BBF_GENONLY   0x00000080 /* Create masks but do not use them yet */
#define BBF_GENMASKS  0x00000082 /* Create and use masks for drawing this bob */
#define BBF_CLRMASK   0x00000100 /* Use masks when clearing */
#define BBF_CLRNOMASK 0x00000000 /* Do not use masks when clearing (default) */

#define BBF_GENMASK BBF_GENMASKS /* Synonym */

#define SKIPIMAGE 32000

/****************************************************************************
** Pixel list structures.
*/

typedef struct PixelEntry {
  WORD XCoord;
  WORD YCoord;
  LONG Colour;
} OBJPixelEntry;

typedef struct PixelList {
  WORD   AmtEntries;
  WORD   EntrySize;
  struct PixelEntry *Pixels;
} OBJPixelLIst;

#define SKIPPIXEL -32000
#define PIXELLIST(a)

/***************************************************************************/

#define BSORT_X         0x00000001
#define BSORT_Y         0x00000002
#define BSORT_DOWNTOP   0x00000004  /* From Bottom to top */
#define BSORT_RIGHTLEFT 0x00000008  /* Right to Left */
#define BSORT_LEFTRIGHT 0x00000000  /* Default */
#define BSORT_TOPDOWN   0x00000000  /* Default */

#endif /* GRAPHICS_BLITTER_H */
