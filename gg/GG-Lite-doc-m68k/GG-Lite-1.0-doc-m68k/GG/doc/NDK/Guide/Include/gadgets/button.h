@DATABASE "gg:doc/NDK/Guide/Include/gadgets/button.h"
@MASTER   "gg:os-include/gadgets/button.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:21
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "gadgets/button.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"gadgets/button.h" LINK File}


@{b}#defines@{ub}

@{"BAG_CANCELBOX" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 139}           @{"BAG_CHECKBOX" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 138}               @{"BAG_DNARROW" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 141}
@{"BAG_LFARROW" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 143}             @{"BAG_POPDRAWER" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 136}              @{"BAG_POPFILE" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 135}
@{"BAG_POPFONT" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 137}             @{"BAG_POPSCREEN" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 145}              @{"BAG_POPTIME" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 144}
@{"BAG_POPUP" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 146}               @{"BAG_RTARROW" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 142}                @{"BAG_UPARROW" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 140}
@{"BCJ_CENTER" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 127}              @{"BCJ_CENTRE" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 130}                 @{"BCJ_LEFT" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 126}
@{"BCJ_RIGHT" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 128}               @{"BUTTON_AddAnimImageNumber" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 112}  @{"BUTTON_AnimButton" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 91}
@{"BUTTON_AnimImageNumber" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 107}  @{"BUTTON_AnimImages" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 94}          @{"BUTTON_AutoButton" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 74}
@{"BUTTON_BackgroundPen" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 54}    @{"BUTTON_BevelStyle" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 60}          @{"BUTTON_BitMap" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 88}
@{"BUTTON_DomainString" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 80}     @{"BUTTON_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 34}               @{"BUTTON_FillPen" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 48}
@{"BUTTON_FillTextPen" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 51}      @{"BUTTON_Glyph" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 39}               @{"BUTTON_Integer" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 83}
@{"BUTTON_Justification" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 68}    @{"BUTTON_MaxAnimImages" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 104}       @{"BUTTON_PushButton" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 36}
@{"BUTTON_RenderImage" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 57}      @{"BUTTON_SelAnimImages" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 97}       @{"BUTTON_SelectImage" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 58}
@{"BUTTON_SoftStyle" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 71}        @{"BUTTON_SubAnimImageNumber" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 117}  @{"BUTTON_TextPen" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 45}
@{"BUTTON_Transparent" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 63}      @{"BUTTON_VarArgs" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File" 77}             

@ENDNODE
@NODE File "gadgets/button.h"
#ifndef GADGETS_BUTTON_H
#define GADGETS_BUTTON_H
/*
**      $VER: button.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      button.gadget definitions
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

/*****************************************************************************/

#ifndef REACTION_REACTION_H
#include <@{"reaction/reaction.h" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File"}>
#endif

#ifndef INTUITION_GADGETCLASS_H
#include <@{"intuition/gadgetclass.h" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File"}>
#endif

#ifndef IMAGES_BEVEL_H
#include <@{"images/bevel.h" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File"}>
#endif

/*****************************************************************************/

/* Additional attributes defined by the button.gadget class
 * Our class supports most functions of C= button developer release,
 * however we support many additional options as noted below.
 */

#define BUTTON_Dummy                    (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48}+0x04000000)

#define BUTTON_PushButton               (@{"BUTTON_Dummy" LINK File 34}+1)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Indicate whether button stays depressed when clicked */

#define BUTTON_Glyph                    (@{"BUTTON_Dummy" LINK File 34}+2)
        /* (@{"struct Image" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 705} *) Indicate that image is to be drawn using
         * @{"BltTemplate" LINK "gg:doc/NDK/Guide/graphics/BltTemplate"}. Note this tag is only partial support, only single
         * plane glyphs are rendered correctly.
         */

#define BUTTON_TextPen                  (@{"BUTTON_Dummy" LINK File 34}+5)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Pen to use for text (-1 uses @{"TEXTPEN" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 96}) */

#define BUTTON_FillPen                  (@{"BUTTON_Dummy" LINK File 34}+6)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Pen to use for fill (-1 uses @{"FILLPEN" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 99}) */

#define BUTTON_FillTextPen              (@{"BUTTON_Dummy" LINK File 34}+7)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Pen to use for fill (-1 uses @{"FILLTEXTPEN" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 100}) */

#define BUTTON_BackgroundPen    (@{"BUTTON_Dummy" LINK File 34}+8)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Pen to use for fill (-1 uses @{"BACKGROUNDPEN" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 101}) */

#define BUTTON_RenderImage              @{"GA_Image" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 65}
#define BUTTON_SelectImage              @{"GA_SelectRender" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 71}

#define BUTTON_BevelStyle               (@{"BUTTON_Dummy" LINK File 34}+13)
        /* Bevel Box Style */

#define BUTTON_Transparent              (@{"BUTTON_Dummy" LINK File 34}+15)
        /* Button is transparent, @{"EraseRect" LINK "gg:doc/NDK/Guide/graphics/EraseRect"} fill pattern used (if any)
         * to render button background.
         */

#define BUTTON_Justification    (@{"BUTTON_Dummy" LINK File 34}+16)
        /* LEFT/RIGHT/CENTER jutification of @{"GA_Text" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 62} text */

#define BUTTON_SoftStyle                (@{"BUTTON_Dummy" LINK File 34}+17)
        /* Sets Font SoftStyle, ie, Bold, Italics, etc */

#define BUTTON_AutoButton               (@{"BUTTON_Dummy" LINK File 34}+18)
        /* Automatically creates a button with standard scaled glyphs */

#define BUTTON_VarArgs                  (@{"BUTTON_Dummy" LINK File 34}+19)
        /* Argument array for @{"GA_Text" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 62} varargs string */

#define BUTTON_DomainString             (@{"BUTTON_Dummy" LINK File 34}+20)
        /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) default string used for domain calculation */

#define BUTTON_Integer                  (@{"BUTTON_Dummy" LINK File 34}+21)
        /* (int) integer value to display a numeric string.
         * Useful with notifications from sliders, scrollers, etc
         */

#define BUTTON_BitMap                   (@{"BUTTON_Dummy" LINK File 34}+22)
        /* (@{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *) BitMap to render in button, rather than an image... */

#define BUTTON_AnimButton               (@{"BUTTON_Dummy" LINK File 34}+50)
        /* (BOOl) Is button animatable?  Use to turn animating on or off */

#define BUTTON_AnimImages               (@{"BUTTON_Dummy" LINK File 34}+51)
        /* (@{"struct Image" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 705} *) Sets an array of struct Images for animation */

#define BUTTON_SelAnimImages    (@{"BUTTON_Dummy" LINK File 34}+52)
        /* (@{"struct Image" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 705} *) sets an array of alternate images for a selected
         * state if used, must contain an equal number of images as the
         * array used for @{"BUTTON_AnimImages" LINK File 94}.  It's wise to use the
         * same sized images too
         */

#define BUTTON_MaxAnimImages    (@{"BUTTON_Dummy" LINK File 34}+53)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Number of images available in the arrays */

#define BUTTON_AnimImageNumber  (@{"BUTTON_Dummy" LINK File 34}+54)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Current image number in the array(s) to use
         * the range of available frames is 0..MaxAnimImages-1
         */

#define BUTTON_AddAnimImageNumber (@{"BUTTON_Dummy" LINK File 34}+55)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Value to be added to the current image number counter
         * the counter will wrap around at MaxAnimImages
         */

#define BUTTON_SubAnimImageNumber (@{"BUTTON_Dummy" LINK File 34}+56)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Value to be subtracted from the current image number counter
         * the counter will wrap around when less than 0
         */

/****************************************************************************/

/* Justification modes for @{"BUTTON_Justification" LINK File 68}.
 */
#define BCJ_LEFT        0
#define BCJ_CENTER      1               /* default - center text */
#define BCJ_RIGHT       2

#define BCJ_CENTRE @{"BCJ_CENTER" LINK File 127}

/* Built-in button glyphs for @{"BUTTON_AutoButton" LINK File 74}.
 */

#define BAG_POPFILE             1       /* popup file req */
#define BAG_POPDRAWER   2       /* popup drawer req */
#define BAG_POPFONT             3       /* popup font req */
#define BAG_CHECKBOX    4       /* check glyph button */
#define BAG_CANCELBOX   5       /* cancel glyph button */
#define BAG_UPARROW             6       /* up arrow */
#define BAG_DNARROW             7       /* down arrow */
#define BAG_RTARROW             8       /* right arrow */
#define BAG_LFARROW             9       /* left arrow */
#define BAG_POPTIME             10      /* popup time glyph */
#define BAG_POPSCREEN   11      /* popup screen mode glyph */
#define BAG_POPUP               12      /* generic popup */

/*****************************************************************************/

#endif /* GADGETS_BUTTON_H */
@ENDNODE
