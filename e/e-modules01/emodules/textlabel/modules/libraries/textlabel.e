OPT MODULE
OPT OSVERSION=37
OPT EXPORT
OPT PREPROCESS

/**
  $VER: textlabel 2.2 (18.7.95)
  (c) Copyright 1994, 1995 Hartmut Goebel.
**/

MODULE 'exec/libraries','utility/tagitem','intuition/classes'

#define TEXTLABELIMAGE     'images/textlabel.image'
#define TEXTLABELNAME      'images/textlabel.image'
CONST   TEXTLABELVERSION   = 2

CONST TLA_DUMMY        = $80000000 + 50,
      TLA_UNDERSCORE   = $80000032 + 1
         /* [IS...] (CHAR) - Character for determining the shortcut. */

CONST TLA_GADGET       = $80000032 + 2
        /* NEW for V2:
         * [IS...] (PTR TO gadget) - be a label for this gadget.
         * this is a mighty function, see class documentation for
         * further information.
         * you should at most specify one of TLA_GADGET and TLA_IMAGE */

CONST TLA_ADJUSTMENT   = $80000032 + 3
        /* [IS...] adjustment within the frame of
         * IM_DRAWFRAME. defaults to TLADJUST_CENTER. */

CONST TLA_KEY          = $80000032 + 4
        /* [..G..] (CHAR) - Shortcut key of this label. */

CONST TLA_IMAGE        = $80000032 + 5
        /* NEW for V2:
         * [IS...] (PTR TO image) - be a label for this gadget.
         * This is a mighty function, see class documentation for
         * further information.
         * You should at most specify one of TLA_GADGET and TLA_IMAGE */

CONST TLA_TEXT         = $80020007   -> IA_DATA
        /* [IS...] (PTR TO CHAR) - pointer to a null terminated
         * array of character. */

CONST TLA_FONT         = $80020013   -> IA_FONT
        /* [IS...] (PTR TO textfont) - font to be used for
         * rendering the label strings.  defaults to use
         * drawinfo.font. */

CONST TLA_DRAWINFO     = $80020018   -> SYSIA_DRAWINFO
        /* [IS...] (PTR TO drawinfo) - REQUIRED IF aFont is
         * ommitted. */

CONST TLA_MODE         = $80020012   -> IA_MODE
        /* [IS...] Drawing mode to use. */

CONST TLA_LEFT         = $80020001,  -> IA_LEFT
      TLA_TOP          = $80020002   -> IA_TOP
       /* [ISG..] left/top edge of image
        * Specifying TLA_GADGET or TLA_IMAGE overwrites this
        * attributes. */

CONST TLA_WIDTH        = $80020003,  -> IA_WIDTH
      TLA_HEIGHT       = $80020004   -> IA_HEIGHT
       /* [..G..] dimensions of  the image
        * filled in by the object */

CONST TLA_FGPEN        = $80020005,  -> IA_FGPEN
      TLA_BGPEN        = $80020006   -> IA_BGPEN
       /* [IS...] Pen numbers to be used as foreground and
        * background pens. Defaults to BLOCKPEN and BACKGROUNDPEN. */


-> VALUES FOR AADJUSTMENT
CONST TLADJUST_CENTER      = 0,
      TLADJUST_HCENTER     = 0,
      TLADJUST_HLEFT       = 1, -> (1<<0)
      TLADJUST_HRIGHT      = 2, -> (1<<1)
      TLADJUST_VCENTER     = 0,
      TLADJUST_VTOP        = 4, -> (1<<2);
      TLADJUST_VBOTTOM     = 8  -> (1<<3);


/* textlabel.image is an external class library.  OpenLibrary() returns
 * a PTR TO classlibrary, from which you can obtain the class
 * handle to create objects (textlabel.image is not a public class).
 */

OBJECT classlibrary
  lib: lib               /* Embedded library */
  pad: INT               /* Align the structure */
  class: PTR TO iclass   /* Class pointer */
ENDOBJECT
