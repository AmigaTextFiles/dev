@DATABASE "gg:doc/NDK/Guide/Include/inline/input.h"
@MASTER   "gg:os-include/inline/input.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:04
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/input.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/input.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_INPUT_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/input.h/File" 5}  @{"INPUT_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/input.h/File" 17}  @{"PeekQualifier()" LINK "gg:doc/NDK/Guide/Include/inline/input.h/File" 20}

@ENDNODE
@NODE File "inline/input.h"
#ifndef _INLINE_INPUT_H
#define _INLINE_INPUT_H

#ifndef CLIB_INPUT_PROTOS_H
#define CLIB_INPUT_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef INPUT_BASE_NAME
#define INPUT_BASE_NAME InputBase
#endif

#define @{"PeekQualifier()" LINK "gg:doc/NDK/Guide/input/PeekQualifier"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x2a, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, @{"PeekQualifier" LINK File 20}, \\
        , @{"INPUT_BASE_NAME" LINK File 17})

#endif /*  _INLINE_INPUT_H  */
@ENDNODE
