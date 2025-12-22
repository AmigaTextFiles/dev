@DATABASE "gg:doc/NDK/Guide/Include/inline/disk.h"
@MASTER   "gg:os-include/inline/disk.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:40
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/disk.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/disk.h" LINK File}


@{b}#defines@{ub}

@{"AllocUnit()" LINK "gg:doc/NDK/Guide/Include/inline/disk.h/File" 20}  @{"CLIB_DISK_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/disk.h/File" 5}  @{"DISK_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/disk.h/File" 17}  @{"FreeUnit()" LINK "gg:doc/NDK/Guide/Include/inline/disk.h/File" 24}
@{"GetUnit()" LINK "gg:doc/NDK/Guide/Include/inline/disk.h/File" 28}    @{"GetUnitID()" LINK "gg:doc/NDK/Guide/Include/inline/disk.h/File" 36}         @{"GiveUnit()" LINK "gg:doc/NDK/Guide/Include/inline/disk.h/File" 32}      @{"ReadUnitID()" LINK "gg:doc/NDK/Guide/Include/inline/disk.h/File" 40}

@ENDNODE
@NODE File "inline/disk.h"
#ifndef _INLINE_DISK_H
#define _INLINE_DISK_H

#ifndef CLIB_DISK_PROTOS_H
#define CLIB_DISK_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  RESOURCES_DISK_H
#include <@{"resources/disk.h" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File"}>
#endif

#ifndef DISK_BASE_NAME
#define DISK_BASE_NAME DiskBase
#endif

#define @{"AllocUnit" LINK "gg:doc/NDK/Guide/disk/AllocUnit"}(unitNum) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x6, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"AllocUnit" LINK File 20}, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, unitNum, d0, \\
        , @{"DISK_BASE_NAME" LINK File 17})

#define @{"FreeUnit" LINK "gg:doc/NDK/Guide/disk/FreeUnit"}(unitNum) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0xc, @{"FreeUnit" LINK File 24}, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, unitNum, d0, \\
        , @{"DISK_BASE_NAME" LINK File 17})

#define @{"GetUnit" LINK "gg:doc/NDK/Guide/disk/GetUnit"}(unitPointer) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x12, @{"struct DiscResourceUnit" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 41} *, GetUnit, struct DiscResourceUnit *, unitPointer, a1, \\
        , DISK_BASE_NAME)

#define @{"GiveUnit()" LINK "gg:doc/NDK/Guide/disk/GiveUnit"} \\
        @{"LP0NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 41}(0x18, @{"GiveUnit" LINK File 32}, \\
        , @{"DISK_BASE_NAME" LINK File 17})

#define @{"GetUnitID" LINK "gg:doc/NDK/Guide/disk/GetUnitID"}(unitNum) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x1e, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"GetUnitID" LINK File 36}, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, unitNum, d0, \\
        , @{"DISK_BASE_NAME" LINK File 17})

#define @{"ReadUnitID" LINK "gg:doc/NDK/Guide/disk/ReadUnitID"}(unitNum) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x24, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"ReadUnitID" LINK File 40}, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, unitNum, d0, \\
        , @{"DISK_BASE_NAME" LINK File 17})

#endif /*  _INLINE_DISK_H  */
@ENDNODE
