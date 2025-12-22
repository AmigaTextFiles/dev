@DATABASE "gg:doc/NDK/Guide/Include/inline/drawlist.h"
@MASTER   "gg:os-include/inline/drawlist.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:47
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/drawlist.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/drawlist.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_DRAWLIST_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/drawlist.h/File" 5}  @{"DRAWLIST_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/drawlist.h/File" 20}  @{"DRAWLIST_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/drawlist.h/File" 23}

@ENDNODE
@NODE File "inline/drawlist.h"
#ifndef _INLINE_DRAWLIST_H
#define _INLINE_DRAWLIST_H

#ifndef CLIB_DRAWLIST_PROTOS_H
#define CLIB_DRAWLIST_PROTOS_H
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

#ifndef DRAWLIST_BASE_NAME
#define DRAWLIST_BASE_NAME DrawListBase
#endif

#define @{"DRAWLIST_GetClass()" LINK "gg:doc/NDK/Guide/drawlist_ic/DRAWLIST_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"DRAWLIST_GetClass" LINK File 23}, \\
        , @{"DRAWLIST_BASE_NAME" LINK File 20})

#endif /*  _INLINE_DRAWLIST_H  */
@ENDNODE
