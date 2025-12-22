@DATABASE "gg:doc/NDK/Guide/Include/inline/integer.h"
@MASTER   "gg:os-include/inline/integer.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:04
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/integer.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/integer.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_INTEGER_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/integer.h/File" 5}  @{"INTEGER_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/integer.h/File" 20}  @{"INTEGER_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/integer.h/File" 23}

@ENDNODE
@NODE File "inline/integer.h"
#ifndef _INLINE_INTEGER_H
#define _INLINE_INTEGER_H

#ifndef CLIB_INTEGER_PROTOS_H
#define CLIB_INTEGER_PROTOS_H
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

#ifndef INTEGER_BASE_NAME
#define INTEGER_BASE_NAME IntegerBase
#endif

#define @{"INTEGER_GetClass()" LINK "gg:doc/NDK/Guide/integer_gc/INTEGER_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"INTEGER_GetClass" LINK File 23}, \\
        , @{"INTEGER_BASE_NAME" LINK File 20})

#endif /*  _INLINE_INTEGER_H  */
@ENDNODE
