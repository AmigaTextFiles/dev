@DATABASE "gg:doc/NDK/Guide/Include/inline/fuelgauge.h"
@MASTER   "gg:os-include/inline/fuelgauge.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:51
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/fuelgauge.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/fuelgauge.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_FUELGAUGE_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/fuelgauge.h/File" 5}  @{"FUELGAUGE_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/fuelgauge.h/File" 20}  @{"FUELGAUGE_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/fuelgauge.h/File" 23}

@ENDNODE
@NODE File "inline/fuelgauge.h"
#ifndef _INLINE_FUELGAUGE_H
#define _INLINE_FUELGAUGE_H

#ifndef CLIB_FUELGAUGE_PROTOS_H
#define CLIB_FUELGAUGE_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif
#ifndef  INTUITION_CLASSES_H
#include <@{"intuition/classes.h" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File"}>
#endif

#ifndef FUELGAUGE_BASE_NAME
#define FUELGAUGE_BASE_NAME FuelGaugeBase
#endif

#define @{"FUELGAUGE_GetClass()" LINK "gg:doc/NDK/Guide/fuelgauge_gc/FUELGAUGE_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"FUELGAUGE_GetClass" LINK File 23}, \\
        , @{"FUELGAUGE_BASE_NAME" LINK File 20})

#endif /*  _INLINE_FUELGAUGE_H  */
@ENDNODE
