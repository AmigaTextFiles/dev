/* ==========================================================================
**
**                               BoolGadget.h
**
** PObject<GraphicObject<Interactor<Valuator<BoolGadget
**
** A BoolGadget is your basic boolean gadget with a 3D border, and
** a text label in its center.
**
** See Interactor.h, Valuator.h for the list of functions supported by a
** BoolGadget.
**
**
** ©1991, 1992 WILLISoft
**
** ==========================================================================
*/

#ifndef BOOLGADGET_H
#define BOOLGADGET_H

#include "parms.h"
#include "precognition3d.h"
#include "Valuator.h"
#include "EmbossedGadget.h"


typedef EmbossedGadget BoolGadget; /* Gadget with a 3D border. */


void BoolGadget_Init __PARMS((
                      BoolGadget *self,
                      PIXELS      LeftEdge,
                      PIXELS      TopEdge,
                      PIXELS      Width,
                      PIXELS      Height,
                      pcg_3DPens  Pens,
                      char       *title
                    ));

/* Additions for Builder Prototypes */

struct ValuatorClass *BoolGadgetClass( void );

void BoolGadgetClass_Init( struct ValuatorClass *class );

#endif
