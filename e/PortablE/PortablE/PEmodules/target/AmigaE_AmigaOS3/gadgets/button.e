/* $VER: button.h 44.1 (19.10.1999) */
OPT NATIVE
MODULE 'target/intuition/gadgetclass'
MODULE 'target/utility/tagitem'
{MODULE 'gadgets/button'}

NATIVE {BUTTON_ARRAY} CONST BUTTON_ARRAY=$84000003
NATIVE {BUTTON_CURRENT} CONST BUTTON_CURRENT=$84000009

/*****************************************************************************/

/* Additional attributes defined by the button.gadget class
 * Our class supports most functions of C= button developer release,
 * however we support many additional options as noted below.
 */

NATIVE {BUTTON_DUMMY}			CONST BUTTON_DUMMY			= (TAG_USER+$04000000)

NATIVE {BUTTON_PUSHBUTTON}		CONST BUTTON_PUSHBUTTON		= (BUTTON_DUMMY+1)
	/* (BOOL) Indicate whether button stays depressed when clicked */

NATIVE {BUTTON_GLYPH}			CONST BUTTON_GLYPH			= (BUTTON_DUMMY+2)
	/* (struct Image *) Indicate that image is to be drawn using
	 * BltTemplate. Note this tag is only partial support, only single
	 * plane glyphs are rendered correctly.
	 */

NATIVE {BUTTON_TEXTPEN}			CONST BUTTON_TEXTPEN			= (BUTTON_DUMMY+5)
	/* (LONG) Pen to use for text (-1 uses TEXTPEN) */

NATIVE {BUTTON_FILLPEN}			CONST BUTTON_FILLPEN			= (BUTTON_DUMMY+6)
	/* (LONG) Pen to use for fill (-1 uses FILLPEN) */

NATIVE {BUTTON_FILLTEXTPEN}		CONST BUTTON_FILLTEXTPEN		= (BUTTON_DUMMY+7)
	/* (LONG) Pen to use for fill (-1 uses FILLTEXTPEN) */

NATIVE {BUTTON_BACKGROUNDPEN}	CONST BUTTON_BACKGROUNDPEN	= (BUTTON_DUMMY+8)
	/* (LONG) Pen to use for fill (-1 uses BACKGROUNDPEN) */

CONST BUTTON_RENDERIMAGE		= GA_IMAGE
CONST BUTTON_SELECTIMAGE		= GA_SELECTRENDER

CONST BUTTON_BEVELSTYLE		= (BUTTON_DUMMY+13)
	/* Bevel Box Style */

CONST BUTTON_TRANSPARENT		= (BUTTON_DUMMY+15)
	/* Button is transparent, EraseRect fill pattern used (if any)
	 * to render button background.
	 */

CONST BUTTON_JUSTIFICATION	= (BUTTON_DUMMY+16)
	/* LEFT/RIGHT/CENTER jutification of GA_Text text */

CONST BUTTON_SOFTSTYLE		= (BUTTON_DUMMY+17)
	/* Sets Font SoftStyle, ie, Bold, Italics, etc */

CONST BUTTON_AUTOBUTTON		= (BUTTON_DUMMY+18)
	/* Automatically creates a button with standard scaled glyphs */

CONST BUTTON_VARARGS			= (BUTTON_DUMMY+19)
	/* Argument array for GA_Text varargs string */

CONST BUTTON_DOMAINSTRING		= (BUTTON_DUMMY+20)
	/* (STRPTR) default string used for domain calculation */

CONST BUTTON_INTEGER			= (BUTTON_DUMMY+21)
	/* (int) integer value to display a numeric string.
	 * Useful with notifications from sliders, scrollers, etc
	 */

CONST BUTTON_BITMAP			= (BUTTON_DUMMY+22)
	/* (struct BitMap *) BitMap to render in button, rather than an image... */

CONST BUTTON_ANIMBUTTON		= (BUTTON_DUMMY+50)
	/* (BOOl) Is button animatable?  Use to turn animating on or off */

CONST BUTTON_ANIMIMAGES		= (BUTTON_DUMMY+51)
	/* (struct Image *) Sets an array of struct Images for animation */

CONST BUTTON_SELANIMIMAGES	= (BUTTON_DUMMY+52)
	/* (struct Image *) sets an array of alternate images for a selected
	 * state if used, must contain an equal number of images as the
	 * array used for BUTTON_AnimImages.  It's wise to use the
	 * same sized images too
	 */

CONST BUTTON_MAXANIMIMAGES	= (BUTTON_DUMMY+53)
	/* (LONG) Number of images available in the arrays */

CONST BUTTON_ANIMIMAGENUMBER 	= (BUTTON_DUMMY+54)
	/* (LONG) Current image number in the array(s) to use
	 * the range of available frames is 0..MaxAnimImages-1
	 */

CONST BUTTON_ADDANIMIMAGENUMBER = (BUTTON_DUMMY+55)
	/* (ULONG) Value to be added to the current image number counter
	 * the counter will wrap around at MaxAnimImages
	 */

CONST BUTTON_SUBANIMIMAGENUMBER = (BUTTON_DUMMY+56)
	/* (ULONG) Value to be subtracted from the current image number counter
	 * the counter will wrap around when less than 0
	 */

/****************************************************************************/

/* Justification modes for BUTTON_Justification.
 */
CONST BCJ_LEFT	= 0
CONST BCJ_CENTER	= 1		/* default - center text */
CONST BCJ_RIGHT	= 2

CONST BCJ_CENTRE = BCJ_CENTER

/* Built-in button glyphs for BUTTON_AutoButton.
 */

CONST BAG_POPFILE		= 1	/* popup file req */
CONST BAG_POPDRAWER	= 2	/* popup drawer req */
CONST BAG_POPFONT		= 3	/* popup font req */
CONST BAG_CHECKBOX	= 4	/* check glyph button */
CONST BAG_CANCELBOX	= 5	/* cancel glyph button */
CONST BAG_UPARROW		= 6	/* up arrow */
CONST BAG_DNARROW		= 7	/* down arrow */
CONST BAG_RTARROW		= 8	/* right arrow */
CONST BAG_LFARROW		= 9	/* left arrow */
CONST BAG_POPTIME		= 10	/* popup time glyph */
CONST BAG_POPSCREEN	= 11	/* popup screen mode glyph */
CONST BAG_POPUP		= 12	/* generic popup */
