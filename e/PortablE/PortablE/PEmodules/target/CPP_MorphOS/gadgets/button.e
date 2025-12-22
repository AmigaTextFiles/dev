/* $VER: button.h 44.1 (19.10.1999) */
OPT NATIVE
MODULE 'target/reaction/reaction', 'target/intuition/gadgetclass', 'target/images/bevel'
MODULE 'target/utility/tagitem'
{#include <gadgets/button.h>}
NATIVE {GADGETS_BUTTON_H} CONST

CONST BUTTON_ARRAY=$84000003
CONST BUTTON_CURRENT=$84000009

/*****************************************************************************/

/* Additional attributes defined by the button.gadget class
 * Our class supports most functions of C= button developer release,
 * however we support many additional options as noted below.
 */

NATIVE {BUTTON_Dummy}			CONST BUTTON_DUMMY			= (TAG_USER+$04000000)

NATIVE {BUTTON_PushButton}		CONST BUTTON_PUSHBUTTON		= (BUTTON_DUMMY+1)
	/* (BOOL) Indicate whether button stays depressed when clicked */

NATIVE {BUTTON_Glyph}			CONST BUTTON_GLYPH			= (BUTTON_DUMMY+2)
	/* (struct Image *) Indicate that image is to be drawn using
	 * BltTemplate. Note this tag is only partial support, only single
	 * plane glyphs are rendered correctly.
	 */

NATIVE {BUTTON_TextPen}			CONST BUTTON_TEXTPEN			= (BUTTON_DUMMY+5)
	/* (LONG) Pen to use for text (-1 uses TEXTPEN) */

NATIVE {BUTTON_FillPen}			CONST BUTTON_FILLPEN			= (BUTTON_DUMMY+6)
	/* (LONG) Pen to use for fill (-1 uses FILLPEN) */

NATIVE {BUTTON_FillTextPen}		CONST BUTTON_FILLTEXTPEN		= (BUTTON_DUMMY+7)
	/* (LONG) Pen to use for fill (-1 uses FILLTEXTPEN) */

NATIVE {BUTTON_BackgroundPen}	CONST BUTTON_BACKGROUNDPEN	= (BUTTON_DUMMY+8)
	/* (LONG) Pen to use for fill (-1 uses BACKGROUNDPEN) */

NATIVE {BUTTON_RenderImage}		CONST BUTTON_RENDERIMAGE		= GA_IMAGE
NATIVE {BUTTON_SelectImage}		CONST BUTTON_SELECTIMAGE		= GA_SELECTRENDER

NATIVE {BUTTON_BevelStyle}		CONST BUTTON_BEVELSTYLE		= (BUTTON_DUMMY+13)
	/* Bevel Box Style */

NATIVE {BUTTON_Transparent}		CONST BUTTON_TRANSPARENT		= (BUTTON_DUMMY+15)
	/* Button is transparent, EraseRect fill pattern used (if any)
	 * to render button background.
	 */

NATIVE {BUTTON_Justification}	CONST BUTTON_JUSTIFICATION	= (BUTTON_DUMMY+16)
	/* LEFT/RIGHT/CENTER jutification of GA_Text text */

NATIVE {BUTTON_SoftStyle}		CONST BUTTON_SOFTSTYLE		= (BUTTON_DUMMY+17)
	/* Sets Font SoftStyle, ie, Bold, Italics, etc */

NATIVE {BUTTON_AutoButton}		CONST BUTTON_AUTOBUTTON		= (BUTTON_DUMMY+18)
	/* Automatically creates a button with standard scaled glyphs */

NATIVE {BUTTON_VarArgs}			CONST BUTTON_VARARGS			= (BUTTON_DUMMY+19)
	/* Argument array for GA_Text varargs string */

NATIVE {BUTTON_DomainString}		CONST BUTTON_DOMAINSTRING		= (BUTTON_DUMMY+20)
	/* (STRPTR) default string used for domain calculation */

NATIVE {BUTTON_Integer}			CONST BUTTON_INTEGER			= (BUTTON_DUMMY+21)
	/* (int) integer value to display a numeric string.
	 * Useful with notifications from sliders, scrollers, etc
	 */

NATIVE {BUTTON_BitMap}			CONST BUTTON_BITMAP			= (BUTTON_DUMMY+22)
	/* (struct BitMap *) BitMap to render in button, rather than an image... */

NATIVE {BUTTON_AnimButton}		CONST BUTTON_ANIMBUTTON		= (BUTTON_DUMMY+50)
	/* (BOOl) Is button animatable?  Use to turn animating on or off */

NATIVE {BUTTON_AnimImages}		CONST BUTTON_ANIMIMAGES		= (BUTTON_DUMMY+51)
	/* (struct Image *) Sets an array of struct Images for animation */

NATIVE {BUTTON_SelAnimImages}	CONST BUTTON_SELANIMIMAGES	= (BUTTON_DUMMY+52)
	/* (struct Image *) sets an array of alternate images for a selected
	 * state if used, must contain an equal number of images as the
	 * array used for BUTTON_AnimImages.  It's wise to use the
	 * same sized images too
	 */

NATIVE {BUTTON_MaxAnimImages}	CONST BUTTON_MAXANIMIMAGES	= (BUTTON_DUMMY+53)
	/* (LONG) Number of images available in the arrays */

NATIVE {BUTTON_AnimImageNumber} 	CONST BUTTON_ANIMIMAGENUMBER 	= (BUTTON_DUMMY+54)
	/* (LONG) Current image number in the array(s) to use
	 * the range of available frames is 0..MaxAnimImages-1
	 */

NATIVE {BUTTON_AddAnimImageNumber} CONST BUTTON_ADDANIMIMAGENUMBER = (BUTTON_DUMMY+55)
	/* (ULONG) Value to be added to the current image number counter
	 * the counter will wrap around at MaxAnimImages
	 */

NATIVE {BUTTON_SubAnimImageNumber} CONST BUTTON_SUBANIMIMAGENUMBER = (BUTTON_DUMMY+56)
	/* (ULONG) Value to be subtracted from the current image number counter
	 * the counter will wrap around when less than 0
	 */

/****************************************************************************/

/* Justification modes for BUTTON_Justification.
 */
NATIVE {BCJ_LEFT}	CONST BCJ_LEFT	= 0
NATIVE {BCJ_CENTER}	CONST BCJ_CENTER	= 1		/* default - center text */
NATIVE {BCJ_RIGHT}	CONST BCJ_RIGHT	= 2

NATIVE {BCJ_CENTRE} CONST BCJ_CENTRE = BCJ_CENTER

/* Built-in button glyphs for BUTTON_AutoButton.
 */

NATIVE {BAG_POPFILE}		CONST BAG_POPFILE		= 1	/* popup file req */
NATIVE {BAG_POPDRAWER}	CONST BAG_POPDRAWER	= 2	/* popup drawer req */
NATIVE {BAG_POPFONT}		CONST BAG_POPFONT		= 3	/* popup font req */
NATIVE {BAG_CHECKBOX}	CONST BAG_CHECKBOX	= 4	/* check glyph button */
NATIVE {BAG_CANCELBOX}	CONST BAG_CANCELBOX	= 5	/* cancel glyph button */
NATIVE {BAG_UPARROW}		CONST BAG_UPARROW		= 6	/* up arrow */
NATIVE {BAG_DNARROW}		CONST BAG_DNARROW		= 7	/* down arrow */
NATIVE {BAG_RTARROW}		CONST BAG_RTARROW		= 8	/* right arrow */
NATIVE {BAG_LFARROW}		CONST BAG_LFARROW		= 9	/* left arrow */
NATIVE {BAG_POPTIME}		CONST BAG_POPTIME		= 10	/* popup time glyph */
NATIVE {BAG_POPSCREEN}	CONST BAG_POPSCREEN	= 11	/* popup screen mode glyph */
NATIVE {BAG_POPUP}		CONST BAG_POPUP		= 12	/* generic popup */
