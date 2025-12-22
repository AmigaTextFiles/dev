/* $VER: space.h 53.29 (10.8.2015) */
OPT NATIVE
MODULE 'target/reaction/reaction', 'target/intuition/gadgetclass'
{#include <gadgets/space.h>}
NATIVE {GADGETS_SPACE_H} CONST

/* Additional attributes defined by the space.gadget class */

NATIVE {SPACE_Dummy}       CONST SPACE_DUMMY       = (REACTION_DUMMY + $9000)

NATIVE {SPACE_MinHeight}   CONST SPACE_MINHEIGHT   = (SPACE_DUMMY+1)
    /* (WORD) Height of space gadget
       (OM_NEW,OM_SET,OM_UPDATE,OM_GET) */

NATIVE {SPACE_MinWidth}    CONST SPACE_MINWIDTH    = (SPACE_DUMMY+2)
    /* (WORD) Width of space gadget
       (OM_NEW,OM_SET,OM_UPDATE,OM_GET) */

NATIVE {SPACE_MouseX}      CONST SPACE_MOUSEX      = (SPACE_DUMMY+3)
    /* (WORD) X Position of Mouse within space gadget
       (OM_NOTIFY) */

NATIVE {SPACE_MouseY}      CONST SPACE_MOUSEY      = (SPACE_DUMMY+4)
    /* (WORD) Y Position of Mouse within space gadget
       (OM_NOTIFY) */

NATIVE {SPACE_Transparent} CONST SPACE_TRANSPARENT = (SPACE_DUMMY+5)
    /* (BOOL) Will not EraseRect() background before redraw if true.
       (OM_NEW,OM_SET,OM_UPDATE) */

NATIVE {SPACE_AreaBox}     CONST SPACE_AREABOX     = (SPACE_DUMMY+6)
    /* (struct IBox **) Inner area IBox application rendering bounds
       (OM_GET) */

NATIVE {SPACE_RenderHook}  CONST SPACE_RENDERHOOK  = (SPACE_DUMMY+7)
    /* (struct Hook *) render hook is called when the gadget refreshes.
       (OM_NEW,OM_SET,OM_UPDATE) */

NATIVE {SPACE_BevelStyle}  CONST SPACE_BEVELSTYLE  = (SPACE_DUMMY+8)
    /* (WORD) Defaults to BVS_NONE (no bevel - see images/bevel.h)
       (OM_NEW,OM_SET,OM_UPDATE) */
     
NATIVE {SPACE_DomainBevel} CONST SPACE_DOMAINBEVEL = (SPACE_DUMMY+9)
    /* (BOOL) take size of bevel into account when calculating
       the gadget size. Defaults to FALSE. (V50)
       (OM_NEW,OM_SET,OM_UPDATE) */

NATIVE {SPACE_RenderBox}   CONST SPACE_RENDERBOX   = (SPACE_DUMMY+10)
    /* (struct IBox *) Inner area IBox application rendering bounds (V53.6) */
