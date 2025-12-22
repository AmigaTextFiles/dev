/* ==========================================================================
**
**                   Positioner.h
** PObject<GraphicObject<Interactor<Valuator<Positioner
**
** A Positioner is a virtual class, derrived from class Valuator.
** Positioners are proportional gadgets.
**
**
** ©1991 WILLISoft
**
** ==========================================================================
*/

#ifndef POSITIONER_H
#define POSITIONER_H

#include "Valuator.h"



typedef Valuator Positioner;



USHORT KnobSize __PARMS((
                     Positioner *self
               ));
   /*
   ** Returns the size of the knob (range 0..0xFFFF).
   */


USHORT SetKnobSize __PARMS((
                     Positioner *self,
                     USHORT knobsize
                  ));
   /*
   ** Sets the size of the knob. Returns its size.
   */

void Positioner_Init __PARMS(( Positioner *self ));

#endif


