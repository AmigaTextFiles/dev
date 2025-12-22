@DATABASE "gg:doc/NDK/Guide/Include/images/bevel.h"
@MASTER   "gg:os-include/images/bevel.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:19
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "images/bevel.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"images/bevel.h" LINK File}


@{b}#defines@{ub}

@{"BEVEL_ColorMap" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 74}     @{"BEVEL_ColourMap" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 75}   @{"BEVEL_Dummy" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 25}
@{"BEVEL_FillPattern" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 62}  @{"BEVEL_FillPen" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 59}     @{"BEVEL_Flags" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 79}
@{"BEVEL_HorizSize" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 51}    @{"BEVEL_HorzSize" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 53}    @{"BEVEL_InnerHeight" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 48}
@{"BEVEL_InnerLeft" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 42}    @{"BEVEL_InnerTop" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 39}    @{"BEVEL_InnerWidth" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 45}
@{"BEVEL_Label" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 30}        @{"BEVEL_LabelImage" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 33}  @{"BEVEL_LabelPlace" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 36}
@{"BEVEL_SoftStyle" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 71}    @{"BEVEL_Style" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 27}       @{"BEVEL_TextPen" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 65}
@{"BEVEL_Transparent" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 68}  @{"BEVEL_VertSize" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 56}    @{"BFLG_TRANS" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 116}
@{"BFLG_XENFILL" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 115}       @{"BVJ_BOT_CENTER" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 127}    @{"BVJ_BOT_LEFT" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 128}
@{"BVJ_BOT_RIGHT" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 129}      @{"BVJ_IN_CENTER" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 124}     @{"BVJ_IN_LEFT" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 125}
@{"BVJ_IN_RIGHT" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 126}       @{"BVJ_TOP_CENTER" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 121}    @{"BVJ_TOP_LEFT" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 122}
@{"BVJ_TOP_RIGHT" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 123}      @{"BVS_BOX" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 103}           @{"BVS_BUTTON" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 87}
@{"BVS_DROPBOX" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 91}        @{"BVS_FIELD" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 89}         @{"BVS_FOCUS" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 110}
@{"BVS_GROUP" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 88}          @{"BVS_NONE" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 90}          @{"BVS_RADIOBUTTON" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 111}
@{"BVS_SBAR_HORIZ" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 101}     @{"BVS_SBAR_HORZ" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 106}     @{"BVS_SBAR_VERT" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 102}
@{"BVS_STANDARD" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 104}       @{"BVS_THIN" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 86}          

@ENDNODE
@NODE File "images/bevel.h"
#ifndef IMAGES_BEVEL_H
#define IMAGES_BEVEL_H
/*
**      $VER: bevel.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      Definitions for the bevel.image BOOPSI class
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

/*****************************************************************************/

#ifndef REACTRION_REACTION_H
#include <@{"reaction/reaction.h" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File"}>
#endif

#ifndef INTUITION_IMAGECLASS_H
#include <@{"intuition/imageclass.h" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File"}>
#endif

/*****************************************************************************/

#define BEVEL_Dummy                     (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26} + 0x16000)

#define BEVEL_Style                     (@{"BEVEL_Dummy" LINK File 25}+1)
        /* (@{"USHORT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 82}) Selected bevel style, see BEVEL_* defines below */

#define BEVEL_Label                     (@{"BEVEL_Dummy" LINK File 25}+3)
        /* (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *) Label text, usually for button or group box labels */

#define BEVEL_LabelImage        (@{"BEVEL_Dummy" LINK File 25}+4)
        /* (@{"struct Image" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 705} *) Unsupported label image */

#define BEVEL_LabelPlace        (@{"BEVEL_Dummy" LINK File 25}+5)
        /* (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}) Label placement, see BVJ_* defines below */

#define BEVEL_InnerTop          (@{"BEVEL_Dummy" LINK File 25}+6)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) (@{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}) - render offset not included */

#define BEVEL_InnerLeft         (@{"BEVEL_Dummy" LINK File 25}+7)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) (@{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}) - render offset not included */

#define BEVEL_InnerWidth        (@{"BEVEL_Dummy" LINK File 25}+8)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) (@{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}) - inner bevel area size */

#define BEVEL_InnerHeight       (@{"BEVEL_Dummy" LINK File 25}+9)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) (@{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}) - inner bevel area size */

#define BEVEL_HorizSize         (@{"BEVEL_Dummy" LINK File 25}+10)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) (@{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}) - bevel line thickness */
#define BEVEL_HorzSize  @{"BEVEL_HorizSize" LINK File 51}
        /* OBSOLETE, use @{"BEVEL_HorizSize" LINK File 51} instead */

#define BEVEL_VertSize          (@{"BEVEL_Dummy" LINK File 25}+11)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) (@{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}) - bevel line thickness */

#define BEVEL_FillPen           (@{"BEVEL_Dummy" LINK File 25}+12)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}/@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) - optional inner bevel fill */

#define BEVEL_FillPattern       (@{"BEVEL_Dummy" LINK File 25}+13)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} *) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}/@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) - optional fill pattern for inner fill/disable */

#define BEVEL_TextPen           (@{"BEVEL_Dummy" LINK File 25}+14)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}/@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) - optional text pen color */

#define BEVEL_Transparent       (@{"BEVEL_Dummy" LINK File 25}+15)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}/@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) - disable inner bevel fill/erase modes */

#define BEVEL_SoftStyle         (@{"BEVEL_Dummy" LINK File 25}+16)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}/@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) - Text SoftStyle */

#define BEVEL_ColorMap          (@{"BEVEL_Dummy" LINK File 25}+17)
#define BEVEL_ColourMap @{"BEVEL_ColorMap" LINK File 74}
        /* (@{"struct ColorMap" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 143} *) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}/@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) - Screen ViewPort ColorMap
         * This required tag is for proper @{"BVS_BUTTON" LINK File 87} xen shadow pen selection */

#define BEVEL_Flags                     (@{"BEVEL_Dummy" LINK File 25}+18)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}/@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) Intentionally left undocumented! */

/*****************************************************************************/

/* Bevel Box Styles for @{"BEVEL_Style" LINK File 27}
 */
#define BVS_THIN                0       /* Thin (usually 1 pixel) bevel. */
#define BVS_BUTTON              1       /* Standard button bevel. */
#define BVS_GROUP               2       /* Group box bevel. */
#define BVS_FIELD               3       /* String/integer/text field bevel. */
#define BVS_NONE                4       /* No not render any bevel. */
#define BVS_DROPBOX             5       /* Drop box area. */
/*
 * You may think it is very stupid to name the vertical bar @{"BVS_SBAR_HORIZ" LINK File 101}
 * and the horizontal bar @{"BVS_SBAR_VERT" LINK File 102}. The reason for this is:
 * The vertical bar is mostly used as a seperator in horizontal groups and the
 * horizontal bar is used as a seperator in vertical groups.
 *
 * Another explanation: It was simply a mistake when defining the names the
 * first time.
 */
#define BVS_SBAR_HORIZ  6       /* Vertical bar. */
#define BVS_SBAR_VERT   7       /* Horizontal bar. */
#define BVS_BOX                 8       /* Typically, thin black border. */
#define BVS_STANDARD    11      /* Same as @{"BVS_BUTTON" LINK File 87} but will not support XEN */

#define BVS_SBAR_HORZ   @{"BVS_SBAR_HORIZ" LINK File 101}  /* OBSOLETE SPELLING */

/* The following bevel types are not implemented yet
 */
#define BVS_FOCUS               9       /* Typically, the border for drag&drop target. */
#define BVS_RADIOBUTTON 10  /* (not implemented) radiobutton bevel. */

/* @{"BEVEL_Flags" LINK File 79} - CURRENTLY PRIVATE!!
 */
#define BFLG_XENFILL    0x01
#define BFLG_TRANS              0x02

/* Bevel Box Locations for @{"BEVEL_LabelPlace" LINK File 36}.  Typically used to label a group
 * box, or to be utilized via a button or status gadgets.
 */
#define BVJ_TOP_CENTER  0
#define BVJ_TOP_LEFT    1
#define BVJ_TOP_RIGHT   2
#define BVJ_IN_CENTER   3
#define BVJ_IN_LEFT             4
#define BVJ_IN_RIGHT    5
#define BVJ_BOT_CENTER  6
#define BVJ_BOT_LEFT    7
#define BVJ_BOT_RIGHT   8

#endif /* IMAGES_BEVEL_H */
@ENDNODE
