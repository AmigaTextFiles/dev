@DATABASE "gg:doc/NDK/Guide/Include/gadgets/speedbar.h"
@MASTER   "gg:os-include/gadgets/speedbar.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:44
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "gadgets/speedbar.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"gadgets/speedbar.h" LINK File}


@{b}#defines@{ub}

@{"SBH_BACKFILL" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 77}          @{"SBH_IMAGE" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 79}             @{"SBH_NONE" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 76}
@{"SBH_RECESS" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 78}            @{"SBNA_Disabled" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 71}         @{"SBNA_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 27}
@{"SBNA_Enabled" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 44}          @{"SBNA_Height" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 38}           @{"SBNA_Help" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 59}
@{"SBNA_Highlight" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 50}        @{"SBNA_Image" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 53}            @{"SBNA_Left" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 29}
@{"SBNA_MXGroup" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 68}          @{"SBNA_Selected" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 65}         @{"SBNA_SelImage" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 56}
@{"SBNA_Spacing" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 47}          @{"SBNA_Toggle" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 62}           @{"SBNA_Top" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 32}
@{"SBNA_UserData" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 41}         @{"SBNA_Width" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 35}            @{"SBORIENT_HORIZ" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 142}
@{"SBORIENT_VERT" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 143}         @{"SPEEDBAR_Background" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 93}   @{"SPEEDBAR_BevelStyle" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 126}
@{"SPEEDBAR_Buttons" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 87}      @{"SPEEDBAR_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 85}        @{"SPEEDBAR_EvenSize" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 135}
@{"SPEEDBAR_Help" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 123}         @{"SPEEDBAR_HORIZONTAL" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 147}   @{"SPEEDBAR_OffButton" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 105}
@{"SPEEDBAR_OnButton" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 102}     @{"SPEEDBAR_Orientation" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 90}  @{"SPEEDBAR_ScrollLeft" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 108}
@{"SPEEDBAR_ScrollRight" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 111}  @{"SPEEDBAR_Selected" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 129}     @{"SPEEDBAR_SelectedNode" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 132}
@{"SPEEDBAR_StrumBar" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 99}     @{"SPEEDBAR_Top" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 114}          @{"SPEEDBAR_Total" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 120}
@{"SPEEDBAR_VERTICAL" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 148}     @{"SPEEDBAR_Visible" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 117}      @{"SPEEDBAR_Window" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File" 96}

@ENDNODE
@NODE File "gadgets/speedbar.h"
#ifndef GADGETS_SPEEDBAR_H
#define GADGETS_SPEEDBAR_H
/*
**      $VER: speedbar.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      Definitions for the speedbar.gadget BOOPSI class
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

/* Defines for the speedbar node attributes.
 */
#define SBNA_Dummy              (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48}+0x010000)

#define SBNA_Left               (@{"SBNA_Dummy" LINK File 27}+1)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) left offset of button. */

#define SBNA_Top                (@{"SBNA_Dummy" LINK File 27}+2)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) top offset of button. */

#define SBNA_Width              (@{"SBNA_Dummy" LINK File 27}+3)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) width of button. */

#define SBNA_Height             (@{"SBNA_Dummy" LINK File 27}+4)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) height of button. */

#define SBNA_UserData   (@{"SBNA_Dummy" LINK File 27}+5)
        /* (@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}) user data, have a blast. */

#define SBNA_Enabled    (@{"SBNA_Dummy" LINK File 27}+6)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Is this button enabled?. */

#define SBNA_Spacing    (@{"SBNA_Dummy" LINK File 27}+7)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) spacing from last button. */

#define SBNA_Highlight  (@{"SBNA_Dummy" LINK File 27}+8)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) highlight mode (see below). */

#define SBNA_Image              (@{"SBNA_Dummy" LINK File 27}+9)
        /* (strcut Image *) render image pointer. */

#define SBNA_SelImage   (@{"SBNA_Dummy" LINK File 27}+10)
        /* (strcut Image *) select image pointer. */

#define SBNA_Help               (@{"SBNA_Dummy" LINK File 27}+11)
        /* (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *) optional help text message pointer. */

#define SBNA_Toggle             (@{"SBNA_Dummy" LINK File 27}+12)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Make button a toggle button */

#define SBNA_Selected   (@{"SBNA_Dummy" LINK File 27}+13)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Sets state of a toggle button */

#define SBNA_MXGroup    (@{"SBNA_Dummy" LINK File 27}+14)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Mutual Exclusion Group Button, implies @{"SBNA_Toggle" LINK File 62} */

#define SBNA_Disabled   (@{"SBNA_Dummy" LINK File 27}+15)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Disable this button, ghost pattern to be rendered */

/* Possible highlight modes.
 */
#define SBH_NONE                0
#define SBH_BACKFILL    1
#define SBH_RECESS              2
#define SBH_IMAGE               3

/*****************************************************************************/

/* Additional attributes defined by the speedbar.gadget class
 */
#define SPEEDBAR_Dummy                  (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26} + 0x13000)

#define SPEEDBAR_Buttons                (@{"SPEEDBAR_Dummy" LINK File 85}+1)
        /* (@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *) button list */

#define SPEEDBAR_Orientation    (@{"SPEEDBAR_Dummy" LINK File 85}+2)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Horizontal/vertical mode */

#define SPEEDBAR_Background             (@{"SPEEDBAR_Dummy" LINK File 85}+3)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) SpeedBar Background color */

#define SPEEDBAR_Window                 (@{"SPEEDBAR_Dummy" LINK File 85}+4)
        /* (@{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *) Window for WindowBar help */

#define SPEEDBAR_StrumBar               (@{"SPEEDBAR_Dummy" LINK File 85}+5)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Allow struming of button bar */

#define SPEEDBAR_OnButton               (@{"SPEEDBAR_Dummy" LINK File 85}+6)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Turn on a button by id# */

#define SPEEDBAR_OffButton              (@{"SPEEDBAR_Dummy" LINK File 85}+7)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Turn off a button by id# */

#define SPEEDBAR_ScrollLeft             (@{"SPEEDBAR_Dummy" LINK File 85}+8)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Scroll buttons left */

#define SPEEDBAR_ScrollRight    (@{"SPEEDBAR_Dummy" LINK File 85}+9)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Scroll buttons right */

#define SPEEDBAR_Top                    (@{"SPEEDBAR_Dummy" LINK File 85}+10)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) First visible */

#define SPEEDBAR_Visible                (@{"SPEEDBAR_Dummy" LINK File 85}+11)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Number visible */

#define SPEEDBAR_Total                  (@{"SPEEDBAR_Dummy" LINK File 85}+12)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Total in list */

#define SPEEDBAR_Help                   (@{"SPEEDBAR_Dummy" LINK File 85}+13)
        /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) Window/Screen Help Text */

#define SPEEDBAR_BevelStyle             (@{"SPEEDBAR_Dummy" LINK File 85}+14)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Bevel box style (@{"BVS_BUTTON" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 87},@{"BVS_THIN" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 86},@{"BVS_NONE" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 90}) */

#define SPEEDBAR_Selected                       (@{"SPEEDBAR_Dummy" LINK File 85}+15)
        /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) last selected speedbar node number */

#define SPEEDBAR_SelectedNode   (@{"SPEEDBAR_Dummy" LINK File 85}+16)
        /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) last selected speedbar node pointer */

#define SPEEDBAR_EvenSize       (@{"SPEEDBAR_Dummy" LINK File 85}+17)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) size all buttons in bar evenly, using the largest image */

/*****************************************************************************/

/* @{"SPEEDBAR_Orientation" LINK File 90} Modes
 */
#define SBORIENT_HORIZ  0
#define SBORIENT_VERT   1

/* OBSOLETE DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE.
 */
#define SPEEDBAR_HORIZONTAL     @{"SBORIENT_HORIZ" LINK File 142}
#define SPEEDBAR_VERTICAL       @{"SBORIENT_VERT" LINK File 143}

#endif /* GADGETS_SPEEDBAR_H */
@ENDNODE
