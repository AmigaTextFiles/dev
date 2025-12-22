@DATABASE "gg:doc/NDK/Guide/Include/gadgets/clicktab.h"
@MASTER   "gg:os-include/gadgets/clicktab.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:24
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "gadgets/clicktab.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"gadgets/clicktab.h" LINK File}


@{b}#defines@{ub}

@{"CLICKTAB_Current" LINK "gg:doc/NDK/Guide/Include/gadgets/clicktab.h/File" 63}            @{"CLICKTAB_CurrentNode" LINK "gg:doc/NDK/Guide/Include/gadgets/clicktab.h/File" 66}  @{"CLICKTAB_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/clicktab.h/File" 58}
@{"CLICKTAB_Labels" LINK "gg:doc/NDK/Guide/Include/gadgets/clicktab.h/File" 60}             @{"CLICKTAB_Orientation" LINK "gg:doc/NDK/Guide/Include/gadgets/clicktab.h/File" 69}  @{"CLICKTAB_PageGroup" LINK "gg:doc/NDK/Guide/Include/gadgets/clicktab.h/File" 72}
@{"CLICKTAB_PageGroupBackFill" LINK "gg:doc/NDK/Guide/Include/gadgets/clicktab.h/File" 75}  @{"CTORIENT_HORIZ" LINK "gg:doc/NDK/Guide/Include/gadgets/clicktab.h/File" 82}        @{"CTORIENT_HORIZFLIP" LINK "gg:doc/NDK/Guide/Include/gadgets/clicktab.h/File" 84}
@{"CTORIENT_VERT" LINK "gg:doc/NDK/Guide/Include/gadgets/clicktab.h/File" 83}               @{"CTORIENT_VERTFLIP" LINK "gg:doc/NDK/Guide/Include/gadgets/clicktab.h/File" 85}     @{"TNA_Disabled" LINK "gg:doc/NDK/Guide/Include/gadgets/clicktab.h/File" 51}
@{"TNA_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/clicktab.h/File" 27}                   @{"TNA_Enabled" LINK "gg:doc/NDK/Guide/Include/gadgets/clicktab.h/File" 32}           @{"TNA_Highlight" LINK "gg:doc/NDK/Guide/Include/gadgets/clicktab.h/File" 34}
@{"TNA_Image" LINK "gg:doc/NDK/Guide/Include/gadgets/clicktab.h/File" 36}                   @{"TNA_Number" LINK "gg:doc/NDK/Guide/Include/gadgets/clicktab.h/File" 45}            @{"TNA_SelImage" LINK "gg:doc/NDK/Guide/Include/gadgets/clicktab.h/File" 39}
@{"TNA_Spacing" LINK "gg:doc/NDK/Guide/Include/gadgets/clicktab.h/File" 33}                 @{"TNA_Text" LINK "gg:doc/NDK/Guide/Include/gadgets/clicktab.h/File" 42}              @{"TNA_TextPen" LINK "gg:doc/NDK/Guide/Include/gadgets/clicktab.h/File" 48}
@{"TNA_UserData" LINK "gg:doc/NDK/Guide/Include/gadgets/clicktab.h/File" 29}                

@ENDNODE
@NODE File "gadgets/clicktab.h"
#ifndef GADGETS_CLICKTAB_H
#define GADGETS_CLICKTAB_H
/*
**      $VER: clicktab.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      Definitions for the clicktab.gadget BOOPSI class
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

/* Defines for the clicktab node attributes.
 */
#define TNA_Dummy               (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48}+0x010000)

#define TNA_UserData    (@{"TNA_Dummy" LINK File 27}+1)
        /* (@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}) user data, have a blast. */

#define TNA_Enabled             (@{"TNA_Dummy" LINK File 27}+2)   /* was never implemented, now obsolete! */
#define TNA_Spacing             (@{"TNA_Dummy" LINK File 27}+3)   /* obsolete! */
#define TNA_Highlight   (@{"TNA_Dummy" LINK File 27}+4)   /* obsolete! */

#define TNA_Image               (@{"TNA_Dummy" LINK File 27}+5)
        /* (strcut Image *) render image pointer. */

#define TNA_SelImage    (@{"TNA_Dummy" LINK File 27}+6)
        /* (@{"struct Image" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 705} *) select image pointer. */

#define TNA_Text                (@{"TNA_Dummy" LINK File 27}+7)
        /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) tab text label string pointer. */

#define TNA_Number              (@{"TNA_Dummy" LINK File 27}+8)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) numeric ID assignment for tab. */

#define TNA_TextPen             (@{"TNA_Dummy" LINK File 27}+9)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Text pen ID to render tab text. */

#define TNA_Disabled            (@{"TNA_Dummy" LINK File 27}+10)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Is this button disabled?. (V42) */

/*****************************************************************************/

/* Additional attributes defined by the clicktab.gadget class
 */
#define CLICKTAB_Dummy                          (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26} + 0x27000)

#define CLICKTAB_Labels                         (@{"CLICKTAB_Dummy" LINK File 58}+1)
        /* (@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *) button list */

#define CLICKTAB_Current                        (@{"CLICKTAB_Dummy" LINK File 58}+2)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Currently selected tab id# */

#define CLICKTAB_CurrentNode            (@{"CLICKTAB_Dummy" LINK File 58}+3)
        /* (struct TabNode *) Currently selected tab node */

#define CLICKTAB_Orientation            (@{"CLICKTAB_Dummy" LINK File 58}+4)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Horizontal/Vertical/Flip mode - **Not Implemented!** */

#define CLICKTAB_PageGroup                      (@{"CLICKTAB_Dummy" LINK File 58}+5)
        /* (Object *) Embedded @{"PageObject" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_macros.h/File" 76} child pointer. (V42) */

#define CLICKTAB_PageGroupBackFill      (@{"CLICKTAB_Dummy" LINK File 58}+6)
        /* (Object *) Embedded @{"PageObject" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_macros.h/File" 76} + selected ClickTab backfill pointer. (V42) */

/*****************************************************************************/

/* @{"CLICKTAB_Orientation" LINK File 69} Modes
 */
#define CTORIENT_HORIZ          0
#define CTORIENT_VERT           1
#define CTORIENT_HORIZFLIP      2
#define CTORIENT_VERTFLIP       3

#endif /* GADGETS_CLICKTAB_H */
@ENDNODE
