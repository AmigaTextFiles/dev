@DATABASE "gg:doc/NDK/Guide/Include/inline/string.h"
@MASTER   "gg:os-include/inline/string.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:44
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/string.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/string.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_STRING_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/string.h/File" 5}  @{"STRING_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/string.h/File" 20}  @{"STRING_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/string.h/File" 23}

@ENDNODE
@NODE File "inline/string.h"
#ifndef _INLINE_STRING_H
#define _INLINE_STRING_H

#ifndef CLIB_STRING_PROTOS_H
#define CLIB_STRING_PROTOS_H
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

#ifndef STRING_BASE_NAME
#define STRING_BASE_NAME StringBase
#endif

#define @{"STRING_GetClass()" LINK "gg:doc/NDK/Guide/string_gc/STRING_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"STRING_GetClass" LINK File 23}, \\
        , @{"STRING_BASE_NAME" LINK File 20})

#endif /*  _INLINE_STRING_H  */
@ENDNODE
