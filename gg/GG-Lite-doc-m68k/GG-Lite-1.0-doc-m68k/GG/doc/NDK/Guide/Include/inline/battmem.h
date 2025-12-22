@DATABASE "gg:doc/NDK/Guide/Include/inline/battmem.h"
@MASTER   "gg:os-include/inline/battmem.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:30
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/battmem.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/battmem.h" LINK File}


@{b}#defines@{ub}

@{"BATTMEM_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/battmem.h/File" 17}  @{"CLIB_BATTMEM_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/battmem.h/File" 5}   @{"ObtainBattSemaphore()" LINK "gg:doc/NDK/Guide/Include/inline/battmem.h/File" 20}
@{"ReadBattMem()" LINK "gg:doc/NDK/Guide/Include/inline/battmem.h/File" 28}      @{"ReleaseBattSemaphore()" LINK "gg:doc/NDK/Guide/Include/inline/battmem.h/File" 24}  @{"WriteBattMem()" LINK "gg:doc/NDK/Guide/Include/inline/battmem.h/File" 32}

@ENDNODE
@NODE File "inline/battmem.h"
#ifndef _INLINE_BATTMEM_H
#define _INLINE_BATTMEM_H

#ifndef CLIB_BATTMEM_PROTOS_H
#define CLIB_BATTMEM_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef BATTMEM_BASE_NAME
#define BATTMEM_BASE_NAME BattMemBase
#endif

#define @{"ObtainBattSemaphore()" LINK "gg:doc/NDK/Guide/battmem/ObtainBattSemaphore"} \\
        @{"LP0NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 41}(0x6, @{"ObtainBattSemaphore" LINK File 20}, \\
        , @{"BATTMEM_BASE_NAME" LINK File 17})

#define @{"ReleaseBattSemaphore()" LINK "gg:doc/NDK/Guide/battmem/ReleaseBattSemaphore"} \\
        @{"LP0NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 41}(0xc, @{"ReleaseBattSemaphore" LINK File 24}, \\
        , @{"BATTMEM_BASE_NAME" LINK File 17})

#define @{"ReadBattMem" LINK "gg:doc/NDK/Guide/battmem/ReadBattMem"}(buffer, offset, length) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x12, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"ReadBattMem" LINK File 28}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, buffer, a0, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, offset, d0, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, length, d1, \\
        , @{"BATTMEM_BASE_NAME" LINK File 17})

#define @{"WriteBattMem" LINK "gg:doc/NDK/Guide/battmem/WriteBattMem"}(buffer, offset, length) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x18, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"WriteBattMem" LINK File 32}, const @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, buffer, a0, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, offset, d0, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, length, d1, \\
        , @{"BATTMEM_BASE_NAME" LINK File 17})

#endif /*  _INLINE_BATTMEM_H  */
@ENDNODE
