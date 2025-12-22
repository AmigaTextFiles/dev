@DATABASE "gg:doc/NDK/Guide/Include/inline/palette.h"
@MASTER   "gg:os-include/inline/palette.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:34
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/palette.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/palette.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_PALETTE_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/palette.h/File" 5}  @{"PALETTE_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/palette.h/File" 20}  @{"PALETTE_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/palette.h/File" 23}

@ENDNODE
@NODE File "inline/palette.h"
#ifndef _INLINE_PALETTE_H
#define _INLINE_PALETTE_H

#ifndef CLIB_PALETTE_PROTOS_H
#define CLIB_PALETTE_PROTOS_H
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

#ifndef PALETTE_BASE_NAME
#define PALETTE_BASE_NAME PaletteBase
#endif

#define @{"PALETTE_GetClass()" LINK "gg:doc/NDK/Guide/palette_gc/PALETTE_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"PALETTE_GetClass" LINK File 23}, \\
        , @{"PALETTE_BASE_NAME" LINK File 20})

#endif /*  _INLINE_PALETTE_H  */
@ENDNODE
