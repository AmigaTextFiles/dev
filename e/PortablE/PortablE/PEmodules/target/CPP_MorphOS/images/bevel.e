/* $VER: bevel.h 44.1 (19.10.1999) */
OPT NATIVE
MODULE 'target/reaction/reaction', 'target/intuition/imageclass'
{#include <images/bevel.h>}
NATIVE {IMAGES_BEVEL_H} CONST

NATIVE {BEVEL_Dummy}			CONST BEVEL_DUMMY			= (REACTION_DUMMY + $16000)

NATIVE {BEVEL_Style}			CONST BEVEL_STYLE			= (BEVEL_DUMMY+1)
	/* (USHORT) Selected bevel style, see BEVEL_* defines below */

NATIVE {BEVEL_Label}			CONST BEVEL_LABEL			= (BEVEL_DUMMY+3)
	/* (UBYTE *) Label text, usually for button or group box labels */

NATIVE {BEVEL_LabelImage}	CONST BEVEL_LABELIMAGE	= (BEVEL_DUMMY+4)
	/* (struct Image *) Unsupported label image */

NATIVE {BEVEL_LabelPlace}	CONST BEVEL_LABELPLACE	= (BEVEL_DUMMY+5)
	/* (UBYTE) Label placement, see BVJ_* defines below */

NATIVE {BEVEL_InnerTop}		CONST BEVEL_INNERTOP		= (BEVEL_DUMMY+6)
	/* (ULONG) (OM_GET) - render offset not included */

NATIVE {BEVEL_InnerLeft}		CONST BEVEL_INNERLEFT		= (BEVEL_DUMMY+7)
	/* (ULONG) (OM_GET) - render offset not included */

NATIVE {BEVEL_InnerWidth}	CONST BEVEL_INNERWIDTH	= (BEVEL_DUMMY+8)
	/* (ULONG) (OM_GET) - inner bevel area size */

NATIVE {BEVEL_InnerHeight}	CONST BEVEL_INNERHEIGHT	= (BEVEL_DUMMY+9)
	/* (ULONG) (OM_GET) - inner bevel area size */

NATIVE {BEVEL_HorizSize}		CONST BEVEL_HORIZSIZE		= (BEVEL_DUMMY+10)
	/* (ULONG) (OM_GET) - bevel line thickness */
NATIVE {BEVEL_HorzSize}  CONST BEVEL_HORZSIZE  = BEVEL_HORIZSIZE
	/* OBSOLETE, use BEVEL_HorizSize instead */

NATIVE {BEVEL_VertSize}		CONST BEVEL_VERTSIZE		= (BEVEL_DUMMY+11)
	/* (ULONG) (OM_GET) - bevel line thickness */

NATIVE {BEVEL_FillPen}		CONST BEVEL_FILLPEN		= (BEVEL_DUMMY+12)
	/* (WORD) (OM_NEW/OM_SET) - optional inner bevel fill */

NATIVE {BEVEL_FillPattern}	CONST BEVEL_FILLPATTERN	= (BEVEL_DUMMY+13)
	/* (UWORD *) (OM_NEW/OM_SET) - optional fill pattern for inner fill/disable */

NATIVE {BEVEL_TextPen}		CONST BEVEL_TEXTPEN		= (BEVEL_DUMMY+14)
	/* (WORD) (OM_NEW/OM_SET) - optional text pen color */

NATIVE {BEVEL_Transparent}	CONST BEVEL_TRANSPARENT	= (BEVEL_DUMMY+15)
	/* (WORD) (OM_NEW/OM_SET) - disable inner bevel fill/erase modes */

NATIVE {BEVEL_SoftStyle}		CONST BEVEL_SOFTSTYLE		= (BEVEL_DUMMY+16)
	/* (WORD) (OM_NEW/OM_SET) - Text SoftStyle */

NATIVE {BEVEL_ColorMap}		CONST BEVEL_COLORMAP		= (BEVEL_DUMMY+17)
NATIVE {BEVEL_ColourMap}	CONST BEVEL_COLOURMAP	= BEVEL_COLORMAP
	/* (struct ColorMap *) (OM_NEW/OM_SET) - Screen ViewPort ColorMap
	 * This required tag is for proper BVS_BUTTON xen shadow pen selection */

NATIVE {BEVEL_Flags}			CONST BEVEL_FLAGS			= (BEVEL_DUMMY+18)
	/* (UWORD) (OM_NEW/OM_SET) Intentionally left undocumented! */

/*****************************************************************************/

/* Bevel Box Styles for BEVEL_Style
 */
NATIVE {BVS_THIN}		CONST BVS_THIN		= 0	/* Thin (usually 1 pixel) bevel. */
NATIVE {BVS_BUTTON}		CONST BVS_BUTTON		= 1	/* Standard button bevel. */
NATIVE {BVS_GROUP}		CONST BVS_GROUP		= 2	/* Group box bevel. */
NATIVE {BVS_FIELD}		CONST BVS_FIELD		= 3	/* String/integer/text field bevel. */
NATIVE {BVS_NONE}		CONST BVS_NONE		= 4	/* No not render any bevel. */
NATIVE {BVS_DROPBOX}		CONST BVS_DROPBOX		= 5	/* Drop box area. */
/*
 * You may think it is very stupid to name the vertical bar BVS_SBAR_HORIZ
 * and the horizontal bar BVS_SBAR_VERT. The reason for this is:
 * The vertical bar is mostly used as a seperator in horizontal groups and the
 * horizontal bar is used as a seperator in vertical groups.
 *
 * Another explanation: It was simply a mistake when defining the names the
 * first time.
 */
NATIVE {BVS_SBAR_HORIZ}	CONST BVS_SBAR_HORIZ	= 6	/* Vertical bar. */
NATIVE {BVS_SBAR_VERT}	CONST BVS_SBAR_VERT	= 7	/* Horizontal bar. */
NATIVE {BVS_BOX}			CONST BVS_BOX			= 8	/* Typically, thin black border. */
NATIVE {BVS_STANDARD}	CONST BVS_STANDARD	= 11	/* Same as BVS_BUTTON but will not support XEN */

NATIVE {BVS_SBAR_HORZ}	CONST BVS_SBAR_HORZ	= BVS_SBAR_HORIZ	/* OBSOLETE SPELLING */

/* The following bevel types are not implemented yet
 */
NATIVE {BVS_FOCUS}		CONST BVS_FOCUS		= 9	/* Typically, the border for drag&drop target. */
NATIVE {BVS_RADIOBUTTON} CONST BVS_RADIOBUTTON = 10  /* (not implemented) radiobutton bevel. */

/* BEVEL_Flags - CURRENTLY PRIVATE!!
 */
NATIVE {BFLG_XENFILL}	CONST BFLG_XENFILL	= $01
NATIVE {BFLG_TRANS}		CONST BFLG_TRANS		= $02

/* Bevel Box Locations for BEVEL_LabelPlace.  Typically used to label a group
 * box, or to be utilized via a button or status gadgets.
 */
NATIVE {BVJ_TOP_CENTER}	CONST BVJ_TOP_CENTER	= 0
NATIVE {BVJ_TOP_LEFT}	CONST BVJ_TOP_LEFT	= 1
NATIVE {BVJ_TOP_RIGHT}	CONST BVJ_TOP_RIGHT	= 2
NATIVE {BVJ_IN_CENTER}	CONST BVJ_IN_CENTER	= 3
NATIVE {BVJ_IN_LEFT}		CONST BVJ_IN_LEFT		= 4
NATIVE {BVJ_IN_RIGHT}	CONST BVJ_IN_RIGHT	= 5
NATIVE {BVJ_BOT_CENTER}	CONST BVJ_BOT_CENTER	= 6
NATIVE {BVJ_BOT_LEFT}	CONST BVJ_BOT_LEFT	= 7
NATIVE {BVJ_BOT_RIGHT}	CONST BVJ_BOT_RIGHT	= 8
