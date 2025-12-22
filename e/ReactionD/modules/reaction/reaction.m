MODULE  'utility/tagitem'

#define MAKE_ID(a,b,c,d) ((a<<24) | (b<<16) | (c<<8) | (d))
#define REACTION_Dummy  (TAG_USER + $5000000)
/* The Reaction tags below are used internally to layout and other
 * classes to make some magic happen. They are not intended for your
 * general usage.
 */
#define REACTION_TextAttr  (REACTION_Dummy + 5)
/* (struct TextAttr *) Class private tag set internally by layout
  * only. This tag sets a gadgets font, but does NOT override GA_TextAttr!
  */
#define REACTION_ChangePrefs  (REACTION_Dummy + 6)
/* (struct UIPrefs *) Signals classes of dynamic prefs change.
  */
#define REACTION_SpecialPens  (REACTION_Dummy + 7)
/* (strut SpecialPens *) Pens used for Xen-style shadowing, etc.
  */
MODULE 'gadgets/layout','gadgets/button','gadgets/checkbox','gadgets/chooser','gadgets/clicktab','gadgets/fuelgauge'
MODULE 'gadgets/getfile','gadgets/getfont','gadgets/getscreenmode','gadgets/integer','gadgets/listbrowser','gadgets/palette'
MODULE 'gadgets/radiobutton','gadgets/scroller','gadgets/slider','gadgets/space','gadgets/speedbar','gadgets/string'
MODULE 'images/bevel','images/bitmap','images/drawlist','images/glyph','images/label','images/penmap','classes/window'
MODULE 'classes/requester','classes/arexx','reaction/reaction_macros'
