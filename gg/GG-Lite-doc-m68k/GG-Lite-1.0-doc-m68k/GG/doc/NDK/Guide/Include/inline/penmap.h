@DATABASE "gg:doc/NDK/Guide/Include/inline/penmap.h"
@MASTER   "gg:os-include/inline/penmap.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:34
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/penmap.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/penmap.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_PENMAP_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/penmap.h/File" 5}  @{"PENMAP_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/penmap.h/File" 20}  @{"PENMAP_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/penmap.h/File" 23}

@ENDNODE
@NODE File "inline/penmap.h"
#ifndef _INLINE_PENMAP_H
#define _INLINE_PENMAP_H

#ifndef CLIB_PENMAP_PROTOS_H
#define CLIB_PENMAP_PROTOS_H
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

#ifndef PENMAP_BASE_NAME
#define PENMAP_BASE_NAME PenMapBase
#endif

#define @{"PENMAP_GetClass()" LINK "gg:doc/NDK/Guide/penmap_ic/PENMAP_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"PENMAP_GetClass" LINK File 23}, \\
        , @{"PENMAP_BASE_NAME" LINK File 20})

#endif /*  _INLINE_PENMAP_H  */
@ENDNODE
