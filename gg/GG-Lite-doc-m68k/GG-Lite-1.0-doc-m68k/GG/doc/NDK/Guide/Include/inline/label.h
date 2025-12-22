@DATABASE "gg:doc/NDK/Guide/Include/inline/label.h"
@MASTER   "gg:os-include/inline/label.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:09
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/label.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/label.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_LABEL_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/label.h/File" 5}  @{"LABEL_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/label.h/File" 20}  @{"LABEL_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/label.h/File" 23}

@ENDNODE
@NODE File "inline/label.h"
#ifndef _INLINE_LABEL_H
#define _INLINE_LABEL_H

#ifndef CLIB_LABEL_PROTOS_H
#define CLIB_LABEL_PROTOS_H
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

#ifndef LABEL_BASE_NAME
#define LABEL_BASE_NAME LabelBase
#endif

#define @{"LABEL_GetClass()" LINK "gg:doc/NDK/Guide/label_ic/LABEL_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"LABEL_GetClass" LINK File 23}, \\
        , @{"LABEL_BASE_NAME" LINK File 20})

#endif /*  _INLINE_LABEL_H  */
@ENDNODE
