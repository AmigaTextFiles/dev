/* $VER: reaction.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/utility/tagitem', 'target/libraries/iffparse'
->/* ALL_REACTION_CLASSES */
->PUBLIC MODULE 'target/proto/layout', 'target/gadgets/layout', 'target/proto/button', 'target/gadgets/button', 'target/proto/checkbox', 'target/gadgets/checkbox', 'target/proto/chooser', 'target/gadgets/chooser', 'target/proto/clicktab', 'target/gadgets/clicktab', 'target/proto/fuelgauge', 'target/gadgets/fuelgauge', 'target/proto/getfile', 'target/gadgets/getfile', 'target/proto/getfont', 'target/gadgets/getfont', 'target/proto/getscreenmode', 'target/gadgets/getscreenmode', 'target/proto/integer', 'target/gadgets/integer', 'target/proto/listbrowser', 'target/gadgets/listbrowser', 'target/proto/palette', 'target/gadgets/palette', 'target/proto/radiobutton', 'target/gadgets/radiobutton', 'target/proto/scroller', 'target/gadgets/scroller', 'target/proto/slider', 'target/gadgets/slider', 'target/proto/space', 'target/gadgets/space', 'target/proto/speedbar', 'target/gadgets/speedbar', 'target/proto/string', 'target/gadgets/string', 'target/proto/bevel', 'target/images/bevel', 'target/proto/bitmap', 'target/images/bitmap', 'target/proto/drawlist', 'target/images/drawlist', 'target/proto/glyph', 'target/images/glyph', 'target/proto/label', 'target/images/label', 'target/proto/penmap', 'target/images/penmap', 'target/proto/window', 'target/classes/window', 'target/classes/requester', 'target/proto/requester', 'target/proto/arexx', 'target/classes/arexx'
->/* ALL_REACTION_MACROS */
->PUBLIC MODULE 'target/reaction/reaction_macros'
{#include <reaction/reaction.h>}
NATIVE {REACTION_REACTION_H} CONST

NATIVE {REACTION_Dummy} CONST REACTION_DUMMY = (TAG_USER + $5000000)

/* The Reaction tags below are used internally to layout and other
 * classes to make some magic happen. They are not intended for your
 * general usage.
 */

NATIVE {REACTION_BackFill}    CONST REACTION_BACKFILL    = (REACTION_DUMMY + 1)
 /* (struct Hook *) Class private tag set internally by layout only.
  * This tag sets a gadget's backfill, but does NOT override GA_BackFill!
  */

NATIVE {REACTION_TextAttr}    CONST REACTION_TEXTATTR    = (REACTION_DUMMY + 5)
 /* (struct TextAttr *) Class private tag set internally by layout
  * only. This tag sets a gadget's font, but does NOT override GA_TextAttr!
  */

NATIVE {REACTION_ChangePrefs} CONST REACTION_CHANGEPREFS = (REACTION_DUMMY + 6)
 /* (struct UIPrefs *) Signals classes of dynamic prefs change.
  */

NATIVE {REACTION_SpecialPens} CONST REACTION_SPECIALPENS = (REACTION_DUMMY + 7)
 /* (strut SpecialPens *) Pens used for Xen-style shadowing, etc.
  */
