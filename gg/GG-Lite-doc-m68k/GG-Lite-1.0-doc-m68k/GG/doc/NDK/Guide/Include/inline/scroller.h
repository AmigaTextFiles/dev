@DATABASE "gg:doc/NDK/Guide/Include/inline/scroller.h"
@MASTER   "gg:os-include/inline/scroller.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:43
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/scroller.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/scroller.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_SCROLLER_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/scroller.h/File" 5}  @{"SCROLLER_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/scroller.h/File" 20}  @{"SCROLLER_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/scroller.h/File" 23}

@ENDNODE
@NODE File "inline/scroller.h"
#ifndef _INLINE_SCROLLER_H
#define _INLINE_SCROLLER_H

#ifndef CLIB_SCROLLER_PROTOS_H
#define CLIB_SCROLLER_PROTOS_H
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

#ifndef SCROLLER_BASE_NAME
#define SCROLLER_BASE_NAME ScrollerBase
#endif

#define @{"SCROLLER_GetClass()" LINK "gg:doc/NDK/Guide/scroller_gc/SCROLLER_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"SCROLLER_GetClass" LINK File 23}, \\
        , @{"SCROLLER_BASE_NAME" LINK File 20})

#endif /*  _INLINE_SCROLLER_H  */
@ENDNODE
