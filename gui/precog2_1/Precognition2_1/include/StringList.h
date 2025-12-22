/* ==========================================================================
**
**                         StringList.h
** ©1991 WILLISoft
**
** ==========================================================================
*/

#ifndef STRINGLIST_H
#define STRINGLIST_H

#include <exec/types.h>
#include "parms.h"

typedef struct StringList
{
   char   **Entries;     /* Pointer to an array of strings. */
   UBYTE   *Qualifiers;  /* An array of byte flags */
   USHORT   nEntries;    /* # of entries. */
} StringList;


void StringList_Init __PARMS((
                           StringList *slist, BOOL Qualify
                    ));
   /*
   ** If 'Qualify == TRUE', then the Qualifier array is used,
   ** otherwise it is not.
   */

void StringList_CleanUp __PARMS((
                          StringList *slist
                       ));

BOOL StringList_AddString __PARMS((
                           StringList *slist,
                           char       *string,
                           BYTE        qualifier
                         ));
   /*
   ** Returns false if couldn't allocate memory.
   */

BOOL StringList_AddStrings __PARMS((
                            StringList  *slist,
                            char       **strings,
                            BYTE        *qualifiers
                          ));
   /*
   ** This is an easy way of adding a set of strings to a list.
   ** 'strings' is a NULL terminated list of strings that you
   ** added (e.g. {"This", "That", "The other", NULL}; )
   ** 'qualifiers', if not NULL, is an array of BYTE values
   ** to use as the qualifiers.  (These do NOT need to be NULL
   ** terminated).
   */


BOOL StringList_DeleteString __PARMS(( StringList *slist, USHORT n ));
   /*
   ** 'n' is the ordinal number of the string from the
   ** beginning of the list.
   */

BOOL StringList_DeleteAllStrings __PARMS(( StringList *slist ));


void StringList_Sort __PARMS(( StringList *slist ));

BOOL StringList_Dup __PARMS(( StringList *source, StringList *target ));

#endif
