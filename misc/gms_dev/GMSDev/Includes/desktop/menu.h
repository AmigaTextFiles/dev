#ifndef DESKTOP_MENU_H
#define DESKTOP_MENU_H TRUE

/*
**  $VER: menu.h V1.0
**
**  Menu Definitions.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

/***************************************************************************
** Menu bar.
*/

#define TAGS_MENUBAR ((ID_SPCTAGS<<16)|ID_MENUBAR)
#define VER_MENUBAR  1

struct MenuBar {
  struct Head   Head;         /* Standard header structure */
  struct Font   *TitleFont;   /* Font to use for menu bar */
  struct Bitmap *Background;  /* If you want a picture in the background */
  BYTE   *Title;              /* Title to appear on the menu bar */
  LONG   BackgroundRGB;       /* The background colour */
  LONG   Style;               /* Sunken, Raised... */
};

#define STYLE_RAISED     0x00000001
#define STYLE_SUNKEN     0x00000002
#define STYLE_FLAT       0x00000004
#define STYLE_BORDERLESS 0x00000008

/***************************************************************************
** Menu.
*/

#define TAGS_MENU ((ID_SPCTAGS<<16)|ID_MENU)
#define VER_MENU  1

struct Menu {
  struct Head     Head;       /* Standard header structure */
  struct MenuItem *FirstItem; /* First item in the menu */
  struct Bitmap   *BackImage; /* Background image */
  LONG   BackgroundRGB;       /* Background colour */
  LONG   Style;               /* SUNKEN, RAISED... */

  /*** Private fields ***/

  WORD Width;    /*  */
  WORD Lines;    /* How many lines of the menu should be displayed */
};

/***************************************************************************
** Menu Item.
*/

#define TAGS_MENUITEM ((ID_SPCTAGS<<16)|ID_MENUITEM)
#define VER_MENUITEM  1

struct MenuItem {
  struct Head Head;    /* Standard header structure */
  struct Font *Font;   /* What font to use */
  BYTE   *Name;        /* Name of the menu item */
  LONG   Flags;
};

#define MI_CHECKMARK 0x00000001
#define MI_BAR       0x00000002 /* If this is a bar */

#endif /* DESKTOP_MENU_H */
