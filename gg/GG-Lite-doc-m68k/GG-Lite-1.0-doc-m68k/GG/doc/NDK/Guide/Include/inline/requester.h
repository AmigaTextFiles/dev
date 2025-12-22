@DATABASE "gg:doc/NDK/Guide/Include/inline/requester.h"
@MASTER   "gg:os-include/inline/requester.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:40
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/requester.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/requester.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_REQUESTER_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/requester.h/File" 5}  @{"REQUESTER_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/requester.h/File" 20}  @{"REQUESTER_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/requester.h/File" 23}

@ENDNODE
@NODE File "inline/requester.h"
#ifndef _INLINE_REQUESTER_H
#define _INLINE_REQUESTER_H

#ifndef CLIB_REQUESTER_PROTOS_H
#define CLIB_REQUESTER_PROTOS_H
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

#ifndef REQUESTER_BASE_NAME
#define REQUESTER_BASE_NAME RequesterBase
#endif

#define REQUESTER_GetClass() \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"REQUESTER_GetClass" LINK File 23}, \\
        , @{"REQUESTER_BASE_NAME" LINK File 20})

#endif /*  _INLINE_REQUESTER_H  */
@ENDNODE
