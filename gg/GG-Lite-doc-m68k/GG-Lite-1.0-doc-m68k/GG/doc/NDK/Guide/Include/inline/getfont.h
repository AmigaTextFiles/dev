@DATABASE "gg:doc/NDK/Guide/Include/inline/getfont.h"
@MASTER   "gg:os-include/inline/getfont.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:53
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/getfont.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/getfont.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_GETFONT_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/getfont.h/File" 5}  @{"GETFONT_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/getfont.h/File" 20}  @{"GETFONT_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/getfont.h/File" 23}

@ENDNODE
@NODE File "inline/getfont.h"
#ifndef _INLINE_GETFONT_H
#define _INLINE_GETFONT_H

#ifndef CLIB_GETFONT_PROTOS_H
#define CLIB_GETFONT_PROTOS_H
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

#ifndef GETFONT_BASE_NAME
#define GETFONT_BASE_NAME GetFontBase
#endif

#define @{"GETFONT_GetClass()" LINK "gg:doc/NDK/Guide/getfont_gc/GETFONT_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"GETFONT_GetClass" LINK File 23}, \\
        , @{"GETFONT_BASE_NAME" LINK File 20})

#endif /*  _INLINE_GETFONT_H  */
@ENDNODE
