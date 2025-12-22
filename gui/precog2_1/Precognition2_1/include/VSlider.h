/* ==========================================================================
**
**                         VSlider.h
**
** Vertical Slider (propgadget)
**
** ©1991 WILLISoft
**
** ==========================================================================
*/

#ifndef VSLIDER_H
#define VSLIDER_H

#include "Slider.h"


typedef Slider VSlider;

void VSlider_Init __PARMS((
                   VSlider      *self,
                   PIXELS        LeftEdge,
                   PIXELS        TopEdge,
                   PIXELS        Width,
                   PIXELS        Height,
                   pcg_3DPens    Pens,
                   char         *label
                 ));

/* Additions for Builder prototypes -- EDB */

   struct PositionerClass *VSliderClass __PARMS(( void ));

#endif
