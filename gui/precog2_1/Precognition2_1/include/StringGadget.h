/* ==========================================================================
**
**                   StringGadget.h
**
** ©1991 WILLISoft
**
** ==========================================================================
*/

#ifndef STRINGGADGET_H
#define STRINGGADGET_H


#include "Valuator.h"
#include "EmbossedGadget.h"



typedef EmbossedGadget StringGadget;


void StringGadget_Init __PARMS((
                        StringGadget *gadget,
                        PIXELS        LeftEdge,
                        PIXELS        TopEdge,
                        PIXELS        Width,
                        USHORT        nChars,
                        pcg_3DPens    Pens,
                        char         *label
                       ));

/* Additions for Builder Prototypes -- EDB */

struct ValuatorClass *StringGadgetClass __PARMS(( void ));

#if 0  /* moved to Valuator.h -- EDB */
/*
** NOTE:  The methods 'Value()', and 'SetValue()' should be used
** to retrieve and set the values.  These take/return LONG values.
**
** These macros cast them to (char*).
*/

#define StringValue(i)       (char*) Value(i)
#define SetStringValue(i,s)  (char*) SetValue(i, (LONG)s)

#endif
#endif
