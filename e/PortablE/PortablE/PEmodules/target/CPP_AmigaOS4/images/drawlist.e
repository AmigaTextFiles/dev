/* $Id: drawlist.h,v 1.11 2005/11/10 15:36:44 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/reaction/reaction', 'target/intuition/imageclass'
{#include <images/drawlist.h>}
NATIVE {IMAGES_DRAWLIST_H} CONST

NATIVE {DRAWLIST_Dummy}      CONST DRAWLIST_DUMMY      = (REACTION_DUMMY + $17000)

NATIVE {DRAWLIST_Directives} CONST DRAWLIST_DIRECTIVES = (DRAWLIST_DUMMY+1)
    /* (struct DrawList *) Pointer to drawlist directive array. */

NATIVE {DRAWLIST_RefHeight}  CONST DRAWLIST_REFHEIGHT  = (DRAWLIST_DUMMY+2)
    /* (WORD) Reference height of drawlist. */

NATIVE {DRAWLIST_RefWidth}   CONST DRAWLIST_REFWIDTH   = (DRAWLIST_DUMMY+3)
    /* (WORD) Reference width of drawlist. */

NATIVE {DRAWLIST_DrawInfo}   CONST DRAWLIST_DRAWINFO   = (DRAWLIST_DUMMY+4)
    /* Obsolete!! Do not use. */

/*****************************************************************************/

/* DrawList Primitive Directives */

NATIVE {DLST_END}       CONST DLST_END       = 0

NATIVE {DLST_LINE}      CONST DLST_LINE      = 1
NATIVE {DLST_RECT}      CONST DLST_RECT      = 2
NATIVE {DLST_FILL}      CONST DLST_FILL      = 3
NATIVE {DLST_ELLIPSE}   CONST DLST_ELLIPSE   = 4
NATIVE {DLST_CIRCLE}    CONST DLST_CIRCLE    = 5
NATIVE {DLST_LINEPAT}   CONST DLST_LINEPAT   = 6
NATIVE {DLST_FILLPAT}   CONST DLST_FILLPAT   = 7
NATIVE {DLST_AMOVE}     CONST DLST_AMOVE     = 8
NATIVE {DLST_ADRAW}     CONST DLST_ADRAW     = 9
NATIVE {DLST_AFILL}    CONST DLST_AFILL    = 10
NATIVE {DLST_BEVELBOX} CONST DLST_BEVELBOX = 11
NATIVE {DLST_ARC}      CONST DLST_ARC      = 12
NATIVE {DLST_START}    CONST DLST_START    = 13
NATIVE {DLST_BOUNDS}   CONST DLST_BOUNDS   = 13
NATIVE {DLST_LINESIZE} CONST DLST_LINESIZE = 14

/*****************************************************************************/

/* Pass an array of these via DRAWLIST_Directives.
 * Last entry must be DLST_END!
 */

NATIVE {DrawList} OBJECT drawlist
    {dl_Directive}	directive	:INT
    {dl_X1}	x1	:INT
    {dl_Y1}	y1	:INT
    {dl_X2}	x2	:INT
    {dl_Y2}	y2	:INT
    {dl_Pen}	pen	:INT
ENDOBJECT
