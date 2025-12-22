@DATABASE "gg:doc/NDK/Guide/Include/inline/texteditor.h"
@MASTER   "gg:os-include/inline/texteditor.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:45
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/texteditor.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/texteditor.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_TEXTEDITOR_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/texteditor.h/File" 5}  @{"TEXTEDITOR_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/texteditor.h/File" 20}  @{"TEXTEDITOR_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/texteditor.h/File" 23}

@ENDNODE
@NODE File "inline/texteditor.h"
#ifndef _INLINE_TEXTEDITOR_H
#define _INLINE_TEXTEDITOR_H

#ifndef CLIB_TEXTEDITOR_PROTOS_H
#define CLIB_TEXTEDITOR_PROTOS_H
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

#ifndef TEXTEDITOR_BASE_NAME
#define TEXTEDITOR_BASE_NAME TextFieldBase
#endif

#define TEXTEDITOR_GetClass() \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"TEXTEDITOR_GetClass" LINK File 23}, \\
        , @{"TEXTEDITOR_BASE_NAME" LINK File 20})

#endif /*  _INLINE_TEXTEDITOR_H  */
@ENDNODE
