/* ==========================================================================
**
**                             CycleGadget.h
**
** PObject<GraphicObject<Interactor<Valuator<CycleGadget
**
**
** ©1991 WILLISoft
**
** ==========================================================================
*/

#ifndef CYCLEGADGET_H
#define CYCLEGADGET_H


#include "BoolGadget.h"
#include "StringList.h"

/* PObject<GraphicObject<Interactor<Valuator<BoolGadget<CycleGadget */

typedef struct CycleGadget
{
   BoolGadget  bg;
   StringList  sl;
   IntuiText   Format;
} CycleGadget;


void CycleGadget_Init __PARMS((
                       CycleGadget *cyclegadget,
                       PIXELS       LeftEdge,
                       PIXELS       TopEdge,
                       PIXELS       Width,
                       pcg_3DPens   Pens,
                       char        *label,
                       char       **Choices
                     ));

   /* 'Choices is a null terminated array of strings which
   ** define the cycle-gadget choices.  e.g.
   **
   **    char *choices[] = { "this", "that", "the other", NULL };
   **
   ** The NULL terminator is mandatory.
   */

/* Additions for Builder Prototypes -- EDB */

struct ValuatorClass *CycleGadgetClass __PARMS(( void ));

#endif
