/* ==========================================================================
**
**                         HSlider.h
**
** PObject<GraphicObject<Interactor<Valuator<Positioner<Slider<HSlider
**
** Horizontal  Slider (propgadget)
**
** ©1991 WILLISoft
**
** ==========================================================================
*/

#ifndef HSLIDER_H
#define HSLIDER_H

#include "Slider.h"


typedef Slider HSlider;

void HSlider_Init __PARMS((
                   HSlider      *self,
                   PIXELS        LeftEdge,
                   PIXELS        TopEdge,
                   PIXELS        Width,
                   PIXELS        Height,
                   pcg_3DPens    Pens,
                   char         *label
                 ));

/* Additions for Builder Prototypes -- EDB */
struct PositionerClass *HSliderClass __PARMS(( void ));

#endif
