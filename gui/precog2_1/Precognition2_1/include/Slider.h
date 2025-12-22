/* ==========================================================================
**
**                             Slider.h
**
** PObject<GraphicObject<Interactor<Valuator<Positioner<Sliders
**
** Sliders are proportional gadgets.
**
**
** ©1991 WILLISoft
**
** ==========================================================================
*/

#ifndef SLIDER_H
#define SLIDER_H

#include "Precognition3D.h"
#include "pcgWindow.h"
#include "EmbossedGadget.h"
#include "Positioner.h"

typedef struct SliderMap
   {
      SHORT Min;
      SHORT Max;
      SHORT Pot;
      SHORT Body;
   } SliderMap;
   /* This data type is used to 'map' the desired range of a
   ** a PropGadget to its actual range.  (i.e. Intuition uses
   ** a range of 0..65536.  Usually the application has another
   ** range in mind.
   */


typedef struct Slider
{
   EmbossedGadget   eg;
   struct PropInfo  Prop;
   WORD             AutoKnob[4];
} Slider;


#endif
