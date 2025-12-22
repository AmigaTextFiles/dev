/* ==========================================================================
**
**                               ArrowGadget.h
**
** PObject<GraphicObject<Interactor<Valuator<ArrowGadget
**
** An ArrowGadget is a boolean gadget with an arrowhead in its center.
** These are used for the horizontal and vertical scroller interactors.
**
** See Interactor.h, Valuator.h for the list of functions supported by a
** BoolGadget.
**
**
** ©1991 WILLISoft
**
*/

#ifndef ARROWGADGET_H
#define ARROWGADGET_H

#include "parms.h"
#include "precognition3d.h"
#include "BoolGadget.h"

enum ArrowTypes { UpArrow, DownArrow, LeftArrow, RightArrow };


typedef BoolGadget ArrowGadget;


void ArrowGadget_Init __PARMS((
                       ArrowGadget     *self,
                       PIXELS           LeftEdge,
                       PIXELS           TopEdge,
                       enum ArrowTypes  Direction,
                       pcg_3DPens       Pens

                      ));
   /* NOTE: Size is fixed at (16x14) */


#endif

