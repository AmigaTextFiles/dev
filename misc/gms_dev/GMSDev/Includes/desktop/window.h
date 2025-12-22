#ifndef DESKTOP_WINDOW_H
#define DESKTOP_WINDOW_H TRUE

/*
**  $VER: window.h V1.0
**
**  Window Definitions.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

/****************************************************************************
** Window.  NB: All windows cooperate with the desktop so you
** need an Exclusive lock on a window before doing anything
** to it.
**
** The window events are:
**
**  OnClick:
**  OffClick:
*/

#define TAGS_WINDOW ((ID_SPCTAGS<<16)|(ID_WINDOW))
#define VER_WINDOW  1

typedef struct Window {
  struct Head Head;               /* [--] Private */
  struct MenuBar   *MenuBar;      /* [RI] Optional menu bar */
  struct TitleBar  *TitleBar;     /* [RI] Option title bar */
  struct Bob       *Pointer;      /* [RI] If pointer should change from Desktop */
  struct Desktop   *Desktop;      /* [R-] The desktop that owns the window */
  struct ScrollBar *VertScroll;   /* [R-] Pointer to the vertical scroll bar */
  struct ScrollBar *HorzScroll;   /* [R-] Pointer to the horizontal scroll bar */
  struct Bitmap    *BackImage;    /* [RI] Background wallpaper or tiles */
  struct Font      *TitleFont;    /* [RI] The font type for our title bar */
  WORD   MinWidth;                /* [RI] */
  WORD   MaxWidth;                /* [RI] */
  WORD   MinHeight;               /* [RI] */
  WORD   MaxHeight;               /* [RI] */
  WORD   AreaWidth;               /* [RI] Maximum area width of our window */
  WORD   AreaHeight;              /* [RI] Maximum area height of our window */
  WORD   Width;                   /* [RI] Current width of our window */
  WORD   Height;                  /* [RI] Current height of our window */
  WORD   XCoord;                  /* [RI] X coordinate of the window */
  WORD   Ycoord;                  /* [RI] Y coordinate of the window */
  BYTE   *Title;                  /* [RI] "My Window" */
  LONG   Gadgets;                 /* [RI] Gadget flags like GAD_CLOSE */
  LONG   Style;                   /* [RI] Look and feel, eg STYLE_SUNKEN */
  LONG   BackColour;              /* [RI] The colour of the background */
  LONG   BackOptions;             /* [RI] WNB_TILE, WNB_CENTRE */
  struct ObjectChain *Children;   /* [R-] A chain of all children inside the window (icons etc). */
} OBJWindow;

/***********************************************************************************
** General gadget flags, apply to both Desktop and Window.
*/

#define GAD_CLOSE    0x00000001  /* Show the close button */
#define GAD_ICONIFY  0x00000002  /* Show the iconify button */
#define GAD_MAXIMISE 0x00000004  /* Show the maximise button */
#define GAD_RESIZE   0x00000008  /* The resize gadget */

/***********************************************************************************
** Window background flags.
*/

#define WNB_TILE     0x00000001  /* Tile the background bitmap */
#define WNB_CENTRE   0x00000002  /* Centre the background bitmap */

