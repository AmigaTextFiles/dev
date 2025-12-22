/*
**  $VER: tabs.h 42.3 (14.2.94)
**  Includes Release 42.1
**
**  Definitions for the tabs BOOPSI gadget class
**
**  (C) Copyright 1994 Commodore-Amiga Inc.
**  All Rights Reserved
*/
/*****************************************************************************/
MODULE 'utility/tagitem'//,'intuition/gadgetclass'
/*****************************************************************************/
#define TL_TEXTPEN    0
#define TL_BACKGROUNDPEN  1
#define TL_FILLTEXTPEN    2
#define TL_FILLPEN    3
#define MAX_TL_PENS     4
/*****************************************************************************/
/* This structure is used to describe the labels for each of the tabs */
OBJECT tagTabLabel                   /* WAS: typedef struct ... */
  tl_Label:PTR TO UBYTE,        /* Label */
  tl_Pens[MAX_TL_PENS]:WORD,    /* Pens */
  tl_Attrs:PTR TO TagItem       /* Additional attributes */

/*****************************************************************************/
/* Additional attributes defined by the tabs.gadget class */
#define TABS_Dummy    (TAG_USER+$04000000)
#define TABS_Labels     (TABS_Dummy+1)
/* (TabLabelP) Array of labels */
#define TABS_Current    (TABS_Dummy+2)
/* (LONG) Current tab */
/*****************************************************************************/
