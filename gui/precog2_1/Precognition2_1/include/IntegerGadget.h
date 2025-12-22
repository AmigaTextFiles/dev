/* ==========================================================================
**
**                               IntegerGadget.h
**
** PObject<GraphicObject<Interactor<Valuator<StringGadget<IntegerGadget
**
**
** ©1991 WILLISoft
**
*/

#ifndef INTEGERGADGET_H
#define INTEGERGADGET_H


#include "StringGadget.h"
#include "Valuator.h"


typedef StringGadget IntegerGadget;


void IntegerGadget_Init __PARMS((
                        IntegerGadget *gadget,
                         PIXELS        LeftEdge,
                         PIXELS        TopEdge,
                         PIXELS        Width,
                         USHORT        nChars,
                         pcg_3DPens    Pens,
                         char         *label
                       ));

/* Additions for Builder prototypes -- EDB */

struct ValuatorClass *IntegerGadgetClass __PARMS(( void ));

void IntegerGadgetClass_Init __PARMS(( struct ValuatorClass *class ));

#endif
