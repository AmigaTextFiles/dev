/* ==========================================================================
**
**                         HScroller.h
**
** Horizontal Scroller (a slider with left/right arrows)
**
** ©1991 WILLISoft
**
** ==========================================================================
*/

#ifndef HSCROLLER_H
#define HSCROLLER_H


#include "HSlider.h"
#include "ArrowGadget.h"


typedef struct HScroller
   {
      Positioner         posr;
      pcg_3DPens         Pens;
      HSlider            hslider;
      ArrowGadget        leftarrow;
      ArrowGadget        rightarrow;
   } HScroller;


void HScroller_Init __PARMS((
                     HScroller    *self,
                     PIXELS        LeftEdge,
                     PIXELS        TopEdge,
                     PIXELS        Width,
                     pcg_3DPens    Pens,
                     char         *label
                   ));

/* Additions for Builder prototypes -- EDB */

struct PositionerClass *HScrollerClass __PARMS(( void ));

#endif
