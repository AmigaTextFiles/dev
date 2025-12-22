#ifndef PRECOGNITION_UTILS_H
#define PRECOGNITION_UTILS_H

#include <intuition/intuition.h>
#include "intuition_typedefs.h"
#include "parms.h"

#ifndef PRECOGNITION_UTILS_BODY
extern TextAttr pcg_Topaz80;
#endif



#define pcg_GadgetRelativeCoords( g,e) GadgetRelativeCoods(g,e)
/* Translates the MouseX, MouseY coordinates of a gadget-related
 * IntuiMessage into coordinates which are relative to the gadget
 * (instead of the window.)
 */



void ChainGadgets __PARMS(( Gadget *start_of_chain, Gadget *gadget ));



typedef struct AlignInfo   /* Used for alignment of text to objects */
{
   UBYTE Flags;
   BYTE  Xpad;
   BYTE  Ypad;
} AlignInfo;

/* Text Alignment Flags */
#define tx_LEFT      1
#define tx_XCENTER   2
#define tx_RIGHT     4
#define tx_TOP       8
#define tx_YCENTER   16
#define tx_BOTTOM    32
#define tx_INSIDE    64
#define tx_OUTSIDE   128

#define STD_XPAD 4   /* Standard XPad value. */
#define STD_YPAD 2   /* Standard YPad value. */


/*
** This is a 'value added' version of 'struct IntuiText'
**
** An 'AlignInfo' structure is appended to the end of the
** IntuiText data.  This information allows an object to
** intelligently reposition of the text when the object
** is resized.
*
*    Additions by EDB October 21, 1994
** A (LONG) TextLength member was added so we could cache the
*  results of IntuiTextLength() for width information.
*/

typedef struct PrecogText
{
#if 0  /* same as struct IntuiText */
   struct IntuiText  PText ;
#endif
   UBYTE             FrontPen,
                     BackPen;   /* the pen numbers for the rendering */
   UBYTE             DrawMode;  /* the mode for rendering the text */
   SHORT             LeftEdge;  /* relative start location for the text */
   SHORT             TopEdge;   /* relative start location for the text */
   struct TextAttr  *ITextFont; /* if NULL, you accept the default */
   UBYTE            *IText;     /* pointer to null-terminated text */
   struct IntuiText *NextText;  /* continuation to TxWrite another text */

   AlignInfo         alignment;
   LONG              TextLength;
} PrecogText;


void AlignText __PARMS((
				PrecogText        *ptext,
            Point              size ));
   /*
   ** Aligns text 'ptext' relative to an object of
   ** dimensions 'size'.
   */

/* Added Function -- EDB */
void pcgTextSize __PARMS(( PrecogText    *ptext));
   /*
   ** Sets the PrecogText TextLength field by using IntuiTextLength()
   ** function on the text string with the given font attributes
   */

#endif
