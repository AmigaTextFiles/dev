/* ==========================================================================
**
**                            ScrollingList.h
**
** ©1991, 1992 WILLISoft
**
** ==========================================================================
*/

#ifndef SCROLLINGLIST_H
#define SCROLLINGLIST_H

#include "StringLister.h"
#include "ListBrowser.h"
#include "VScroller.h"


typedef struct ScrollingList
   {
      StringLister       slister;
      pcg_3DPens         Pens;
      ListBrowser        list;
      VScroller          vscroller;
   } ScrollingList;


void ScrollingList_Init __PARMS((
                          ScrollingList *self,
                          PIXELS         LeftEdge,
                          PIXELS         TopEdge,
                          PIXELS         Width,
                          PIXELS         Height,
                          pcg_3DPens     Pens,
                          BOOL           SelectMany
                       ));




USHORT ScrollingList_SetYOffset __PARMS((
                                 ScrollingList *Browser,
                                 USHORT         YOffset
                               ));



/* Additions for Builder prototypes -- EDB */

struct StringListerClass *ScrollingListClass __PARMS(( void ));

void ScrollingListClass_Init __PARMS(( struct StringListerClass *class ));

#endif
