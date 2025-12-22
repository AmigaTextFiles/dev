#ifndef LIBRARIES_MPGUI_H
#define LIBRARIES_MPGUI_H

/* MPGui - requester library */

/* mark@topic.demon.co.uk */
/* mpaddock@cix.compulink.co.uk */

/* $VER: MPGui.h 5.3 (16.2.97)
 */

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#define MPG_PUBSCREENNAME	(TAG_USER+1)	/* Specify name in data */
#define MPG_RELMOUSE			(TAG_USER+2)	/* Specify TRUE/FALSE in data - default FALSE */
#define MPG_HELP				(TAG_USER+3)	/* Data is struct Hook *, called with object=char * to help node */
#define MPG_CHELP				(TAG_USER+4)	/*	Call help when gadget changes */
#define MPG_PARAMS			(TAG_USER+5)	/* Data is char ** array of parameters */
#define MPG_NEWLINE			(TAG_USER+6)	/* Specify TRUE/FALSE - TRUE means new line rather than space */
														/* in output, no "s round files or screen modes */
														/* Default FALSE. */
#define MPG_PREFS				(TAG_USER+7)	/* default FALSE - TRUE provides _Save/_Use/_Cancel gadgets */
														/* Use MPGuiResponse to get response (1=Save 2=Use) */
														/* Esc key will not exit */
#define MPG_MENUS				(TAG_USER+8)	/* Data is struct NewMenu * */
#define MPG_MENUHOOK			(TAG_USER+9)	/* Data is struct Hook *, called with object=struct IntuiMsg * */
														/* message = struct Menu * */
														/* If Help is set then called for MENUHELP as well */
														/* return 0 to quit */
#define MPG_SIGNALS			(TAG_USER+10)	/* Data is ULONG signals to wait for then call hook */
														/* provided in MPG_SIGNALHOOK. */
#define MPG_SIGNALHOOK		(TAG_USER+11)	/* Data is struct Hook *, called with */
														/* object = ULONG signals received, */
														/* message = ULONG notused */
														/* Return 0 to quit, non 0 to continue. */
#define MPG_CHECKMARK		(TAG_USER+12)	/* Data is struct Image * for menu checkmark */
#define MPG_AMIGAKEY			(TAG_USER+13)	/* Data is struct Image * for menu AmigaKey */
#define MPG_BUTTONHOOK		(TAG_USER+14)	/* Data is struct Hook *, called with object=struct MPGuiHandle * */
														/* message = number of button */
#define MPG_NOBUTTONS		(TAG_USER+15)	/* defaults FALSE - if TRUE then no buttons are shown, */
														/* overrides MPG_PREFS */

#define MPG_SAVE	(1)		/* Save gadget on prefs for MPGuiResponse */
#define MPG_USE	(2)		/* Use gadget */

#ifndef MPGUIHANDLE
struct MPGuiHandle {
/*	Loads of hidden stuff in here */
	char unknown[1];
};
#endif

#endif
