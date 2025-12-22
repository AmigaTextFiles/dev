#ifndef DESKTOP_DESKTOP_H
#define DESKTOP_DESKTOP_H TRUE

/*
**  $VER: desktop.h
**
**  Desktop Definitions.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

/***************************************************************************
** Desktop object.
*/

#define TAGS_DESKTOP ((ID_SPCTAGS<<16)|ID_DESKTOP)
#define VER_DESKTOP  1

typedef struct Desktop {
  struct Head    Head;       /* 00 [--] Standard header structure */
  struct MenuBar *MenuBar;   /* 12 [--] Only 1 menu bar is allowed */
  struct Bob     *Pointer;   /* 16 [--] The pointer for this desktop */
  struct GScreen *Screen;    /* 20 [--] The Screen that is owned by the Desktop */
  struct Chain   *Icons;     /* 24 [--] First icon on the chain */
  struct Chain   *Windows;   /* 28 [--] First window on the chain */
  struct Chain   *Children;  /* 32 [--] All the other children inside the desktop */
  LONG   Gadgets;            /* 36 [--] Gadget flags */
  struct Bob     *Wallpaper; /* 40 [--] Bob to use as wall paper */
  LONG   Flags;              /* 44 [--] */
  struct TitleBar *TitleBar; /* 48 [--] Pointer to a titlebar */

  /*** Private fields ***/

  struct Bob *prvPointer;
  struct Bob *prvWallpaper;
} OBJDesktop;

#define DSA_MenuBar   (TAPTR|12)
#define DSA_Pointer   (TAPTR|16)
#define DSA_Gadgets   (TLONG|36)
#define DSA_Wallpaper (TAPTR|40)
#define DSA_Flags     (TLONG|44)
#define DSA_TitleBar  (TAPTR|48)

#define DSA_MenuBarTags   (TSTEPIN|TTRIGGER|12)
#define DSA_PointerTags   (TSTEPIN|TTRIGGER|16)
#define DSA_GadgetsTags   (TSTEPIN|TTRIGGER|36)
#define DSA_WallpaperTags (TSTEPIN|TTRIGGER|40)
#define DSA_TitleBarTags  (TSTEPIN|TTRIGGER|48)

/***************************************************************************
** Flags for Desktop->Gadgets
*/

#define GDF_CLOSE 0x00000001
#define GDF_FLIP  0x00000002

/***************************************************************************
** Flags for Desktop->Flags
*/

#define DSF_Tile 0x00000001

/***************************************************************************
** This is the Chain object.  The advantage of an object chain is that
** it allows you to link up lots of objects that don't know anything about
** chaining.
*/

#define VER_CHAIN  1
#define TAGS_CHAIN ((ID_SPCTAGS<<16)|ID_CHAIN)

typedef struct Chain {
  struct Head  *Stats;     /* 00 Standard header */
  struct Chain *Next;      /* 12 Next chain object */
  struct Chain *Prev;      /* 16 Previous chain object */
  APTR Object;             /* 20 Pointer to the object belonging to this node */
} OBJChain;

#define CNA_Next   (TAPTR|12)
#define CNA_Prev   (TAPTR|16)
#define CNA_Object (TAPTR|20)

/***************************************************************************
** These are Window gadgets, the Window class holds pointers to them
** privately.  Since they are standard DPK objects, you can enhance them,
** add animations to gadgets etc...
*/

struct GadClose {
  struct Head Head;    /* Standard header structure */
  struct Bob  *Image;  /* Gadget Image (Bob) */
};

struct GadIconify {
  struct Head *Stats;  /* Standard header structure */
  struct Bob *Image;   /* Gadget Image (Bob) */
};


struct GadMaximise {
  struct Head *Stats;  /* Standard header structure */
  struct Bob *Image;   /* Gadget Image (Bob) */
};

struct GadResize {
  struct Head *Stats;  /* Standard header structure */
  struct Bob *Image;   /* Gadget Image (Bob) */
};

/***************************************************************************
** Icon Object.
**
** Most visual information, such as the coordinates, image data etc are
** inherited from the Bob and the text comes from the Font obejct.
*/

#define TAGS_ICON ((ID_SPCTAGS<<16)|ID_ICON)
#define VER_ICON  1

typedef struct Icon {
  struct Head Head;   /* [00] Standard header structure */
  struct Bob  *Bob;   /* [12] The drawable part of the icon */
  struct Font *Font;  /* [16] What font should we use to print the name [O] */
  BYTE   *Name;       /* [20] The name to appear under the image */

  /*** Private fields ***/

  LONG   prvAFlags;
  struct Bob  *prvBob;
  struct Font *prvFont;
} OBJIcon;

#define ICA_Bob  (TAPTR|12)
#define ICA_Font (TAPTR|16)
#define ICA_Name (TAPTR|20)

#define ICA_BobTags  (TAPTR|TTRIGGER|12)
#define ICA_FontTags (TAPTR|TTRIGGER|16)

/***************************************************************************
** TitleBar Object.
*/

#define TAGS_TITLEBAR ((ID_SPCTAGS<<16)|ID_TITLEBAR)
#define VER_TITLEBAR  1

typedef struct TitleBar {
  struct Head Head;             /* [00 R-] Standard header structure */
  struct Font   *Font;          /* [12 RI] Font to use for the title */
  struct Bob    *Tile;          /* [16 RI] The Bob that is being used for tiling */
  struct Bitmap *prvDestBitmap; /* [20 --] Private. */
  BYTE   *Name;                 /* [24 RI] Name/Caption of the titlebar */
  APTR   Parent;                /* [28 RI] Who owns the title bar */
  LONG   BackColour;            /* [32 RW] RGB background colour */
  LONG   HighColour;            /* [36 RW] RGB highlight colour */
  LONG   DarkColour;            /* [40 RW] RGB dark colour */
  struct Font *prvFont;         /* [44 --] Private */
  WORD   LeftMargin;            /* [48 RW] X offset from the parent X/Y */
  WORD   TopMargin;             /* [50 RW] Y offset from the parent X/Y */
  WORD   Height;                /* [52 RW] Height of this titlebar */
  WORD   Alignment;             /* [54 RW] Align to left, center or right */
  WORD   RightMargin;           /* [56 RW] Pixel space to leave on the right */
  WORD   emp;                   /* [58 --] */
  struct Bob *prvTile;          /* [60 --] Private */
} OBJTitleBar;

#define ALIGN_LEFT   1
#define ALIGN_RIGHT  2
#define ALIGN_CENTER 3

#define TBA_Font        (TAPTR|12)
#define TBA_Tile        (TAPTR|16)
#define TBA_Name        (TBYTE|24)
#define TBA_Parent      (TAPTR|28)
#define TBA_BackColour  (TLONG|32)
#define TBA_HighColour  (TLONG|36)
#define TBA_DarkColour  (TLONG|40)
#define TBA_LeftMargin  (TWORD|48)
#define TBA_TopMargin   (TWORD|50)
#define TBA_Height      (TWORD|52)
#define TBA_Alignment   (TWORD|54)
#define TBA_RightMargin (TWORD|56)

#define TBA_FontTags    (TSTEPIN|TTRIGGER|12)
#define TBA_TileTags    (TSTEPIN|TTRIGGER|16)

#endif /* DESKTOP_DESKTOP_H */
