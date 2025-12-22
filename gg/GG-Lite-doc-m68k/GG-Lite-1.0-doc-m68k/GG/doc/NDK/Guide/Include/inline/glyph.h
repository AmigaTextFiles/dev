@DATABASE "gg:doc/NDK/Guide/Include/inline/glyph.h"
@MASTER   "gg:os-include/inline/glyph.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:54
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/glyph.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/glyph.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_GLYPH_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/glyph.h/File" 5}  @{"GLYPH_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/glyph.h/File" 20}  @{"GLYPH_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/glyph.h/File" 23}

@ENDNODE
@NODE File "inline/glyph.h"
#ifndef _INLINE_GLYPH_H
#define _INLINE_GLYPH_H

#ifndef CLIB_GLYPH_PROTOS_H
#define CLIB_GLYPH_PROTOS_H
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

#ifndef GLYPH_BASE_NAME
#define GLYPH_BASE_NAME GlyphBase
#endif

#define @{"GLYPH_GetClass()" LINK "gg:doc/NDK/Guide/glyph_ic/GLYPH_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"GLYPH_GetClass" LINK File 23}, \\
        , @{"GLYPH_BASE_NAME" LINK File 20})

#endif /*  _INLINE_GLYPH_H  */
@ENDNODE
