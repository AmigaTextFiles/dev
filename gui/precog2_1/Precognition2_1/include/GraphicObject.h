/* ==========================================================================
**
**                               GraphicObject.h
**
** PObject<GraphicObject
**
** A GraphicObject is a virtual class, derrived from class PObject.
** Potentially anything that can be drawn on a RastPort is a
** graphic object.
**
**
** ©1991 WILLISoft
**
** ==========================================================================
*/

#ifndef GRAPHICOBJECT_H
#define GRAPHICOBJECT_H

#include "PObject.h"
#include "Intuition_typedefs.h"
#include "Precognition_utils.h"

typedef struct GraphicObject
   {
      const PClass   *isa;
      char    *PObjectName;
      void    *Next;        /* Points to next GraphicObject in chain. */
   } GraphicObject;




Point Location __PARMS((
                  GraphicObject *self
              ));
   /*
   ** Returns the LeftEdge, TopEdge of 'self'.
   */



Point SetLocation __PARMS((
                   GraphicObject *self,
                   PIXELS         LeftEdge,
                   PIXELS         TopEdge
                  ));
   /*
   ** Sets the LeftEdge, TopEdge of 'self'.
   ** Returns the LeftEdge, TopEdge.
   */


Point Size __PARMS((
                  GraphicObject *self
          ));
   /*
   ** Returns the Width, Height of 'self'.
   */


Point AskSize __PARMS((
               GraphicObject *self,
               PIXELS         Width,
               PIXELS         Height
             ));
   /*
   ** Given a (Width, Height), returns the nearest (Width, Height)
   ** that 'self' modify itself to be.  Does NOT actually change
   ** the dimensions of 'self'.  (Some graphic objects have
   ** constraints on their size.)
   */

#define MinSize(s) AskSize(s,0,0)
#define MaxSize(s) AskSize(s,32767,32767)


Point SetSize __PARMS((
               GraphicObject *self,
               PIXELS         Width,
               PIXELS         Height
              ));
   /*
   ** Sets 'self's size to be as near (Width, Height) as possible,
   ** returns the actual (Width, Height).
   */


UWORD SizeFlags __PARMS((
                  GraphicObject *self
               ));
   /*
   ** Returns the flags which define the axis's on which this object may
   ** be sized.
   ** (This is useful for the editor environment)
   */

#define OBJSIZE_X 0x0001   /* object can be resized along the X axis. */
#define OBJSIZE_Y 0x0002   /* object can be resized along the Y axis. */



void Render __PARMS((
             GraphicObject *self,
             RastPort      *RPort
           ));

   /*
   ** Draw object to RastPort 'RPort'.  The object's Location is
   ** used as the top-left corner of drawing.
   */


/* NOTE: Not all GraphicObjects support titles.   Those that don't
** ignore SetTitle(), and return NULL for Title().
*/

BOOL SetTitle __PARMS((
               GraphicObject *self, char *title
             ));
   /*
   ** returns FALSE if object does not support titles.
   */

char *Title __PARMS((
               GraphicObject *self
            ));
   /*
   ** Returns a pointer to the title of an object, or NULL if none.
   */


/* addition of default font attributes to GraphicObjectClass -- EDB */

/* NOTE: Not all GraphicObjects support Default Fonts.  Those that don't
** ignore SetDefaultFont() and return FALSE and a pointer to Topaz80 for DefaultFont().
** Objects not subclassed off of GraphicObject should return NULL.
*/
TextAttr *DefaultFont __PARMS(( GraphicObject *self ));

BOOL SetDefaultFont __PARMS(( GraphicObject *self, TextAttr *default_font ));
   /*
   ** returns FALSE if object does not support default fonts.
   ** returns FALSE if object cannot open specified font.
   */

AlignInfo *TextAlignment __PARMS((
               GraphicObject *self
		                        ));
   /*
   ** Returns a pointer to the AlignInfo of an object, or NULL if none.
   */

BOOL SetTextAlignment __PARMS((
                            GraphicObject *self,
                            UBYTE          Flags,
                            BYTE         Xpad,
                            BYTE         Ypad
                           ));
   /*
   ** returns FALSE if object cannot support the given arguments.
   */

void GraphicObject_Init __PARMS(( GraphicObject *self ));

#endif
