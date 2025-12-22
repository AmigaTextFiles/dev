@DATABASE "gg:doc/NDK/Guide/Include/inline/bevel.h"
@MASTER   "gg:os-include/inline/bevel.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:30
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/bevel.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/bevel.h" LINK File}


@{b}#defines@{ub}

@{"BEVEL_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/bevel.h/File" 20}  @{"BEVEL_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/bevel.h/File" 23}  @{"CLIB_BEVEL_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/bevel.h/File" 5}

@ENDNODE
@NODE File "inline/bevel.h"
#ifndef _INLINE_BEVEL_H
#define _INLINE_BEVEL_H

#ifndef CLIB_BEVEL_PROTOS_H
#define CLIB_BEVEL_PROTOS_H
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

#ifndef BEVEL_BASE_NAME
#define BEVEL_BASE_NAME BevelBase
#endif

#define @{"BEVEL_GetClass()" LINK "gg:doc/NDK/Guide/bevel_ic/BEVEL_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"BEVEL_GetClass" LINK File 23}, \\
        , @{"BEVEL_BASE_NAME" LINK File 20})

#endif /*  _INLINE_BEVEL_H  */
@ENDNODE
