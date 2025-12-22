/*
**  $VER: page.h 44.1 (19.10.1999)
**  Includes Release 44.1
**
**  Page gadget definitions
**
** Page gadget is part of layout.gadget
**
**  (C) Copyright 1987-1999 Amiga, Inc.
**      All Rights Reserved
*/
/*****************************************************************************/
//MODULE 'reaction/reaction','intuition/gadgetclass'
/*****************************************************************************/
#define PAGE_Dummy        (TAG_USER+$04200000)
#define PAGE_Add        (PAGE_Dummy+1)
/*  (Object *)
 *  Add a page to the end of a page group */
#define PAGE_Remove         (PAGE_Dummy+2)
/*  (Object *)
 *  Remove a page from the page group */
#define PAGE_Current      (PAGE_Dummy+3)
/*  (ULONG)
 *  Make the n'th page visible. Can be directly connected with tabs.gadget */
#define PAGE_FixedVert      (PAGE_Dummy+4)
#define PAGE_FixedHoriz       (PAGE_Dummy+5)
/*  (BOOL)
 *  Same function as layout.gadget Fixed tags */
