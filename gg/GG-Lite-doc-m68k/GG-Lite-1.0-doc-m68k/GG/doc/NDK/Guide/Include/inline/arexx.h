@DATABASE "gg:doc/NDK/Guide/Include/inline/arexx.h"
@MASTER   "gg:os-include/inline/arexx.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:28
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/arexx.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/arexx.h" LINK File}


@{b}#defines@{ub}

@{"AREXX_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/arexx.h/File" 20}  @{"AREXX_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/arexx.h/File" 23}  @{"CLIB_AREXX_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/arexx.h/File" 5}

@ENDNODE
@NODE File "inline/arexx.h"
#ifndef _INLINE_AREXX_H
#define _INLINE_AREXX_H

#ifndef CLIB_AREXX_PROTOS_H
#define CLIB_AREXX_PROTOS_H
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

#ifndef AREXX_BASE_NAME
#define AREXX_BASE_NAME ARexxBase
#endif

#define AREXX_GetClass() \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"AREXX_GetClass" LINK File 23}, \\
        , @{"AREXX_BASE_NAME" LINK File 20})

#endif /*  _INLINE_AREXX_H  */
@ENDNODE
