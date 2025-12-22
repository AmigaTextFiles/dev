@DATABASE "gg:doc/NDK/Guide/Include/gadgets/fuelgauge.h"
@MASTER   "gg:os-include/gadgets/fuelgauge.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:26
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "gadgets/fuelgauge.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"gadgets/fuelgauge.h" LINK File}


@{b}#defines@{ub}

@{"FGJ_CENTER" LINK "gg:doc/NDK/Guide/Include/gadgets/fuelgauge.h/File" 79}               @{"FGJ_CENTRE" LINK "gg:doc/NDK/Guide/Include/gadgets/fuelgauge.h/File" 80}             @{"FGJ_LEFT" LINK "gg:doc/NDK/Guide/Include/gadgets/fuelgauge.h/File" 78}
@{"FGORIENT_HORIZ" LINK "gg:doc/NDK/Guide/Include/gadgets/fuelgauge.h/File" 73}           @{"FGORIENT_VERT" LINK "gg:doc/NDK/Guide/Include/gadgets/fuelgauge.h/File" 74}          @{"FUELGAUGE_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/fuelgauge.h/File" 25}
@{"FUELGAUGE_EmptyPen" LINK "gg:doc/NDK/Guide/Include/gadgets/fuelgauge.h/File" 60}       @{"FUELGAUGE_FillPen" LINK "gg:doc/NDK/Guide/Include/gadgets/fuelgauge.h/File" 57}      @{"FUELGAUGE_HORIZONTAL" LINK "gg:doc/NDK/Guide/Include/gadgets/fuelgauge.h/File" 84}
@{"FUELGAUGE_Justification" LINK "gg:doc/NDK/Guide/Include/gadgets/fuelgauge.h/File" 66}  @{"FUELGAUGE_Level" LINK "gg:doc/NDK/Guide/Include/gadgets/fuelgauge.h/File" 33}        @{"FUELGAUGE_Max" LINK "gg:doc/NDK/Guide/Include/gadgets/fuelgauge.h/File" 30}
@{"FUELGAUGE_Min" LINK "gg:doc/NDK/Guide/Include/gadgets/fuelgauge.h/File" 27}            @{"FUELGAUGE_Orientation" LINK "gg:doc/NDK/Guide/Include/gadgets/fuelgauge.h/File" 36}  @{"FUELGAUGE_Percent" LINK "gg:doc/NDK/Guide/Include/gadgets/fuelgauge.h/File" 39}
@{"FUELGAUGE_PercentPen" LINK "gg:doc/NDK/Guide/Include/gadgets/fuelgauge.h/File" 54}     @{"FUELGAUGE_ShortTicks" LINK "gg:doc/NDK/Guide/Include/gadgets/fuelgauge.h/File" 45}   @{"FUELGAUGE_TickPen" LINK "gg:doc/NDK/Guide/Include/gadgets/fuelgauge.h/File" 51}
@{"FUELGAUGE_Ticks" LINK "gg:doc/NDK/Guide/Include/gadgets/fuelgauge.h/File" 42}          @{"FUELGAUGE_TickSize" LINK "gg:doc/NDK/Guide/Include/gadgets/fuelgauge.h/File" 48}     @{"FUELGAUGE_VarArgs" LINK "gg:doc/NDK/Guide/Include/gadgets/fuelgauge.h/File" 63}
@{"FUELGAUGE_VERTICAL" LINK "gg:doc/NDK/Guide/Include/gadgets/fuelgauge.h/File" 85}       

@ENDNODE
@NODE File "gadgets/fuelgauge.h"
#ifndef GADGETS_FUELGAUGE_H
#define GADGETS_FUELGAUGE_H
/*
**      $VER: fuelgauge.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      Definitions for the fuelgauge.gadget BOOPSI class
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

#define FUELGAUGE_Dummy                 (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26} + 0x12000)

#define FUELGAUGE_Min                   (@{"FUELGAUGE_Dummy" LINK File 25} + 1)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) fuelgauge minimum value. */

#define FUELGAUGE_Max                   (@{"FUELGAUGE_Dummy" LINK File 25} + 2)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) fuelgauge maximum value. */

#define FUELGAUGE_Level                 (@{"FUELGAUGE_Dummy" LINK File 25} + 3)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) fuelgauge level (value between min and max). */

#define FUELGAUGE_Orientation   (@{"FUELGAUGE_Dummy" LINK File 25} + 4)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) orientation mode. */

#define FUELGAUGE_Percent               (@{"FUELGAUGE_Dummy" LINK File 25} + 5)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) render numeric percentage display. */

#define FUELGAUGE_Ticks                 (@{"FUELGAUGE_Dummy" LINK File 25} + 6)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) enable tick marks if number of ticks set is not 0. */

#define FUELGAUGE_ShortTicks    (@{"FUELGAUGE_Dummy" LINK File 25} + 7)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) enable small intermediate tick marks. */

#define FUELGAUGE_TickSize              (@{"FUELGAUGE_Dummy" LINK File 25} + 8)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) height of  large tick makrs. */

#define FUELGAUGE_TickPen               (@{"FUELGAUGE_Dummy" LINK File 25} + 9)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) tickmark pen. */

#define FUELGAUGE_PercentPen    (@{"FUELGAUGE_Dummy" LINK File 25} + 10)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) pen number to use for inner gauge percange rendering. */

#define FUELGAUGE_FillPen               (@{"FUELGAUGE_Dummy" LINK File 25} + 11)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) pen number to use for the fuelbar. */

#define FUELGAUGE_EmptyPen              (@{"FUELGAUGE_Dummy" LINK File 25} + 12)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) fuelgauge background/empty pen number. */

#define FUELGAUGE_VarArgs               (@{"FUELGAUGE_Dummy" LINK File 25} + 13)
        /* argument array for @{"GA_Text" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 62} varargs string */

#define FUELGAUGE_Justification (@{"FUELGAUGE_Dummy" LINK File 25} + 14)
        /* @{"GA_Text" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 62} justification mode */

/*****************************************************************************/

/* @{"FUELGAUGE_Orientation" LINK File 36} modes
 */
#define FGORIENT_HORIZ 0
#define FGORIENT_VERT 1

/* @{"FUELGAUGE_Justification" LINK File 66} modes
 */
#define FGJ_LEFT        0       // default
#define FGJ_CENTER      1
#define FGJ_CENTRE @{"FGJ_CENTER" LINK File 79}   // english/canadian spellings

/* Obsolete, DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE!
 */
#define FUELGAUGE_HORIZONTAL @{"FGORIENT_HORIZ" LINK File 73}
#define FUELGAUGE_VERTICAL @{"FGORIENT_VERT" LINK File 74}

#endif /* GADGETS_FUELGAUGE_H */
@ENDNODE
