@DATABASE "gg:doc/NDK/Guide/Include/inline/getscreenmode.h"
@MASTER   "gg:os-include/inline/getscreenmode.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:53
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/getscreenmode.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/getscreenmode.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_GETSCREENMODE_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/getscreenmode.h/File" 5}  @{"GETSCREENMODE_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/getscreenmode.h/File" 20}
@{"GETSCREENMODE_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/getscreenmode.h/File" 23}     

@ENDNODE
@NODE File "inline/getscreenmode.h"
#ifndef _INLINE_GETSCREENMODE_H
#define _INLINE_GETSCREENMODE_H

#ifndef CLIB_GETSCREENMODE_PROTOS_H
#define CLIB_GETSCREENMODE_PROTOS_H
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

#ifndef GETSCREENMODE_BASE_NAME
#define GETSCREENMODE_BASE_NAME GetScreenModeBase
#endif

#define @{"GETSCREENMODE_GetClass()" LINK "gg:doc/NDK/Guide/getscreenmode_gc/GETSCREENMODE_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"GETSCREENMODE_GetClass" LINK File 23}, \\
        , @{"GETSCREENMODE_BASE_NAME" LINK File 20})

#endif /*  _INLINE_GETSCREENMODE_H  */
@ENDNODE
