#ifndef IMAGES_TEXTLABEL_H
#define IMAGES_TEXTLABEL_H
/*
**  $VER: textlabel.h 2.2 (18.7.95)
**
**  Interface definitions for BOOPSI textlabel image objects.
**
**  (c) Copyright 1994, 1995 Hartmut Goebel.
**      All Rights Reserved.
*/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif

#ifndef INTUITION_CLASSES_H
#include <intuition/classes.h>
#endif

/***************************************************************************/

#define TEXTLABELIMAGE       "textlabel.image"

/***************************************************************************/

#define TLA_Dummy                (TAG_User + 50)

#define TLA_Underscore           (TLA_Dummy + 1)
        /* [IS...] (CHAR) - Character for determining the shortcut. */

#define TLA_Gadget               (TLA_Dummy + 2)
        /* NEW for V2:
         * [IS...] (struct Gadget *) - be a label for this gadget.
         * This is a mighty function, see class documentation for
         * further information.
         * You should at most specify one of TLA_Gadget and TLA_Image */

#define TLA_Adjustment           (TLA_Dummy + 3)
        /* [IS...] (BYTEBITS) - Adjustment within the frame of
         * IM_DRAWFRAME. Defaults to adjustCenter. */

#define TLA_Key                  (TLA_Dummy + 4)
        /* [..G..] (CHAR) - Shortcut key of this label. */

#define TLA_Image                (TLA_Dummy + 5)
        /* NEW for V2:
         * [IS...] (struct Image *) - be a label for this gadget.
         * This is a mighty function, see class documentation for
         * further information.
         * You should at most specify one of TLA_Gadget and TLA_Image */

#define TLA_Text                 (IA_Data)
        /* [IS...] (STRPTR) - pointer to a null terminated
         * array of character. */

#define TLA_Font                 (IA_Font)
        /* [IS...] (struct TextFont *) - Font to be used for
         * rendering the label strings.  Defaults to use
         * DrawInfo.font. */

#define TLA_DrawInfo             (SYSIA_DrawInfo)
        /* [IS...] (struct DrawInfoPtr *) - required if aFont is
         * ommitted. */

#define TLA_Mode                 (IA_Mode)
        /* [IS...] (SHORTSET) - Drawing mode to use. */

#define TLA_Left                 (IA_Left)
#define TLA_Top                  (IA_Top)
       /* [ISG..] (SHORT) - left/top edge of image
        * Specifying TLA_GADGET or TLA_IMAGE overwrites this
        * attributes. */

#define TLA_Width                (IA_Width)
#define TLA_Height               (IA_Height)
       /* [..G..] (SHORT) - dimensions of  the image
        * filled in by the object */

#define TLA_FGPen                (IA_FGPen)
#define TLA_BGPen                (IA_BGPen)
       /* [IS...] (UBYTE) - Pen numbers to be used as foreground and
        * background pens. Defaults to BLOCKPEN and BACKGROUNDPEN. */

/***************************************************************************/

/* values for aAdjustment */
#define TLADJUST_Center         0

#define TLADJUST_HCenter        0
#define TLADJUST_HLeft          (1<<0)
#define TLADJUST_HRight         (1<<1)

#define TLADJUST_VCenter        0L
#define TLADJUST_VTop           (1<<2);
#define TLADJUST_VBottom        (1<<3);

/***************************************************************************/

#if INCLUDE_VERSION < 42
/* textlabel.image is an external class library.  OpenLibrary() returns
 * a pointer to a struct ClassLibrary, from which you can obtain the class
 * handle to create objects (textlabel.image is not a public class).
 */

struct ClassLibrary
{
    struct Library       cl_Lib;        /* Embedded library */
    UWORD                cl_pad;        /* Align the structure */
    Class               *cl_Class;      /* Class pointer */
};
#endif /* INCLUDE_VERSION */

/***************************************************************************/
#endif /* IMAGES_TEXTLABEL_H */
