/* ==========================================================================
**
**                         StringLister.h
**
** PObject<GraphicObject<Interactor<StringLister
**
** A StringLister is an object whose primary purpose in life is to
** manage a list of strings.  (ScrollingLists, ListEditors)
**
** ©1991, 1992 WILLISoft
**
** ==========================================================================
*/

#ifndef STRINGLISTER_H
#define STRINGLISTER_H

#include "Interactor.h"
#include "StringList.h"


typedef Interactor StringLister;


BOOL AddString __PARMS((
                  StringLister *self, char *string, UBYTE qualifier
              ));

BOOL DeleteString __PARMS(( StringLister *self, USHORT i ));


BOOL DeleteAllStrings __PARMS(( StringLister *self ));

StringList *StringList_of __PARMS(( StringLister *self ));
   /*
   ** IMPORTANT: Treat the returned list as *READ ONLY*
   */

void SelectString __PARMS((
                     StringLister *self,
                     USHORT i,
                     BOOL select
                 ));

#endif
