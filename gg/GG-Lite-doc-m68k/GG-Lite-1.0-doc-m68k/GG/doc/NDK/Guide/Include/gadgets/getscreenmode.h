@DATABASE "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h"
@MASTER   "gg:os-include/gadgets/getscreenmode.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:30
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "gadgets/getscreenmode.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"gadgets/getscreenmode.h" LINK File}


@{b}Structures@{ub}

@{"gsmRequest" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 127}


@{b}#defines@{ub}

@{"GETSCREENMODE_AutoScroll" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 59}    @{"GETSCREENMODE_CustomSMList" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 113}
@{"GETSCREENMODE_DisplayDepth" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 53}  @{"GETSCREENMODE_DisplayHeight" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 50}
@{"GETSCREENMODE_DisplayID" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 44}     @{"GETSCREENMODE_DisplayWidth" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 47}
@{"GETSCREENMODE_DoAutoScroll" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 83}  @{"GETSCREENMODE_DoDepth" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 77}
@{"GETSCREENMODE_DoHeight" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 74}      @{"GETSCREENMODE_DoOverscanType" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 80}
@{"GETSCREENMODE_DoWidth" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 71}       @{"GETSCREENMODE_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 27}
@{"GETSCREENMODE_FilterFunc" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 110}    @{"GETSCREENMODE_Height" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 32}
@{"GETSCREENMODE_InfoLeftEdge" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 65}  @{"GETSCREENMODE_InfoOpened" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 62}
@{"GETSCREENMODE_InfoTopEdge" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 68}   @{"GETSCREENMODE_LeftEdge" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 38}
@{"GETSCREENMODE_MaxDepth" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 107}      @{"GETSCREENMODE_MaxHeight" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 101}
@{"GETSCREENMODE_MaxWidth" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 95}      @{"GETSCREENMODE_MinDepth" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 104}
@{"GETSCREENMODE_MinHeight" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 98}     @{"GETSCREENMODE_MinWidth" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 92}
@{"GETSCREENMODE_OverscanType" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 56}  @{"GETSCREENMODE_PropertyFlags" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 86}
@{"GETSCREENMODE_PropertyMask" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 89}  @{"GETSCREENMODE_TitleText" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 29}
@{"GETSCREENMODE_TopEdge" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 41}       @{"GETSCREENMODE_Width" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 35}
@{"GSM_REQUEST" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 121}                 @{"RequestScreenMode()" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File" 136}

@ENDNODE
@NODE File "gadgets/getscreenmode.h"
#ifndef GADGETS_GETSCREENMODE_H
#define GADGETS_GETSCREENMODE_H
/*
**      $VER: getscreenmode.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      Definitions for the @{"getscreenmode.gadget" LINK "gg:doc/NDK/Guide/getscreenmode_gc/MAIN"} BOOPSI class
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
#define GETSCREENMODE_Dummy                             (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26} + 0x41000)

#define GETSCREENMODE_TitleText                 (@{"GETSCREENMODE_Dummy" LINK File 27}+1)
        /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) Title of the screenmode requester (default: None) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETSCREENMODE_Height                    (@{"GETSCREENMODE_Dummy" LINK File 27}+2)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Height of the screenmode requester (default: 200) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}) */

#define GETSCREENMODE_Width                             (@{"GETSCREENMODE_Dummy" LINK File 27}+3)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Width of the screenmode requester (default: 300) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}) */

#define GETSCREENMODE_LeftEdge                  (@{"GETSCREENMODE_Dummy" LINK File 27}+4)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Left edge of the screenmode requester (default: 30) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}) */

#define GETSCREENMODE_TopEdge                   (@{"GETSCREENMODE_Dummy" LINK File 27}+5)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Top edge of the screenmode requester (default: 20) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}) */

#define GETSCREENMODE_DisplayID                 (@{"GETSCREENMODE_Dummy" LINK File 27}+6)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) display id of screenmode (default: 0 (@{"LORES_KEY" LINK "gg:doc/NDK/Guide/Include/graphics/modeid.h/File" 48})) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}, @{"OM_NOTIFY" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 69}) */

#define GETSCREENMODE_DisplayWidth              (@{"GETSCREENMODE_Dummy" LINK File 27}+7)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Display width (default: 640) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}, @{"OM_NOTIFY" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 69}) */

#define GETSCREENMODE_DisplayHeight             (@{"GETSCREENMODE_Dummy" LINK File 27}+8)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Display height (default: 200) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}, @{"OM_NOTIFY" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 69}) */

#define GETSCREENMODE_DisplayDepth              (@{"GETSCREENMODE_Dummy" LINK File 27}+9)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) Display depth (default: 2) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}, @{"OM_NOTIFY" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 69}) */

#define GETSCREENMODE_OverscanType              (@{"GETSCREENMODE_Dummy" LINK File 27}+10)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) Type of overscan (default: @{"OSCAN_TEXT" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 531}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}, @{"OM_NOTIFY" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 69}) */

#define GETSCREENMODE_AutoScroll                (@{"GETSCREENMODE_Dummy" LINK File 27}+11)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Autoscroll setting(default: @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_NOTIFY" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 69}) */

#define GETSCREENMODE_InfoOpened                (@{"GETSCREENMODE_Dummy" LINK File 27}+12)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Info window initially opened?(default: @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETSCREENMODE_InfoLeftEdge              (@{"GETSCREENMODE_Dummy" LINK File 27}+13)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Info window left edge (default: 30) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}) */

#define GETSCREENMODE_InfoTopEdge               (@{"GETSCREENMODE_Dummy" LINK File 27}+14)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Info window top edge (default: 20) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}) */

#define GETSCREENMODE_DoWidth                   (@{"GETSCREENMODE_Dummy" LINK File 27}+15)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Display Width gadget? (default: @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETSCREENMODE_DoHeight                  (@{"GETSCREENMODE_Dummy" LINK File 27}+16)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Display Height gadget? (default: @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETSCREENMODE_DoDepth                   (@{"GETSCREENMODE_Dummy" LINK File 27}+17)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Display Depth gadget? (default: @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETSCREENMODE_DoOverscanType    (@{"GETSCREENMODE_Dummy" LINK File 27}+18)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Display Overscan Type gadget? (default: @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETSCREENMODE_DoAutoScroll              (@{"GETSCREENMODE_Dummy" LINK File 27}+19)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Display AutoScroll gadget? (default: @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETSCREENMODE_PropertyFlags             (@{"GETSCREENMODE_Dummy" LINK File 27}+20)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Must have these Property flags (default: @{"DIPF_IS_WB" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 98}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETSCREENMODE_PropertyMask              (@{"GETSCREENMODE_Dummy" LINK File 27}+21)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Only these should be looked at (default: @{"DIPF_IS_WB" LINK "gg:doc/NDK/Guide/Include/graphics/displayinfo.h/File" 98}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETSCREENMODE_MinWidth                  (@{"GETSCREENMODE_Dummy" LINK File 27}+22)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Minimum display width to allow (default: 16) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETSCREENMODE_MaxWidth                  (@{"GETSCREENMODE_Dummy" LINK File 27}+23)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Maximum display width to allow (default: 16368) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETSCREENMODE_MinHeight                 (@{"GETSCREENMODE_Dummy" LINK File 27}+24)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Minimum display height to allow (default: 16) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETSCREENMODE_MaxHeight                 (@{"GETSCREENMODE_Dummy" LINK File 27}+25)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Maximum display height to allow (default: 16368) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETSCREENMODE_MinDepth                  (@{"GETSCREENMODE_Dummy" LINK File 27}+26)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Minimum display depth to allow (default: 1) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETSCREENMODE_MaxDepth                  (@{"GETSCREENMODE_Dummy" LINK File 27}+27)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Maximum display depth to allow (default: 24) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETSCREENMODE_FilterFunc                (@{"GETSCREENMODE_Dummy" LINK File 27}+28)
        /* (@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *) Function to filter mode id's (default: None) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETSCREENMODE_CustomSMList              (@{"GETSCREENMODE_Dummy" LINK File 27}+29)
        /* (@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *) Exec list of @{"struct DisplayMode" LINK "gg:doc/NDK/Guide/Include/libraries/asl.h/File" 330} (default: None) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

/*****************************************************************************/

/*
 * @{"getfont.gadget" LINK "gg:doc/NDK/Guide/getfont_gc/MAIN"} methods
 */
#define GSM_REQUEST     (0x610001L)

/* The @{"GSM_REQUEST" LINK File 121} method should be called whenever you want to open
 * a screenmode requester.
 */

struct gsmRequest
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID;                         /* @{"GSM_REQUEST" LINK File 121} */
        @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *gsmr_Window;     /* The window that will be locked when the requester is active.
                                                                If not provided, no window will be locked and no visual updating
                                                                of any gadgets will take place. This should be the window the gadget
                                                                resides in. */
};

#define RequestScreenMode(obj, win)     DoMethod(obj, @{"GSM_REQUEST" LINK File 121}, win)

#endif /* GADGETS_GETSCREENMODE_H */
@ENDNODE
