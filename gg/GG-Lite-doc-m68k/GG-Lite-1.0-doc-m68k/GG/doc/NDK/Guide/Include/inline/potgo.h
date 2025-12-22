@DATABASE "gg:doc/NDK/Guide/Include/inline/potgo.h"
@MASTER   "gg:os-include/inline/potgo.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:35
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/potgo.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/potgo.h" LINK File}


@{b}#defines@{ub}

@{"AllocPotBits()" LINK "gg:doc/NDK/Guide/Include/inline/potgo.h/File" 20}  @{"CLIB_POTGO_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/potgo.h/File" 5}  @{"FreePotBits()" LINK "gg:doc/NDK/Guide/Include/inline/potgo.h/File" 24}  @{"POTGO_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/potgo.h/File" 17}
@{"WritePotgo()" LINK "gg:doc/NDK/Guide/Include/inline/potgo.h/File" 28}    

@ENDNODE
@NODE File "inline/potgo.h"
#ifndef _INLINE_POTGO_H
#define _INLINE_POTGO_H

#ifndef CLIB_POTGO_PROTOS_H
#define CLIB_POTGO_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef POTGO_BASE_NAME
#define POTGO_BASE_NAME PotgoBase
#endif

#define @{"AllocPotBits" LINK "gg:doc/NDK/Guide/potgo/AllocPotBits"}(bits) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x6, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, @{"AllocPotBits" LINK File 20}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, bits, d0, \\
        , @{"POTGO_BASE_NAME" LINK File 17})

#define @{"FreePotBits" LINK "gg:doc/NDK/Guide/potgo/FreePotBits"}(bits) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0xc, @{"FreePotBits" LINK File 24}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, bits, d0, \\
        , @{"POTGO_BASE_NAME" LINK File 17})

#define @{"WritePotgo" LINK "gg:doc/NDK/Guide/potgo/WritePotgo"}(word, mask) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x12, @{"WritePotgo" LINK File 28}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, word, d0, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, mask, d1, \\
        , @{"POTGO_BASE_NAME" LINK File 17})

#endif /*  _INLINE_POTGO_H  */
@ENDNODE
