@DATABASE "gg:doc/NDK/Guide/Include/gadgets/scroller.h"
@MASTER   "gg:os-include/gadgets/scroller.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:41
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "gadgets/scroller.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"gadgets/scroller.h" LINK File}


@{b}#defines@{ub}

@{"SCROLLER_ArrowDelta" LINK "gg:doc/NDK/Guide/Include/gadgets/scroller.h/File" 48}     @{"SCROLLER_Arrows" LINK "gg:doc/NDK/Guide/Include/gadgets/scroller.h/File" 42}       @{"SCROLLER_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/scroller.h/File" 28}
@{"SCROLLER_HORIZONTAL" LINK "gg:doc/NDK/Guide/Include/gadgets/scroller.h/File" 65}     @{"SCROLLER_Orientation" LINK "gg:doc/NDK/Guide/Include/gadgets/scroller.h/File" 39}  @{"SCROLLER_SignalTask" LINK "gg:doc/NDK/Guide/Include/gadgets/scroller.h/File" 51}
@{"SCROLLER_SignalTaskBit" LINK "gg:doc/NDK/Guide/Include/gadgets/scroller.h/File" 54}  @{"SCROLLER_Stretch" LINK "gg:doc/NDK/Guide/Include/gadgets/scroller.h/File" 45}      @{"SCROLLER_Top" LINK "gg:doc/NDK/Guide/Include/gadgets/scroller.h/File" 30}
@{"SCROLLER_Total" LINK "gg:doc/NDK/Guide/Include/gadgets/scroller.h/File" 36}          @{"SCROLLER_VERTICAL" LINK "gg:doc/NDK/Guide/Include/gadgets/scroller.h/File" 66}     @{"SCROLLER_Visible" LINK "gg:doc/NDK/Guide/Include/gadgets/scroller.h/File" 33}
@{"SORIENT_HORIZ" LINK "gg:doc/NDK/Guide/Include/gadgets/scroller.h/File" 62}           @{"SORIENT_VERT" LINK "gg:doc/NDK/Guide/Include/gadgets/scroller.h/File" 63}          

@ENDNODE
@NODE File "gadgets/scroller.h"
#ifndef GADGETS_SCROLLER_H
#define GADGETS_SCROLLER_H
/*
**      $VER: scroller.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      Definitions for the scroller.gadget BOOPSI class
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

/* Additional attributes defined by the scroller.gadget class
 */

#define SCROLLER_Dummy                  (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26}+0x0005000)

#define SCROLLER_Top                    (@{"SCROLLER_Dummy" LINK File 28}+1L)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) scroller Top value (Defaults to 0). */

#define SCROLLER_Visible                (@{"SCROLLER_Dummy" LINK File 28}+2L)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) visible part of total. */

#define SCROLLER_Total                  (@{"SCROLLER_Dummy" LINK File 28}+3L)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) total scroller size. */

#define SCROLLER_Orientation    (@{"SCROLLER_Dummy" LINK File 28}+4L)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Vertical or Horizontal mode. */

#define SCROLLER_Arrows                 (@{"SCROLLER_Dummy" LINK File 28}+5L)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Render arrows. */

#define SCROLLER_Stretch                (@{"SCROLLER_Dummy" LINK File 28}+6L)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) AutoExpand/Stretch Total. */

#define SCROLLER_ArrowDelta             (@{"SCROLLER_Dummy" LINK File 28}+7L)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Change arrow click makes. */

#define SCROLLER_SignalTask             (@{"SCROLLER_Dummy" LINK File 28}+10L)
        /* (@{"struct Task" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 24} *) Signal this Task while scroller is active */

#define SCROLLER_SignalTaskBit  (@{"SCROLLER_Dummy" LINK File 28}+11L)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Signal with this Bit. */

/*****************************************************************************/

/* @{"SCROLLER_Orientation" LINK File 39} Modes
 */

#define @{"SORIENT_HORIZ" LINK "gg:doc/NDK/Guide/Include/gadgets/slider.h/File" 83}   @{"FREEHORIZ" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 590}
#define @{"SORIENT_VERT" LINK "gg:doc/NDK/Guide/Include/gadgets/slider.h/File" 84}    @{"FREEVERT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 591}

#define SCROLLER_HORIZONTAL     @{"SORIENT_HORIZ" LINK File 62}
#define SCROLLER_VERTICAL       @{"SORIENT_VERT" LINK File 63}

#endif /* GADGETS_SCROLLER_H */
@ENDNODE
