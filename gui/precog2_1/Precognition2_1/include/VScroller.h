/* ==========================================================================
**
**                         VScroller.h
**
** Vertical Scroller  (a slider with up/down arrows)
**
** ©1991 WILLISoft
**
** ==========================================================================
*/

#ifndef VSCROLLER_H
#define VSCROLLER_H


#include "VSlider.h"
#include "ArrowGadget.h"


typedef struct VScroller
   {
      Positioner         posr;
      pcg_3DPens         Pens;
      VSlider            vslider;
      ArrowGadget        uparrow;
      ArrowGadget        downarrow;
   } VScroller;


void VScroller_Init __PARMS((
                     VScroller    *self,
                     PIXELS        LeftEdge,
                     PIXELS        TopEdge,
                     PIXELS        Height,
                     pcg_3DPens    Pens,
                     char         *label
                   ));

/* Additions for builder prototypes -- EDB */
struct PositionerClass *VScrollerClass __PARMS(( void ));

#endif
