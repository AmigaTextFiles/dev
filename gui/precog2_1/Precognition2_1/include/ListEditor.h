/* ==========================================================================
**
**                            ListEditor.h
**
** ©1991 WILLISoft
**
** ==========================================================================
*/

#ifndef LISTEDITOR_H
#define LISTEDITOR_H

#include "StringLister.h"
#include "ScrollingList.h"
#include "StringGadget.h"
#include "BoolGadget.h"


typedef struct ListEditor
{
   StringLister   slist;   /* Required object info.      */
   USHORT         state;   /* PRIVATE!                   */
   USHORT         s;       /* PRIVATE!                   */
   USHORT         nchars;  /* max # of chars in string.  */
   ScrollingList  browse;  /* list of strings.           */
   StringGadget   edit;    /* gadget to edit strings.    */
   BoolGadget     add,     /* Button to add a new string */
                  delete;  /* Button to delete a string. */
}  ListEditor;

/*
** NOTE: All strings are dynamically allocated!
*/

void ListEditor_Init __PARMS(( ListEditor *self,
                      PIXELS      LeftEdge,
                      PIXELS      TopEdge,
                      PIXELS      Width,
                      PIXELS      Height,
                      pcg_3DPens  pens,
                      char       *label ));

/* Additions for Builder Prototypes -- EDB */

struct StringListerClass *ListEditorClass __PARMS(( void ));

#endif

