@DATABASE "gg:doc/NDK/Guide/Include/inline/getfile.h"
@MASTER   "gg:os-include/inline/getfile.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:53
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/getfile.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/getfile.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_GETFILE_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/getfile.h/File" 5}  @{"GETFILE_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/getfile.h/File" 20}  @{"GETFILE_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/getfile.h/File" 23}

@ENDNODE
@NODE File "inline/getfile.h"
#ifndef _INLINE_GETFILE_H
#define _INLINE_GETFILE_H

#ifndef CLIB_GETFILE_PROTOS_H
#define CLIB_GETFILE_PROTOS_H
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

#ifndef GETFILE_BASE_NAME
#define GETFILE_BASE_NAME GetFileBase
#endif

#define @{"GETFILE_GetClass()" LINK "gg:doc/NDK/Guide/getfile_gc/GETFILE_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"GETFILE_GetClass" LINK File 23}, \\
        , @{"GETFILE_BASE_NAME" LINK File 20})

#endif /*  _INLINE_GETFILE_H  */
@ENDNODE
