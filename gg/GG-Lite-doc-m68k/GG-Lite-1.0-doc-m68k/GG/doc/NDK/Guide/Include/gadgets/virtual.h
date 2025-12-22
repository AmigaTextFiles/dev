@DATABASE "gg:doc/NDK/Guide/Include/gadgets/virtual.h"
@MASTER   "gg:os-include/gadgets/virtual.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:49
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "gadgets/virtual.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"gadgets/virtual.h" LINK File}


@{b}#defines@{ub}

@{"VIRTUALA_Base" LINK "gg:doc/NDK/Guide/Include/gadgets/virtual.h/File" 28}       @{"VIRTUALA_Contents" LINK "gg:doc/NDK/Guide/Include/gadgets/virtual.h/File" 30}  @{"VIRTUALA_InputScroll" LINK "gg:doc/NDK/Guide/Include/gadgets/virtual.h/File" 66}
@{"VIRTUALA_NoDispose" LINK "gg:doc/NDK/Guide/Include/gadgets/virtual.h/File" 69}  @{"VIRTUALA_Scroller" LINK "gg:doc/NDK/Guide/Include/gadgets/virtual.h/File" 33}  @{"VIRTUALA_ScrollerX" LINK "gg:doc/NDK/Guide/Include/gadgets/virtual.h/File" 60}
@{"VIRTUALA_ScrollerY" LINK "gg:doc/NDK/Guide/Include/gadgets/virtual.h/File" 63}  @{"VIRTUALA_ScrollX" LINK "gg:doc/NDK/Guide/Include/gadgets/virtual.h/File" 36}   @{"VIRTUALA_ScrollY" LINK "gg:doc/NDK/Guide/Include/gadgets/virtual.h/File" 39}
@{"VIRTUALA_TopX" LINK "gg:doc/NDK/Guide/Include/gadgets/virtual.h/File" 48}       @{"VIRTUALA_TopY" LINK "gg:doc/NDK/Guide/Include/gadgets/virtual.h/File" 51}      @{"VIRTUALA_TotalX" LINK "gg:doc/NDK/Guide/Include/gadgets/virtual.h/File" 54}
@{"VIRTUALA_TotalY" LINK "gg:doc/NDK/Guide/Include/gadgets/virtual.h/File" 57}     @{"VIRTUALA_VisibleX" LINK "gg:doc/NDK/Guide/Include/gadgets/virtual.h/File" 42}  @{"VIRTUALA_VisibleY" LINK "gg:doc/NDK/Guide/Include/gadgets/virtual.h/File" 45}

@ENDNODE
@NODE File "gadgets/virtual.h"
#ifndef GADGETS_VIRTUAL_H
#define GADGETS_VIRTUAL_H
/*
**      $VER: virtual.h 45.1 (07.10.2001)
**      Includes Release 45.1
**
**      Definitions for the virtual.gadget BOOPSI class
**
**      (C) Copyright 2001 Stephan Rupprecht
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

/* Additional attributes defined by the virtual.gadget class
 */

#define VIRTUALA_Base                   (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26} + 0x24500)

#define VIRTUALA_Contents               (@{"VIRTUALA_Base" LINK File 28} + 0)
        /* (Object *) [IS] */

#define VIRTUALA_Scroller               (@{"VIRTUALA_Base" LINK File 28} + 1)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) [IS] */

#define VIRTUALA_ScrollX                (@{"VIRTUALA_Base" LINK File 28} + 2)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) [ISU] */

#define VIRTUALA_ScrollY                (@{"VIRTUALA_Base" LINK File 28} + 3)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) [ISU] */

#define VIRTUALA_VisibleX               (@{"VIRTUALA_Base" LINK File 28} + 4)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) [GN] */

#define VIRTUALA_VisibleY               (@{"VIRTUALA_Base" LINK File 28} + 5)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) [GN] */

#define VIRTUALA_TopX                   (@{"VIRTUALA_Base" LINK File 28} + 6)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) [ISUGN] */

#define VIRTUALA_TopY                   (@{"VIRTUALA_Base" LINK File 28} + 7)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) [ISUGN] */

#define VIRTUALA_TotalX                 (@{"VIRTUALA_Base" LINK File 28} + 8)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) [GN] */

#define VIRTUALA_TotalY                 (@{"VIRTUALA_Base" LINK File 28} + 9)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) [GN] */

#define VIRTUALA_ScrollerX              (@{"VIRTUALA_Base" LINK File 28} + 10)
        /* (Object *) [I] */

#define VIRTUALA_ScrollerY              (@{"VIRTUALA_Base" LINK File 28} + 11)
        /* (Object *) [I] */

#define VIRTUALA_InputScroll    (@{"VIRTUALA_Base" LINK File 28} + 12)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) [IS] */

#define VIRTUALA_NoDispose              (@{"VIRTUALA_Base" LINK File 28} + 13)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) [IS] */

/*****************************************************************************/

#endif /* GADGETS_VIRTUAL_H */
@ENDNODE
