/* ==========================================================================
**
**                               OutlineBox.h
**
** PObject<GraphicObject<OutlineBox
**
** An OutlineBox is a 3D grooved box with a character title along its
** top center.  These are usually used to group related gadgets together.
**
** You can do anything to an OutlineBox that you can do with a GraphicObject
** (See GraphicObject.h)
**
** ©1991 WILLISoft
**
** ==========================================================================
*/


#ifndef OUTLINEBOX_H
#define OUTLINEBOX_H


#include "GraphicObject.h"
#include "Precognition3D.h"
#include "Precognition_utils.h"

typedef struct OutlineBox
   {
      PClass          *isa;
      char           *PObjectName;
      void           *Next; /* Points to next GraphicObject in chain. */
      Point          Location;
      Point          Size;
      pcg_3DThinBevel Bevel;
      pcg_3DPens      Pens;
      char           *Label;

   } OutlineBox;

void OutlineBox_Init __PARMS((
                       OutlineBox  *self,
                       PIXELS       LeftEdge,
                       PIXELS       TopEdge,
                       PIXELS       Width,
                       PIXELS       Height,
                       pcg_3DPens   Pens,
                       char        *Label
                     ));

/* Additions for Builder prototypes -- EDB */

struct GraphicObjectClass *OutlineBoxClass __PARMS(( void ));


#endif

