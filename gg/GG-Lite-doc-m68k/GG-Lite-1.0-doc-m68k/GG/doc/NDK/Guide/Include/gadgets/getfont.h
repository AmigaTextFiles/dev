@DATABASE "gg:doc/NDK/Guide/Include/gadgets/getfont.h"
@MASTER   "gg:os-include/gadgets/getfont.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:29
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "gadgets/getfont.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"gadgets/getfont.h" LINK File}


@{b}Structures@{ub}

@{"gfRequest" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 110}


@{b}#defines@{ub}

@{"GETFONT_BackPen" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 72}     @{"GETFONT_BackPens" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 90}    @{"GETFONT_DoBackPen" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 36}
@{"GETFONT_DoDrawMode" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 42}  @{"GETFONT_DoFrontPen" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 33}  @{"GETFONT_DoStyle" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 39}
@{"GETFONT_DrawMode" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 75}    @{"GETFONT_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 27}       @{"GETFONT_FixedWidthOnly" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 51}
@{"GETFONT_FrontPen" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 69}    @{"GETFONT_FrontPens" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 87}   @{"GETFONT_Height" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 57}
@{"GETFONT_LeftEdge" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 63}    @{"GETFONT_MaxBackPen" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 81}  @{"GETFONT_MaxFrontPen" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 78}
@{"GETFONT_MaxHeight" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 48}   @{"GETFONT_MinHeight" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 45}   @{"GETFONT_ModeList" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 84}
@{"GETFONT_SoftStyle" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 93}   @{"GETFONT_TextAttr" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 29}    @{"GETFONT_TitleText" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 54}
@{"GETFONT_TopEdge" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 66}     @{"GETFONT_Width" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 60}       @{"GFONT_REQUEST" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 104}
@{"gfRequestFont()" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File" 116}     

@ENDNODE
@NODE File "gadgets/getfont.h"
#ifndef GADGETS_GETFONT_H
#define GADGETS_GETFONT_H
/*
**      $VER: getfont.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      Definitions for the @{"getfont.gadget" LINK "gg:doc/NDK/Guide/getfont_gc/MAIN"} BOOPSI class
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

/*****************************************************************************/

/* Attributes defined by the @{"getfont.gadget" LINK "gg:doc/NDK/Guide/getfont_gc/MAIN"} class
 */
#define GETFONT_Dummy                   (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26} + 0x40000)

#define GETFONT_TextAttr                (@{"GETFONT_Dummy" LINK File 27}+1)
        /* (@{"struct TextAttr" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 65} *) Font to show in the gadget (default: None)
                                (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}, @{"OM_NOTIFY" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 69}) */

#define GETFONT_DoFrontPen              (@{"GETFONT_Dummy" LINK File 27}+2)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Do front pen (default: @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETFONT_DoBackPen               (@{"GETFONT_Dummy" LINK File 27}+3)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Do back pen (default: @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETFONT_DoStyle                 (@{"GETFONT_Dummy" LINK File 27}+4)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Do style (default: @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETFONT_DoDrawMode              (@{"GETFONT_Dummy" LINK File 27}+5)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Do draw mode (default: @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETFONT_MinHeight               (@{"GETFONT_Dummy" LINK File 27}+6)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) Minimum font height (default: 6) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETFONT_MaxHeight               (@{"GETFONT_Dummy" LINK File 27}+7)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) Maximum font height (default: 20) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETFONT_FixedWidthOnly  (@{"GETFONT_Dummy" LINK File 27}+8)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Only show fixed width fonts (default: @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETFONT_TitleText               (@{"GETFONT_Dummy" LINK File 27}+9)
        /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) Title of the ASL font requester (default: None) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETFONT_Height                  (@{"GETFONT_Dummy" LINK File 27}+10)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Height of the ASL font requester (default: 200) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}) (ASL V38) */

#define GETFONT_Width                   (@{"GETFONT_Dummy" LINK File 27}+11)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Width of the ASL font requester (default: 300) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}) (ASL V38) */

#define GETFONT_LeftEdge                (@{"GETFONT_Dummy" LINK File 27}+12)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Left edge of the ASL font requester (default: 30) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}) */

#define GETFONT_TopEdge                 (@{"GETFONT_Dummy" LINK File 27}+13)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Top edge of the ASL font requester (default: 20) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}) */

#define GETFONT_FrontPen                (@{"GETFONT_Dummy" LINK File 27}+14)
        /* (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}) Front pen (default: 1) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}, @{"OM_NOTIFY" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 69}) */

#define GETFONT_BackPen                 (@{"GETFONT_Dummy" LINK File 27}+15)
        /* (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}) Back pen (default: 0) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}, @{"OM_NOTIFY" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 69}) */

#define GETFONT_DrawMode                (@{"GETFONT_Dummy" LINK File 27}+16)
        /* (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}) Draw mode (default: @{"JAM1" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 90}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}, @{"OM_NOTIFY" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 69}) */

#define GETFONT_MaxFrontPen             (@{"GETFONT_Dummy" LINK File 27}+17)
        /* (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}) Max number of colors in front palette (default: 255) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) (ASL V40) */

#define GETFONT_MaxBackPen              (@{"GETFONT_Dummy" LINK File 27}+18)
        /* (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}) Max number of colors in back palette (default: 255) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) (ASL V40) */

#define GETFONT_ModeList                (@{"GETFONT_Dummy" LINK File 27}+19)
        /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} *) Substitute list for drawmodes (default: None) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETFONT_FrontPens               (@{"GETFONT_Dummy" LINK File 27}+20)
        /* (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *) Color table for front pen palette (default: None) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) (ASL V40) */

#define GETFONT_BackPens                (@{"GETFONT_Dummy" LINK File 27}+21)
        /* (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *) Color table for back pen palette (default: None) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) (ASL V40) */

#define GETFONT_SoftStyle               (@{"GETFONT_Dummy" LINK File 27}+22)
        /* (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}) SoftStyle, provided only for making mapping to button.gadget easier (@{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}, @{"OM_NOTIFY" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 69})
                        textattr.ta_Style in the @{"GETFONT_TextAttr" LINK File 29} attribute will provide the style in other
                        cases.
        */

/*****************************************************************************/

/*
 * @{"getfont.gadget" LINK "gg:doc/NDK/Guide/getfont_gc/MAIN"} methods
 */
#define GFONT_REQUEST   (0x600001L)

/* The @{"GFONT_REQUEST" LINK File 104} method should be called whenever you want to open
 * a font requester.
 */

struct gfRequest
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID;                         /* @{"GFONT_REQUEST" LINK File 104} */
        @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *gfr_Window;      /* The window that will be locked when the requester is active. MUST be provided! */
};

#define gfRequestFont(obj, win) DoMethod(obj, @{"GFONT_REQUEST" LINK File 104}, win)

#endif /* GADGETS_GETFONT_H */
@ENDNODE
