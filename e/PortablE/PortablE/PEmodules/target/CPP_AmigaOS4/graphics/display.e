/* $Id: display.h,v 1.12 2005/11/10 15:36:43 hjfrieden Exp $ */
OPT NATIVE
{#include <graphics/display.h>}
NATIVE {GRAPHICS_DISPLAY_H} CONST

/* bplcon0 defines */
NATIVE {MODE_640}    CONST MODE_640    = $8000
NATIVE {PLNCNTMSK}   CONST PLNCNTMSK   = $7    /* how many bit planes? */
                           /* 0 = none, 1->6 = 1->6, 7 = reserved */
NATIVE {PLNCNTSHFT}  CONST PLNCNTSHFT  = 12     /* bits to shift for bplcon0 */
NATIVE {PF2PRI}      CONST PF2PRI      = $40   /* bplcon2 bit */
NATIVE {COLORON}     CONST COLORON     = $0200 /* disable color burst */
NATIVE {DBLPF}       CONST DBLPF       = $400
NATIVE {HOLDNMODIFY} CONST HOLDNMODIFY = $800
NATIVE {INTERLACE}   CONST INTERLACE   = 4      /* interlace mode for 400 */

/* bplcon1 defines */
NATIVE {PFA_FINE_SCROLL}       CONST PFA_FINE_SCROLL       = $F
NATIVE {PFB_FINE_SCROLL_SHIFT} CONST PFB_FINE_SCROLL_SHIFT = 4
NATIVE {PF_FINE_SCROLL_MASK}   CONST PF_FINE_SCROLL_MASK   = $F

/* display window start and stop defines */
NATIVE {DIW_HORIZ_POS}       CONST DIW_HORIZ_POS       = $7F  /* horizontal start/stop */
NATIVE {DIW_VRTCL_POS}       CONST DIW_VRTCL_POS       = $1FF /* vertical start/stop */
NATIVE {DIW_VRTCL_POS_SHIFT} CONST DIW_VRTCL_POS_SHIFT = 7

/* Data fetch start/stop horizontal position */
NATIVE {DFTCH_MASK} CONST DFTCH_MASK = $FF

/* vposr bits */
NATIVE {VPOSRLOF} CONST VPOSRLOF = $8000
