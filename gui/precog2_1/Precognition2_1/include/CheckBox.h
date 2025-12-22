/* ==========================================================================
**
**                          CheckBox.h
**
** PObject<GraphicObject<Interactor<Valuator<BoolGadget<CheckBox
**
** A 'CheckBox' is a gadget which toggles a check mark on and off.
**
** ©1991 WILLISoft
**
** ==========================================================================
*/

#ifndef CHECKBOX_H
#define CHECKBOX_H


#include "parms.h"
#include "BoolGadget.h"


typedef BoolGadget CheckBox;


void CheckBox_Init __PARMS((

                    CheckBox   *self,
                    PIXELS      LeftEdge,
                    PIXELS      TopEdge,
                    pcg_3DPens  Pens,
                    char       *title,
                    BOOL        Selected
                  ));

/* Additions for Builder Prototypes -- EDB */

struct ValuatorClass *CheckBoxClass __PARMS(( void ));

#endif
