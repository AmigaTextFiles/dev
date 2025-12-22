@DATABASE "gg:doc/NDK/Guide/Include/inline/space.h"
@MASTER   "gg:os-include/inline/space.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:43
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/space.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/space.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_SPACE_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/space.h/File" 5}  @{"SPACE_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/space.h/File" 20}  @{"SPACE_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/space.h/File" 23}

@ENDNODE
@NODE File "inline/space.h"
#ifndef _INLINE_SPACE_H
#define _INLINE_SPACE_H

#ifndef CLIB_SPACE_PROTOS_H
#define CLIB_SPACE_PROTOS_H
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

#ifndef SPACE_BASE_NAME
#define SPACE_BASE_NAME SpaceBase
#endif

#define @{"SPACE_GetClass()" LINK "gg:doc/NDK/Guide/space_gc/SPACE_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"SPACE_GetClass" LINK File 23}, \\
        , @{"SPACE_BASE_NAME" LINK File 20})

#endif /*  _INLINE_SPACE_H  */
@ENDNODE
