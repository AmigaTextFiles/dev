/* $VER: palette.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/reaction/reaction', 'target/intuition/gadgetclass'
MODULE 'target/exec/types', 'target/graphics/rastport', 'target/graphics/gfx', 'target/intuition/screens'
{#include <gadgets/palette.h>}
NATIVE {GADGETS_PALETTE_H} CONST

/* Additional attributes defined by the Palette class */
NATIVE {PALETTE_Dummy}        CONST PALETTE_DUMMY        = (REACTION_DUMMY + $0004000)

NATIVE {PALETTE_Colour}       CONST PALETTE_COLOUR       = (PALETTE_DUMMY + 1)
    /* (UWORD) Index of current palette color (pen number). Defaults to 0. */

NATIVE {PALETTE_ColourOffset} CONST PALETTE_COLOUROFFSET = (PALETTE_DUMMY + 2)
    /* (UWORD) Index of first palette color to display. Defaults to 0. */

NATIVE {PALETTE_ColourTable}  CONST PALETTE_COLOURTABLE  = (PALETTE_DUMMY + 3)
    /* (UWORD *) Table of colors to use in the palette. Defaults to NULL. */

NATIVE {PALETTE_NumColours}   CONST PALETTE_NUMCOLOURS   = (PALETTE_DUMMY + 4)
    /* (UWORD) Number of colors in the palette (power of 2). Defaults to 4. */

NATIVE {PALETTE_MinColours}   CONST PALETTE_MINCOLOURS   = (PALETTE_DUMMY + 5)
	/* (UWORD) Minimum amount of colours to display (power of 2). Defaults to 4. */
	
NATIVE {PALETTE_RenderHook}   CONST PALETTE_RENDERHOOK   = (PALETTE_DUMMY + 7)
    /* (struct Hook *) Render hook for palette boxes. Defaults to NULL. */

/*****************************************************************************/

/* The different types of messages that a palette callback hook can see */
NATIVE {PB_DRAW} CONST PB_DRAW = $202  /* Draw yourself, with state */

/* Possible return values from a callback hook */
NATIVE {PBCB_OK}      CONST PBCB_OK      = 0  /* Callback understands this message type    */
NATIVE {PBCB_UNKNOWN} CONST PBCB_UNKNOWN = 1  /* Callback does not understand this message */

/* States for PBoxDrawMsg.pbdm_State */
NATIVE {PBR_NORMAL}           CONST PBR_NORMAL           = 0  /* Unselected box */
NATIVE {PBR_SELECTED}         CONST PBR_SELECTED         = 1  /* Selected (active) box */
NATIVE {PBR_NORMALDISABLED}   CONST PBR_NORMALDISABLED   = 2  /* Disabled unselected box */
NATIVE {PBR_SELECTEDDISABLED} CONST PBR_SELECTEDDISABLED = 8  /* Disabled selected (active) box */

/* Messages received by a palette callback hook */
NATIVE {PBoxDrawMsg} OBJECT pboxdrawmsg
    {pbdm_MethodID}	methodid	:ULONG  /* PB_DRAW */
    {pbdm_RastPort}	rastport	:PTR TO rastport  /* Where to render to */
    {pbdm_DrawInfo}	drawinfo	:PTR TO drawinfo  /* Useful to have around */
    {pbdm_Bounds}	bounds	:rectangle    /* Limits of where to render */
    {pbdm_State}	state	:ULONG     /* How to render */
    {pbdm_Color}	color	:ULONG     /* Color index in palette */
    {pbdm_Gadget}	gadget	:PTR TO gadget    /* The palette gadget */
ENDOBJECT

/*****************************************************************************/

/* American spellings. */
NATIVE {PALETTE_Color}       CONST PALETTE_COLOR       = PALETTE_COLOUR
NATIVE {PALETTE_ColorOffset} CONST PALETTE_COLOROFFSET = PALETTE_COLOUROFFSET
NATIVE {PALETTE_ColorTable}  CONST PALETTE_COLORTABLE  = PALETTE_COLOURTABLE
NATIVE {PALETTE_NumColors}   CONST PALETTE_NUMCOLORS   = PALETTE_NUMCOLOURS
