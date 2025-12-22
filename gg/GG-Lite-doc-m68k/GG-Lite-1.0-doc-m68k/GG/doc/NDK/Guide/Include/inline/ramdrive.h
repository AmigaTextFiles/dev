@DATABASE "gg:doc/NDK/Guide/Include/inline/ramdrive.h"
@MASTER   "gg:os-include/inline/ramdrive.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:36
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/ramdrive.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/ramdrive.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_RAMDRIVE_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/ramdrive.h/File" 5}  @{"KillRAD()" LINK "gg:doc/NDK/Guide/Include/inline/ramdrive.h/File" 24}  @{"KillRAD0()" LINK "gg:doc/NDK/Guide/Include/inline/ramdrive.h/File" 20}  @{"RAMDRIVE_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/ramdrive.h/File" 17}

@ENDNODE
@NODE File "inline/ramdrive.h"
#ifndef _INLINE_RAMDRIVE_H
#define _INLINE_RAMDRIVE_H

#ifndef CLIB_RAMDRIVE_PROTOS_H
#define CLIB_RAMDRIVE_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef RAMDRIVE_BASE_NAME
#define RAMDRIVE_BASE_NAME RamdriveDevice
#endif

#define KillRAD0() \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x2a, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, @{"KillRAD0" LINK File 20}, \\
        , @{"RAMDRIVE_BASE_NAME" LINK File 17})

#define KillRAD(unit) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x30, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, @{"KillRAD" LINK File 24}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, unit, d0, \\
        , @{"RAMDRIVE_BASE_NAME" LINK File 17})

#endif /*  _INLINE_RAMDRIVE_H  */
@ENDNODE
