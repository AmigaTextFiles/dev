/* ==========================================================================
**
**                   Valuator.h
**
** PObject<GraphicObject<Interactor<Valuator
**
** A Valuator is a virtual class, derrived from class Interactor.
** Valuators are those interactors which allow the user to input
** (or select via button interaction) a value.
**
** Examples; CycleGadgets, IntegerGadgets, StringGadgets
**
** ©1991 WILLISoft
**
** ==========================================================================
*/

#ifndef VALUATOR_H
#define VALUATOR_H

#include "Interactor.h"


typedef Interactor Valuator;

void Valuator_Init __PARMS(( Valuator *self ));

LONG Value __PARMS((
                  Valuator *self
          ));
   /*
   ** Returns the current value
   */


LONG SetValue __PARMS((
               Valuator *self,
               LONG selection
             ));
   /*
   ** Sets the current value, returns the value.
   */


/* moved from StringGadget.h -- since they seem to be more universal -- EDB */
/*
** NOTE:  The methods 'Value()', and 'SetValue()' should be used
** to retrieve and set the values.  These take/return LONG values.
**
** These macros cast them to (char*).
*/

#define StringValue(i)       (char *)Value( i )
#define SetStringValue(i,s)  (char *)SetValue( i, (LONG)s )


#endif

