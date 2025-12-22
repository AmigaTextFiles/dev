/* $VER: reaction.h 44.1 (19.10.1999) */
OPT NATIVE
MODULE 'target/utility/tagitem'
{#include <reaction/reaction.h>}
NATIVE {REACTION_REACTION_H} CONST

->NATIVE {MAKE_ID} CONST	->MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
PROC make_id(a,b,c,d) IS (a SHL 24) OR (b SHL 16) OR (c SHL 8) OR d

/*****************************************************************************/

NATIVE {REACTION_Dummy} CONST REACTION_DUMMY = (TAG_USER + $5000000)

/* The Reaction tags below are used internally to layout and other
 * classes to make some magic happen. They are not intended for your
 * general usage.
 */

NATIVE {REACTION_TextAttr} CONST REACTION_TEXTATTR = (REACTION_DUMMY + 5)
 /* (struct TextAttr *) Class private tag set internally by layout
  * only. This tag sets a gadgets font, but does NOT override GA_TextAttr!
  */

NATIVE {REACTION_ChangePrefs} CONST REACTION_CHANGEPREFS = (REACTION_DUMMY + 6)
 /* (struct UIPrefs *) Signals classes of dynamic prefs change.
  */

NATIVE {REACTION_SpecialPens} CONST REACTION_SPECIALPENS = (REACTION_DUMMY + 7)
 /* (strut SpecialPens *) Pens used for Xen-style shadowing, etc.
  */
