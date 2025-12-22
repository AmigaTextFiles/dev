@DATABASE "gg:doc/NDK/Guide/Include/inline/checkbox.h"
@MASTER   "gg:os-include/inline/checkbox.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:32
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/checkbox.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/checkbox.h" LINK File}


@{b}#defines@{ub}

@{"CHECKBOX_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/checkbox.h/File" 20}  @{"CHECKBOX_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/checkbox.h/File" 23}  @{"CLIB_CHECKBOX_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/checkbox.h/File" 5}

@ENDNODE
@NODE File "inline/checkbox.h"
#ifndef _INLINE_CHECKBOX_H
#define _INLINE_CHECKBOX_H

#ifndef CLIB_CHECKBOX_PROTOS_H
#define CLIB_CHECKBOX_PROTOS_H
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

#ifndef CHECKBOX_BASE_NAME
#define CHECKBOX_BASE_NAME CheckBoxBase
#endif

#define @{"CHECKBOX_GetClass()" LINK "gg:doc/NDK/Guide/checkbox_gc/CHECKBOX_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"CHECKBOX_GetClass" LINK File 23}, \\
        , @{"CHECKBOX_BASE_NAME" LINK File 20})

#endif /*  _INLINE_CHECKBOX_H  */
@ENDNODE
