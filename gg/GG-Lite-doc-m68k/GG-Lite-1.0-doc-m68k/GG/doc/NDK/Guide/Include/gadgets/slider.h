@DATABASE "gg:doc/NDK/Guide/Include/gadgets/slider.h"
@MASTER   "gg:os-include/gadgets/slider.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:42
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "gadgets/slider.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"gadgets/slider.h" LINK File}


@{b}#defines@{ub}

@{"SLIDER_BodyFill" LINK "gg:doc/NDK/Guide/Include/gadgets/slider.h/File" 59}     @{"SLIDER_BodyImage" LINK "gg:doc/NDK/Guide/Include/gadgets/slider.h/File" 62}  @{"SLIDER_DispHook" LINK "gg:doc/NDK/Guide/Include/gadgets/slider.h/File" 42}
@{"SLIDER_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/slider.h/File" 28}        @{"SLIDER_Gradient" LINK "gg:doc/NDK/Guide/Include/gadgets/slider.h/File" 65}   @{"SLIDER_HORIZONTAL" LINK "gg:doc/NDK/Guide/Include/gadgets/slider.h/File" 86}
@{"SLIDER_Invert" LINK "gg:doc/NDK/Guide/Include/gadgets/slider.h/File" 71}       @{"SLIDER_KnobDelta" LINK "gg:doc/NDK/Guide/Include/gadgets/slider.h/File" 74}  @{"SLIDER_KnobImage" LINK "gg:doc/NDK/Guide/Include/gadgets/slider.h/File" 56}
@{"SLIDER_Level" LINK "gg:doc/NDK/Guide/Include/gadgets/slider.h/File" 36}        @{"SLIDER_Max" LINK "gg:doc/NDK/Guide/Include/gadgets/slider.h/File" 33}        @{"SLIDER_Min" LINK "gg:doc/NDK/Guide/Include/gadgets/slider.h/File" 30}
@{"SLIDER_Orientation" LINK "gg:doc/NDK/Guide/Include/gadgets/slider.h/File" 39}  @{"SLIDER_PenArray" LINK "gg:doc/NDK/Guide/Include/gadgets/slider.h/File" 68}   @{"SLIDER_ShortTicks" LINK "gg:doc/NDK/Guide/Include/gadgets/slider.h/File" 50}
@{"SLIDER_Ticks" LINK "gg:doc/NDK/Guide/Include/gadgets/slider.h/File" 47}        @{"SLIDER_TickSize" LINK "gg:doc/NDK/Guide/Include/gadgets/slider.h/File" 53}   @{"SLIDER_VERTICAL" LINK "gg:doc/NDK/Guide/Include/gadgets/slider.h/File" 87}
@{"SORIENT_HORIZ" LINK "gg:doc/NDK/Guide/Include/gadgets/slider.h/File" 83}       @{"SORIENT_VERT" LINK "gg:doc/NDK/Guide/Include/gadgets/slider.h/File" 84}      

@ENDNODE
@NODE File "gadgets/slider.h"
#ifndef GADGETS_SLIDER_H
#define GADGETS_SLIDER_H
/*
**      $VER: slider.h 45.1 (28.08.2001)
**      Includes Release 45.1
**
**      Definitions for the slider.gadget BOOPSI class
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

/* Additional attributes defined by the slider.gadget class
 */

#define SLIDER_Dummy                    (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26}+0x0028000)

#define SLIDER_Min                              (@{"SLIDER_Dummy" LINK File 28}+1L)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) . */

#define SLIDER_Max                              (@{"SLIDER_Dummy" LINK File 28}+2L)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) . */

#define SLIDER_Level                    (@{"SLIDER_Dummy" LINK File 28}+3L)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) . */

#define SLIDER_Orientation              (@{"SLIDER_Dummy" LINK File 28}+4L)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) . */

#define SLIDER_DispHook                 (@{"SLIDER_Dummy" LINK File 28}+5L)
        /* (@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *) A0 Hook, A2 Object, A1 TagList
         * containing @{"SLIDER_Level" LINK File 36}, SLIDER_ Min, @{"SLIDER_Max" LINK File 33},
         * @{"GA_ID" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 87}, @{"GA_UserInput" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 209}. */

#define SLIDER_Ticks                    (@{"SLIDER_Dummy" LINK File 28}+6L)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) . */

#define SLIDER_ShortTicks               (@{"SLIDER_Dummy" LINK File 28}+7L)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) . */

#define SLIDER_TickSize                 (@{"SLIDER_Dummy" LINK File 28}+8L)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) . */

#define SLIDER_KnobImage                (@{"SLIDER_Dummy" LINK File 28}+9L)
        /* (@{"struct Image" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 705} *) . */

#define SLIDER_BodyFill                 (@{"SLIDER_Dummy" LINK File 28}+10L)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) . */

#define SLIDER_BodyImage                (@{"SLIDER_Dummy" LINK File 28}+11L)
        /* (@{"struct Image" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 705} *) . */

#define SLIDER_Gradient                 (@{"SLIDER_Dummy" LINK File 28}+12L)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Gradient slider modem, defaults to false. */

#define SLIDER_PenArray                 (@{"SLIDER_Dummy" LINK File 28}+13L)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} *) Pens for gradient slider. */

#define SLIDER_Invert                   (@{"SLIDER_Dummy" LINK File 28}+14L)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Flip Min/Max positions. Defaults to false. */

#define SLIDER_KnobDelta                (@{"SLIDER_Dummy" LINK File 28}+15L)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) . */


/*****************************************************************************/

/* @{"SLIDER_Orientation" LINK File 39} Modes
 */

#define @{"SORIENT_HORIZ" LINK "gg:doc/NDK/Guide/Include/gadgets/scroller.h/File" 62} @{"FREEHORIZ" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 590}
#define @{"SORIENT_VERT" LINK "gg:doc/NDK/Guide/Include/gadgets/scroller.h/File" 63} @{"FREEVERT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 591}

#define SLIDER_HORIZONTAL @{"SORIENT_HORIZ" LINK File 83}
#define SLIDER_VERTICAL @{"SORIENT_VERT" LINK File 84}

#endif /* GADGETS_SLIDER_H */
@ENDNODE
