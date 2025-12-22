/* ==========================================================================
**
**                               TitleBox.h
**
** PObject<GraphicObject<TitleBox
**
** A TitleBox is a 3D embossed box with a character title in its
** center.  (Looks kinda like a marquee.)
**
** You can do anything to a TitleBox that you can do with a GraphicObject
** (See GraphicObject.h)
**
** ©1991 WILLISoft
**
** ==========================================================================
*/


#ifndef TITLEBOX_H
#define TITLEBOX_H


#include "GraphicObject.h"
#include "Precognition3D.h"
#include "Precognition_utils.h"

typedef struct TitleBox
   {
      PClass          *isa;
      char           *PObjectName;
      void           *Next; /* Points to next GraphicObject in chain. */
      Point          Location;
      Point          Size;
      pcg_3DBox       BoxBorder;
      pcg_3DPens      Pens;
      PrecogText      ptext;

   } TitleBox;

void TitleBox_Init __PARMS((
                    TitleBox    *self,
                    PIXELS       LeftEdge,
                    PIXELS       TopEdge,
                    PIXELS       Width,
                    PIXELS       Height,
                    pcg_3DPens   Pens,
                    char        *Label
                  ));

/* Additions for builder prototypes -- EDB */
struct GraphicObjectClass *TitleBoxClass __PARMS(( void ));

#endif

