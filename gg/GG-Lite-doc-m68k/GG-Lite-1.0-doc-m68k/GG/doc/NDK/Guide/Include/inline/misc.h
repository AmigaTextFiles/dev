@DATABASE "gg:doc/NDK/Guide/Include/inline/misc.h"
@MASTER   "gg:os-include/inline/misc.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:33
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/misc.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/misc.h" LINK File}


@{b}#defines@{ub}

@{"AllocMiscResource()" LINK "gg:doc/NDK/Guide/Include/inline/misc.h/File" 20}  @{"CLIB_MISC_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/misc.h/File" 5}  @{"FreeMiscResource()" LINK "gg:doc/NDK/Guide/Include/inline/misc.h/File" 24}
@{"MISC_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/misc.h/File" 17}       

@ENDNODE
@NODE File "inline/misc.h"
#ifndef _INLINE_MISC_H
#define _INLINE_MISC_H

#ifndef CLIB_MISC_PROTOS_H
#define CLIB_MISC_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef MISC_BASE_NAME
#define MISC_BASE_NAME MiscBase
#endif

#define @{"AllocMiscResource" LINK "gg:doc/NDK/Guide/misc/AllocMiscResource"}(unitNum, name) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x6, @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *, @{"AllocMiscResource" LINK File 20}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, unitNum, d0, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75}, name, a1, \\
        , @{"MISC_BASE_NAME" LINK File 17})

#define @{"FreeMiscResource" LINK "gg:doc/NDK/Guide/misc/FreeMiscResource"}(unitNum) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0xc, @{"FreeMiscResource" LINK File 24}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, unitNum, d0, \\
        , @{"MISC_BASE_NAME" LINK File 17})

#endif /*  _INLINE_MISC_H  */
@ENDNODE
