/* ==========================================================================
**
**                       Precognition3D.h
**
**
** ©1991 WILLISoft
**
** ==========================================================================
*/

#ifndef PRECOGNITION3D_H
#define PRECOGNITION3D_H

#include "intuition_typedefs.h"
#include "parms.h"

typedef struct pcg_3DPens
   {
      UBYTE FrontPen,   BackPen;    /* Foreground Pen, Background Pen */
      UBYTE BrightPen,  DarkPen;    /* 3D Highlight, shadow.          */
   } pcg_3DPens;


/* ==================== pcg_3DBox ============================
** This type is compatible with a 'Border' structure.
** It is used to create a 3D looking box, like under
** Workbench 2.0.  It consists of 2 Border structures linked
** together.
** ===========================================================
*/

typedef struct pcg_3DBox
   {
      Border     TopLeft;       /* Top & Left edge of box.     */
      Border     BottomRight;   /* Bottom & right edge of box. */
      SHORT      Points[20];    /* Box outline.                */
   } pcg_3DBox;

/* ======================= pcg_3DBevel ========================
** This type is compatible with a 'Border' structure.
** It is used to create a 3D looking Bevel, like the string
** gadgets under Workbench 2.0.
** ============================================================
*/

typedef struct pcg_3DBevel
   {
      pcg_3DBox Outer, Inner;
   } pcg_3DBevel;


typedef struct pcg_3DThinBevel
   {
      Border         b[4];
      SHORT          Points[20];
   } pcg_3DThinBevel;
   /*
   ** ThinBevels are 2 pixels along the X axis, they're used for
   ** embossed outline boxes.
   */


pcg_3DPens StandardPens __PARMS((void));
   /*
   ** Returns the standard color pens.  This works for both
   ** Workbench 1.2/3 and Workbench 2.0.
   */


pcg_3DPens StandardScreenPens __PARMS(( struct Screen *whichscreen ));
   /*
   ** Written as a replacement for pcg_3DPens() -- EDB
   ** This function is not tested under AmigaDOS 1.3 yet.
   **
   ** Returns the standard color pens. depending on depth of whichscreen.
   ** If whichscreen == NULL, Workbench is presumed for Amiga OS 1.3 and
   **    the default public screen is presumed for Amiga OS 2.x and above.
   ** Monochrome screens get a proper 2D style look and screens with
   ** Depths of 2 and greater are accomodated with proper pens for 3D style.
   */

void pcg_Init3DBox __PARMS((
                        pcg_3DBox *Box,
                        SHORT      LeftEdge,
                        SHORT      TopEdge,
                        USHORT     Width,
                        USHORT     Height,
                        UBYTE      TopLeftPen,
                        UBYTE      BottomRightPen,
                        Border    *NextBorder
                  ));


void pcg_Init3DBevel __PARMS((
                        pcg_3DBevel *Bevel,
                        SHORT        LeftEdge,
                        SHORT        TopEdge,
                        USHORT       Width,
                        USHORT       Height,
                        USHORT       BevelWidth,
                        UBYTE        TopLeftPen,
                        UBYTE        BottomRightPen,
                        Border      *NextBorder
                    ));

/* LeftEdge, TopEdge, Width, Height refer to the _outer_ box.
**
** 'BevelWidth' is the amount of blankspace between the inner and
** outer border.  (0 is an ok value.)
**
** If 'TopLeftPen' is bright, and 'BottomRightPen' is dark, the bevel
** will appear to stand out.  If 'TopLeftPen' is dark, the bevel will
** appear recessed.
*/

void pcg_Init3DThinBevel __PARMS((
                           pcg_3DThinBevel *Bevel,
                           SHORT            LeftEdge,
                           SHORT            TopEdge,
                           USHORT           Width,
                           USHORT           Height,
                           USHORT           BevelWidth,
                           UBYTE            TopLeftPen,
                           UBYTE            BottomRightPen,
                           Border          *NextBorder
                        ));


#endif
