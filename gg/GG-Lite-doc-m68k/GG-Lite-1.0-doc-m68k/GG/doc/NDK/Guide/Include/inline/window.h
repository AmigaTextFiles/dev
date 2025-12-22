@DATABASE "gg:doc/NDK/Guide/Include/inline/window.h"
@MASTER   "gg:os-include/inline/window.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:50
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/window.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/window.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_WINDOW_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/window.h/File" 5}  @{"WINDOW_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/window.h/File" 20}  @{"WINDOW_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/window.h/File" 23}

@ENDNODE
@NODE File "inline/window.h"
#ifndef _INLINE_WINDOW_H
#define _INLINE_WINDOW_H

#ifndef CLIB_WINDOW_PROTOS_H
#define CLIB_WINDOW_PROTOS_H
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

#ifndef WINDOW_BASE_NAME
#define WINDOW_BASE_NAME WindowBase
#endif

#define @{"WINDOW_GetClass()" LINK "gg:doc/NDK/Guide/window_cl/WINDOW_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"WINDOW_GetClass" LINK File 23}, \\
        , @{"WINDOW_BASE_NAME" LINK File 20})

#endif /*  _INLINE_WINDOW_H  */
@ENDNODE
