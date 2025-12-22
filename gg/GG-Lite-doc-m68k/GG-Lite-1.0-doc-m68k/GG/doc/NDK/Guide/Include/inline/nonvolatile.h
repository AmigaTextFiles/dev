@DATABASE "gg:doc/NDK/Guide/Include/inline/nonvolatile.h"
@MASTER   "gg:os-include/inline/nonvolatile.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:33
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/nonvolatile.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/nonvolatile.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_NONVOLATILE_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/nonvolatile.h/File" 5}  @{"DeleteNV()" LINK "gg:doc/NDK/Guide/Include/inline/nonvolatile.h/File" 38}         @{"FreeNVData()" LINK "gg:doc/NDK/Guide/Include/inline/nonvolatile.h/File" 30}
@{"GetCopyNV()" LINK "gg:doc/NDK/Guide/Include/inline/nonvolatile.h/File" 26}                @{"GetNVInfo()" LINK "gg:doc/NDK/Guide/Include/inline/nonvolatile.h/File" 42}        @{"GetNVList()" LINK "gg:doc/NDK/Guide/Include/inline/nonvolatile.h/File" 46}
@{"NONVOLATILE_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/nonvolatile.h/File" 23}      @{"SetNVProtection()" LINK "gg:doc/NDK/Guide/Include/inline/nonvolatile.h/File" 50}  @{"StoreNV()" LINK "gg:doc/NDK/Guide/Include/inline/nonvolatile.h/File" 34}

@ENDNODE
@NODE File "inline/nonvolatile.h"
#ifndef _INLINE_NONVOLATILE_H
#define _INLINE_NONVOLATILE_H

#ifndef CLIB_NONVOLATILE_PROTOS_H
#define CLIB_NONVOLATILE_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  EXEC_LISTS_H
#include <@{"exec/lists.h" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File"}>
#endif
#ifndef  LIBRARIES_NONVOLATILE_H
#include <@{"libraries/nonvolatile.h" LINK "gg:doc/NDK/Guide/Include/libraries/nonvolatile.h/File"}>
#endif

#ifndef NONVOLATILE_BASE_NAME
#define NONVOLATILE_BASE_NAME NVBase
#endif

#define @{"GetCopyNV" LINK "gg:doc/NDK/Guide/nonvolatile/GetCopyNV"}(appName, itemName, killRequesters) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x1e, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"GetCopyNV" LINK File 26}, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75}, appName, a0, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75}, itemName, a1, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, killRequesters, d1, \\
        , @{"NONVOLATILE_BASE_NAME" LINK File 23})

#define @{"FreeNVData" LINK "gg:doc/NDK/Guide/nonvolatile/FreeNVData"}(data) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x24, @{"FreeNVData" LINK File 30}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, data, a0, \\
        , @{"NONVOLATILE_BASE_NAME" LINK File 23})

#define @{"StoreNV" LINK "gg:doc/NDK/Guide/nonvolatile/StoreNV"}(appName, itemName, data, length, killRequesters) \\
        @{"LP5" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 435}(0x2a, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, @{"StoreNV" LINK File 34}, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75}, appName, a0, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75}, itemName, a1, const @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, data, a2, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, length, d0, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, killRequesters, d1, \\
        , @{"NONVOLATILE_BASE_NAME" LINK File 23})

#define @{"DeleteNV" LINK "gg:doc/NDK/Guide/nonvolatile/DeleteNV"}(appName, itemName, killRequesters) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x30, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"DeleteNV" LINK File 38}, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75}, appName, a0, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75}, itemName, a1, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, killRequesters, d1, \\
        , @{"NONVOLATILE_BASE_NAME" LINK File 23})

#define @{"GetNVInfo" LINK "gg:doc/NDK/Guide/nonvolatile/GetNVInfo"}(killRequesters) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x36, @{"struct NVInfo" LINK "gg:doc/NDK/Guide/Include/libraries/nonvolatile.h/File" 29} *, GetNVInfo, LONG, killRequesters, d1, \\
        , NONVOLATILE_BASE_NAME)

#define @{"GetNVList" LINK "gg:doc/NDK/Guide/nonvolatile/GetNVList"}(appName, killRequesters) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x3c, @{"struct MinList" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 31} *, GetNVList, CONST_STRPTR, appName, a0, LONG, killRequesters, d1, \\
        , NONVOLATILE_BASE_NAME)

#define @{"SetNVProtection" LINK "gg:doc/NDK/Guide/nonvolatile/SetNVProtection"}(appName, itemName, mask, killRequesters) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0x42, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"SetNVProtection" LINK File 50}, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75}, appName, a0, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75}, itemName, a1, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, mask, d2, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, killRequesters, d1, \\
        , @{"NONVOLATILE_BASE_NAME" LINK File 23})

#endif /*  _INLINE_NONVOLATILE_H  */
@ENDNODE
