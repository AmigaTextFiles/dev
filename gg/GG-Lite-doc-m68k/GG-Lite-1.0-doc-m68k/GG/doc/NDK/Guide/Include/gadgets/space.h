@DATABASE "gg:doc/NDK/Guide/Include/gadgets/space.h"
@MASTER   "gg:os-include/gadgets/space.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:43
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "gadgets/space.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"gadgets/space.h" LINK File}


@{b}#defines@{ub}

@{"SPACE_AreaBox" LINK "gg:doc/NDK/Guide/Include/gadgets/space.h/File" 50}      @{"SPACE_BevelStyle" LINK "gg:doc/NDK/Guide/Include/gadgets/space.h/File" 59}  @{"SPACE_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/space.h/File" 28}   @{"SPACE_MinHeight" LINK "gg:doc/NDK/Guide/Include/gadgets/space.h/File" 30}
@{"SPACE_MinWidth" LINK "gg:doc/NDK/Guide/Include/gadgets/space.h/File" 34}     @{"SPACE_MouseX" LINK "gg:doc/NDK/Guide/Include/gadgets/space.h/File" 38}      @{"SPACE_MouseY" LINK "gg:doc/NDK/Guide/Include/gadgets/space.h/File" 42}  @{"SPACE_RenderHook" LINK "gg:doc/NDK/Guide/Include/gadgets/space.h/File" 54}
@{"SPACE_Transparent" LINK "gg:doc/NDK/Guide/Include/gadgets/space.h/File" 46}  

@ENDNODE
@NODE File "gadgets/space.h"
#ifndef GADGETS_SPACE_H
#define GADGETS_SPACE_H
/*
**      $VER: space.h 45.1 (07.03.2001)
**      Includes Release 45.1
**
**      Definitions for the space.gadget BOOPSI class
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

/* Additional attributes defined by the space.gadget class
 */

#define SPACE_Dummy                     (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26} + 0x9000)

#define SPACE_MinHeight         (@{"SPACE_Dummy" LINK File 28}+1)
    /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Height of space gadget
     * (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63},@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65},@{"OM_UPDATE" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 70},@{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}) */

#define SPACE_MinWidth          (@{"SPACE_Dummy" LINK File 28}+2)
    /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Width of space gadget
     * (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63},@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65},@{"OM_UPDATE" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 70},@{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}) */

#define SPACE_MouseX            (@{"SPACE_Dummy" LINK File 28}+3)
    /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) X Position of Mouse within space gadget
     * (@{"OM_NOTIFY" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 69}) */

#define SPACE_MouseY            (@{"SPACE_Dummy" LINK File 28}+4)
    /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Y Position of Mouse within space gadget
     * (@{"OM_NOTIFY" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 69}) */

#define SPACE_Transparent       (@{"SPACE_Dummy" LINK File 28}+5)
    /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Will not @{"EraseRect()" LINK "gg:doc/NDK/Guide/graphics/EraseRect"} background before redraw if true.
     * (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63},@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65},@{"OM_UPDATE" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 70}) */

#define SPACE_AreaBox           (@{"SPACE_Dummy" LINK File 28}+6)
    /* (@{"struct IBox" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 896} *) Inner area IBox application rendering bounds
     * (@{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}) */

#define SPACE_RenderHook        (@{"SPACE_Dummy" LINK File 28}+7)
    /* (@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *) render hook is called when the gadget refreshes.
     * a0: @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *, a2: Object *, a1: @{"struct gpRender" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 377} *
     * (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63},@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65},@{"OM_UPDATE" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 70}) */

#define SPACE_BevelStyle        (@{"SPACE_Dummy" LINK File 28}+8)
    /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Defaults to @{"BVS_NONE" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File" 90} (no bevel - see @{"images/bevel.h" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File"})
     * !!! broken before 45.1 !!!
     * (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63},@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65},@{"OM_UPDATE" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 70}) */

/*****************************************************************************/

#endif /* GADGETS_SPACE_H */
@ENDNODE
