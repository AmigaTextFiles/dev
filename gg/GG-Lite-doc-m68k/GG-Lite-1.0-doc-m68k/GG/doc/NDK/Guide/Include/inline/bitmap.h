@DATABASE "gg:doc/NDK/Guide/Include/inline/bitmap.h"
@MASTER   "gg:os-include/inline/bitmap.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:31
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/bitmap.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/bitmap.h" LINK File}


@{b}#defines@{ub}

@{"BITMAP_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/bitmap.h/File" 20}  @{"BITMAP_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/bitmap.h/File" 23}  @{"CLIB_BITMAP_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/bitmap.h/File" 5}

@ENDNODE
@NODE File "inline/bitmap.h"
#ifndef _INLINE_BITMAP_H
#define _INLINE_BITMAP_H

#ifndef CLIB_BITMAP_PROTOS_H
#define CLIB_BITMAP_PROTOS_H
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

#ifndef BITMAP_BASE_NAME
#define BITMAP_BASE_NAME BitMapBase
#endif

#define @{"BITMAP_GetClass()" LINK "gg:doc/NDK/Guide/bitmap_ic/BITMAP_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"BITMAP_GetClass" LINK File 23}, \\
        , @{"BITMAP_BASE_NAME" LINK File 20})

#endif /*  _INLINE_BITMAP_H  */
@ENDNODE
