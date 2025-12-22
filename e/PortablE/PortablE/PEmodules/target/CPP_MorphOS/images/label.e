/* $VER: label.h 44.1 (19.10.1999) */
OPT NATIVE
MODULE 'target/reaction/reaction', 'target/intuition/imageclass'
{#include <images/label.h>}
NATIVE {IMAGES_LABEL_H} CONST

/* Justification modes.
 */
NATIVE {LJ_LEFT} CONST LJ_LEFT = 0
NATIVE {LJ_CENTRE} CONST LJ_CENTRE = 1
NATIVE {LJ_RIGHT} CONST LJ_RIGHT = 2

/* For those that can't spell :)
 */
NATIVE {LJ_CENTER} CONST LJ_CENTER = LJ_CENTRE

/* Obsolete, DON'T USE THESE!
 */
NATIVE {LABEL_LEFT} CONST LABEL_LEFT = LJ_LEFT
NATIVE {LABEL_CENTRE} CONST LABEL_CENTRE = LJ_CENTRE
NATIVE {LABEL_CENTER} CONST LABEL_CENTER = LJ_CENTRE
NATIVE {LABEL_RIGHT} CONST LABEL_RIGHT = LJ_RIGHT

/*****************************************************************************/

/* Additional attributes defined by the Label class
 */
NATIVE {LABEL_Dummy}					CONST LABEL_DUMMY					= (REACTION_DUMMY+$0006000)

NATIVE {LABEL_DrawInfo}				CONST LABEL_DRAWINFO				= SYSIA_DRAWINFO

NATIVE {LABEL_Text}					CONST LABEL_TEXT					= (LABEL_DUMMY+1)
	/* (STRPTR) Text to print in the label. */

NATIVE {LABEL_Image}					CONST LABEL_IMAGE					= (LABEL_DUMMY+2)
	/* (struct Image *) Image to print in the label. */

NATIVE {LABEL_Mapping}				CONST LABEL_MAPPING				= (LABEL_DUMMY+3)
	/* (UWORD *) Mapping array for the next image. */

NATIVE {LABEL_Justification}			CONST LABEL_JUSTIFICATION			= (LABEL_DUMMY+4)
	/* (UWORD) Justification modes (see above) */

NATIVE {LABEL_Key}					CONST LABEL_KEY					= (LABEL_DUMMY+5)
	/* (UWORD) Returns the underscored key (if any) */

NATIVE {LABEL_Underscore}			CONST LABEL_UNDERSCORE			= (LABEL_DUMMY+6)
	/* (UBYTE) Defaults to '_'. */

NATIVE {LABEL_DisposeImage}			CONST LABEL_DISPOSEIMAGE			= (LABEL_DUMMY+7)
	/* (BOOL) Defaults to FALSE. */

NATIVE {LABEL_SoftStyle}				CONST LABEL_SOFTSTYLE				= (LABEL_DUMMY+8)
	/* (UBYTE) Defaults to none. */

NATIVE {LABEL_VerticalSpacing}		CONST LABEL_VERTICALSPACING		= (LABEL_DUMMY+9)
	/* (UWORD) Vertical spacing between text/image nodes/lines. Defaults to 0. */
