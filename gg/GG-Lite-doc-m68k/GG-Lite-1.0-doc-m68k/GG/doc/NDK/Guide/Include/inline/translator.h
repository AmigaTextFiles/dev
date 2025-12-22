@DATABASE "gg:doc/NDK/Guide/Include/inline/translator.h"
@MASTER   "gg:os-include/inline/translator.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:46
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/translator.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/translator.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_TRANSLATOR_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/translator.h/File" 5}  @{"Translate()" LINK "gg:doc/NDK/Guide/Include/inline/translator.h/File" 20}  @{"TRANSLATOR_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/translator.h/File" 17}

@ENDNODE
@NODE File "inline/translator.h"
#ifndef _INLINE_TRANSLATOR_H
#define _INLINE_TRANSLATOR_H

#ifndef CLIB_TRANSLATOR_PROTOS_H
#define CLIB_TRANSLATOR_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef TRANSLATOR_BASE_NAME
#define TRANSLATOR_BASE_NAME TranslatorBase
#endif

#define @{"Translate" LINK "gg:doc/NDK/Guide/translator/Translate"}(inputString, inputLength, outputBuffer, bufferSize) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0x1e, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"Translate" LINK File 20}, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75}, inputString, a0, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, inputLength, d0, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, outputBuffer, a1, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, bufferSize, d1, \\
        , @{"TRANSLATOR_BASE_NAME" LINK File 17})

#endif /*  _INLINE_TRANSLATOR_H  */
@ENDNODE
