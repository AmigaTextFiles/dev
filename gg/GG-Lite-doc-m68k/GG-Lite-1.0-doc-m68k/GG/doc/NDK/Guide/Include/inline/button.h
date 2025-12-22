@DATABASE "gg:doc/NDK/Guide/Include/inline/button.h"
@MASTER   "gg:os-include/inline/button.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:32
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/button.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/button.h" LINK File}


@{b}#defines@{ub}

@{"BUTTON_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/button.h/File" 20}  @{"BUTTON_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/button.h/File" 23}  @{"CLIB_BUTTON_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/button.h/File" 5}

@ENDNODE
@NODE File "inline/button.h"
#ifndef _INLINE_BUTTON_H
#define _INLINE_BUTTON_H

#ifndef CLIB_BUTTON_PROTOS_H
#define CLIB_BUTTON_PROTOS_H
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

#ifndef BUTTON_BASE_NAME
#define BUTTON_BASE_NAME ButtonBase
#endif

#define @{"BUTTON_GetClass()" LINK "gg:doc/NDK/Guide/button_gc/BUTTON_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"BUTTON_GetClass" LINK File 23}, \\
        , @{"BUTTON_BASE_NAME" LINK File 20})

#endif /*  _INLINE_BUTTON_H  */
@ENDNODE
