/* ==========================================================================
**
**                         ListBrowser.h
**
** PObject<GraphicObject<Interactor<StringLister<ListBrowser
**
** A ListBrowser displays a list of strings, and allows the user to select
** one or more of them.
**
** ©1991 WILLISoft
**
** ==========================================================================
*/

#ifndef LISTBROWSER_H
#define LISTBROWSER_H

#include "StringList.h"
#include "StringLister.h"
#include "Precognition3D.h"
#include "EmbossedGadget.h"

typedef struct ListBrowser
   {
      EmbossedGadget     eg;
      StringList         List;
      BOOL               SelectMany;
      USHORT             nRows;
      USHORT             nColumns;
      USHORT             YOffset;
   } ListBrowser;




void ListBrowser_Init __PARMS((
                       ListBrowser   *self,
                       PIXELS         LeftEdge,
                       PIXELS         TopEdge,
                       PIXELS         Width,
                       PIXELS         Height,
                       pcg_3DPens     Pens,
                       BOOL           SelectMany
                    ));

/* Added for prototype needed by ScrollingList.c in precog.lib */
void ListBrowser_SelectAll __PARMS(( ListBrowser *self, BOOL Select ));

USHORT ListBrowser_SetYOffset __PARMS((
                               ListBrowser *Browser,
                               USHORT       YOffset
                             ));
/*
**  Scrols the list to set YOffset at the top.
**
**  e.g. YOffset = 0  -> the first element in the list is at the top.
**       YOffset = 10 -> the 11th element....
*/



/* -- Qualifiers for 'AddString()'.
**
** ENTRY_SELECTED    : This element is selected.
** ENTRY_SPECIAL     : Displayed in a different pen color.
** ENTRY_DISABLED    : Displayed ghosted.
*/
#define ENTRY_SELECTED     1
#define ENTRY_SPECIAL      2
#define ENTRY_DISABLED     4

#endif
