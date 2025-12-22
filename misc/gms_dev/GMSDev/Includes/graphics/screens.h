#ifndef GRAPHICS_SCREENS_H
#define GRAPHICS_SCREENS_H TRUE

/*
**  $VER: screens.h
**
**  Screen Definitions
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

/****************************************************************************
** Screen Object.
*/

#define VER_SCREEN  2
#define TAGS_SCREEN ((ID_SPCTAGS<<16)|ID_SCREEN)

typedef struct GScreen {
  struct Head Head;        /* [00] Standard structure header */
  APTR   MemPtr1;          /* [12] Ptr to screen 1 */
  APTR   MemPtr2;          /* [16] Ptr to screen 2 (double buffer) */
  APTR   MemPtr3;          /* [20] Ptr to screen 3 (triple buffer) */
  struct GScreen *Link;    /* [24] Reserved */
  struct Raster  *Raster;  /* [28] Ptr to a raster object */
  WORD   Width;            /* [32] The width of the visible screen */
  WORD   Height;           /* [34] The height of the visible screen */
  WORD   XOffset;          /* [36] Hardware co-ordinate for TOS */
  WORD   YOffset;          /* [38] Hardware co-ordinate for LOS */
  WORD   BmpXOffset;       /* [40] Offset of the horizontal axis */
  WORD   BmpYOffset;       /* [42] Offset of the vertical axis */
  WORD   ScrMode;          /* [44] What screen mode is it? */
  WORD   reserved;         /* [46] Reserved. */
  LONG   Attrib;           /* [48] Special Attributes are? */
  struct DPKTask *prvTask; /* [52] Private */
  struct Bitmap  *Bitmap;  /* [56] Bitmap */
  WORD   Switch;           /* [60] R: Set to switch the buffers */

  /* Private fields */

  WORD   prv;                  /* */
  APTR   prvTypeEmulator;      /* Emulation */
  APTR   prvMonitor;           /* Monitor driver */
  APTR   prvEMemPtr1;          /* Chunky driver */
  APTR   prvEMemPtr2;          /* Chunky driver */
  APTR   prvEMemPtr3;          /* Chunky driver */
  APTR   prvEFree1;            /* Chunky driver */
  APTR   prvEFree2;            /* Chunky driver */
  APTR   prvEFree3;            /* Chunky driver */
  BYTE   prvColBits;           /* 0 = 12bit, 1 = 24bit */
  BYTE   prvPad;               /* Unused */
  LONG   prvShowKey;           /* Resource key if the screen is shown */
  LONG   prvScratch;           /* Scratch address! */
  struct ScreenPrefs *Prefs;   /* Screen preferences for this screen */
  APTR   prvLineWait;          /* Line Wait till bitplanes start */
  WORD   *prvEnd;              /* Ptr to the copper's jump end */
  WORD   prvBurstLevel;        /* FMode setting for bitplanes */
  struct Control *prvControl;  /* BPLCON0 */
  APTR   prvModulo;            /* The screen modulo */
  APTR   prvScrPosition;       /* DIW's, DDF's, DIWHIGH */
  APTR   prvStart;             /* Start of main copperlist */
  APTR   prvSprites;           /* Pointer to the copper sprites */
  APTR   prvColours;           /* Pointer to the copper colours */
  WORD   prvAmtBankCols;       /* Amount of colours per bank (AGA) */
  WORD   prvAmtBanks;          /* Amount of banks in total (AGA) */
  WORD   prvHiLoOffset;        /* Offset between hi and lo bits (AGA) */
  BYTE   *prvBitplanes1;       /* Ptr to copper bitplane loaders #1 */
  BYTE   *prvBitplanes2;       /* Ptr to copper bitplane loaders #2 */
  BYTE   *prvBitplanes3;       /* Ptr to copper bitplane loaders #3 */
  LONG   prvColListJmp;        /* Offset to RasterList */
  LONG   prvBmpXOffset;        /* X offset for scrolling */
  LONG   prvBmpYOffset;        /* Y offset for scrolling */
  WORD   prvScrollBWidth;      /* Set to 2 if scrolling */
  APTR   prvMemPtr1;           /* Original screen mem start (1) */
  APTR   prvMemPtr2;           /* Original screen mem start (2) */
  APTR   prvMemPtr3;           /* Original screen mem start (3) */
  WORD   prvBPLCON3;           /* BPLCON3 actual data (not a ptr) */
  WORD   prvAmtFields;         /* Amount of PlayFields on screen */
  WORD   prvFieldNum;          /* Number of this field */
  WORD   prvScrLRWidth;        /* ScrWidth, in lo-resolution */
  WORD   prvScrLRBWidth;       /* ScrByteWidth, in lo-resolution */
  WORD   prvPicLRWidth;        /* PicWidth, in lo-resolution */
  WORD   prvTOSX;              /* Top of screen X for this screen */
  WORD   prvTOSY;              /* Top of screen Y for this screen */
  APTR   prvCopperMem;         /* Pointer to original screen mem start */
  struct Bitmap *prvBitmap;    /* Allocated bitmap */
  WORD   prvBlitXOffset;       /* Offset to use for blitting (hard-scroll) */
  LONG   *prvPalette;          /* Allocated palette */
  APTR   prvBufPtr1;           /* */
  APTR   prvBufPtr2;           /* */
  APTR   prvBufPtr3;           /* */
  APTR   prvRastport;          /* Private rastport pointer */
} OBJScreen;

/* Screen Buffer names, these are asked for in the blitter functions */

#define BUFFER1  12
#define BUFFER2  16
#define BUFFER3  20

/* SCREEN ATTRIBUTES (Attrib) */

#define SCR_DBLBUFFER    0x00000001   /* For double buffering */
#define SCR_TPLBUFFER    0x00000002   /* Triple buffering!! */
/*#define SCR_PLAYFIELD  0x00000004    Set if it's part of a playfield */
#define SCR_HSCROLL      0x00000008   /* Gotta set this to do scrolling */
#define SCR_VSCROLL      0x00000010   /* For vertical scrolling */
/*#define SCR_SPRITES    0x00000020    Set this if you want sprites */
#define SCR_SBUFFER      0x00000040   /* Create a buffer for horiz scrolling */
#define SCR_CENTRE       0x00000080   /* Centre the screen (sets XOffset/YOffset) */
#define SCR_BLKBDR       0x00000100   /* Gives a blackborder on AGA machines */
#define SCR_NOSCRBDR     0x00000200   /* For putting sprites in the border */

/* SCREEN MODES (ScrMode) */

#define SM_HIRES   0x0001       /* High resolution */
#define SM_SHIRES  0x0002       /* Super-High resolution */
#define SM_LACED   0x0004       /* Interlaced */
#define SM_LORES   0x0008       /* Low resolution (default) */
#define SM_SLACED  0x0020       /* Super-Laced resolution */

/* Screen Tags */

#define GSA_MemPtr1    (12|TAPTR)
#define GSA_MemPtr2    (16|TAPTR)
#define GSA_MemPtr3    (20|TAPTR)
#define GSA_Raster     (28|TAPTR)
#define GSA_Width      (32|TWORD)
#define GSA_Height     (34|TWORD)
#define GSA_XOffset    (36|TWORD)
#define GSA_YOffset    (38|TWORD)
#define GSA_BmpXOffset (40|TWORD)
#define GSA_BmpYOffset (42|TWORD)
#define GSA_ScrMode    (44|TWORD)
#define GSA_Attrib     (48|TLONG)
#define GSA_BitmapTags (56|TSTEPIN)

/****************************************************************************
** Raster object.
*/

#define VER_RASTER  1
#define TAGS_RASTER ((ID_SPCTAGS<<16)|ID_RASTER)

typedef struct Raster {
  struct Head Head;        /* [00] Standard header */
  struct RHead   *Command; /* [12] Pointer to the first command */
  struct GScreen *Screen;  /* [16] Pointer to our Screen owner */
  LONG   Flags;            /* [20] Special flags */

  /*** Private fields ***/

  APTR   prvRasterMem;
} OBJRaster;

#define RSF_DISPLAYED 0x00000001   /* If the raster is currently on display */

/****************************************************************************
** Rasterlist command header format.
*/

struct RStats {
  LONG  CopSize;
  UWORD *CopPos;
};

struct RHead {
  WORD   ID;
  WORD   Version;
  struct RStats *Stats;
  struct RHead  *Prev;
  struct RHead  *Next;
};

/****************************************************************************
** These are the raster command structures.
*/

#define ID_RASTWAIT       1
#define ID_RASTFLOOD      2
#define ID_RASTCOLOUR     3
#define ID_RASTCOLOURLIST 4
#define ID_RASTMIRROR     5

#define ID_RASTEND        6

typedef struct RWait {
  struct RHead Head;
  WORD   Line;
} RMD_WAIT;

typedef struct RFlood {
  struct RHead Head;
} RMD_FLOOD;

typedef struct RColour {
  struct RHead Head;
  LONG   Colour;
  LONG   Value;
} RMD_COLOUR;

typedef struct RColourList {
  struct RHead Head;
  WORD   YCoord;
  WORD   Skip;
  LONG   Colour;
  LONG   *Values;
} RMD_COLOURLIST;

#endif /* GRAPHICS_SCREENS_H */
