@DATABASE "gg:doc/NDK/Guide/Include/inline/realtime.h"
@MASTER   "gg:os-include/inline/realtime.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:37
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/realtime.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/realtime.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_REALTIME_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/realtime.h/File" 5}  @{"CreatePlayer()" LINK "gg:doc/NDK/Guide/Include/inline/realtime.h/File" 39}      @{"CreatePlayerA()" LINK "gg:doc/NDK/Guide/Include/inline/realtime.h/File" 34}
@{"DeletePlayer()" LINK "gg:doc/NDK/Guide/Include/inline/realtime.h/File" 43}          @{"ExternalSync()" LINK "gg:doc/NDK/Guide/Include/inline/realtime.h/File" 60}      @{"FindConductor()" LINK "gg:doc/NDK/Guide/Include/inline/realtime.h/File" 68}
@{"GetPlayerAttrs()" LINK "gg:doc/NDK/Guide/Include/inline/realtime.h/File" 77}        @{"GetPlayerAttrsA()" LINK "gg:doc/NDK/Guide/Include/inline/realtime.h/File" 72}   @{"LockRealTime()" LINK "gg:doc/NDK/Guide/Include/inline/realtime.h/File" 26}
@{"NextConductor()" LINK "gg:doc/NDK/Guide/Include/inline/realtime.h/File" 64}         @{"REALTIME_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/realtime.h/File" 23}  @{"SetConductorState()" LINK "gg:doc/NDK/Guide/Include/inline/realtime.h/File" 56}
@{"SetPlayerAttrs()" LINK "gg:doc/NDK/Guide/Include/inline/realtime.h/File" 52}        @{"SetPlayerAttrsA()" LINK "gg:doc/NDK/Guide/Include/inline/realtime.h/File" 47}   @{"UnlockRealTime()" LINK "gg:doc/NDK/Guide/Include/inline/realtime.h/File" 30}

@ENDNODE
@NODE File "inline/realtime.h"
#ifndef _INLINE_REALTIME_H
#define _INLINE_REALTIME_H

#ifndef CLIB_REALTIME_PROTOS_H
#define CLIB_REALTIME_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  LIBRARIES_REALTIME_H
#include <@{"libraries/realtime.h" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File"}>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif

#ifndef REALTIME_BASE_NAME
#define REALTIME_BASE_NAME RealTimeBase
#endif

#define @{"LockRealTime" LINK "gg:doc/NDK/Guide/realtime/LockRealTime"}(lockType) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x1e, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"LockRealTime" LINK File 26}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, lockType, d0, \\
        , @{"REALTIME_BASE_NAME" LINK File 23})

#define @{"UnlockRealTime" LINK "gg:doc/NDK/Guide/realtime/UnlockRealTime"}(lock) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x24, @{"UnlockRealTime" LINK File 30}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, lock, a0, \\
        , @{"REALTIME_BASE_NAME" LINK File 23})

#define @{"CreatePlayerA" LINK "gg:doc/NDK/Guide/realtime/CreatePlayer"}(tagList) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x2a, @{"struct Player" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 106} *, CreatePlayerA, const struct TagItem *, tagList, a0, \\
        , REALTIME_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"CreatePlayer" LINK "gg:doc/NDK/Guide/realtime/CreatePlayer"}(tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"CreatePlayerA" LINK File 34}((const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"DeletePlayer" LINK "gg:doc/NDK/Guide/realtime/DeletePlayer"}(player) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x30, @{"DeletePlayer" LINK File 43}, @{"struct Player" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 106} *, player, a0, \\
        , REALTIME_BASE_NAME)

#define @{"SetPlayerAttrsA" LINK "gg:doc/NDK/Guide/realtime/SetPlayerAttrs"}(player, tagList) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x36, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"SetPlayerAttrsA" LINK File 47}, @{"struct Player" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 106} *, player, a0, const struct TagItem *, tagList, a1, \\
        , REALTIME_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"SetPlayerAttrs" LINK "gg:doc/NDK/Guide/realtime/SetPlayerAttrs"}(player, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"SetPlayerAttrsA" LINK File 47}((player), (const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"SetConductorState" LINK "gg:doc/NDK/Guide/realtime/SetConductorState"}(player, state, time) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x3c, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"SetConductorState" LINK File 56}, @{"struct Player" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 106} *, player, a0, ULONG, state, d0, LONG, time, d1, \\
        , REALTIME_BASE_NAME)

#define @{"ExternalSync" LINK "gg:doc/NDK/Guide/realtime/ExternalSync"}(player, minTime, maxTime) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x42, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"ExternalSync" LINK File 60}, @{"struct Player" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 106} *, player, a0, LONG, minTime, d0, LONG, maxTime, d1, \\
        , REALTIME_BASE_NAME)

#define @{"NextConductor" LINK "gg:doc/NDK/Guide/realtime/NextConductor"}(previousConductor) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x48, @{"struct Conductor" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 58} *, NextConductor, const struct Conductor *, previousConductor, a0, \\
        , REALTIME_BASE_NAME)

#define @{"FindConductor" LINK "gg:doc/NDK/Guide/realtime/FindConductor"}(name) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x4e, @{"struct Conductor" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 58} *, FindConductor, CONST_STRPTR, name, a0, \\
        , REALTIME_BASE_NAME)

#define @{"GetPlayerAttrsA" LINK "gg:doc/NDK/Guide/realtime/GetPlayerAttrsA"}(player, tagList) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x54, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"GetPlayerAttrsA" LINK File 72}, const @{"struct Player" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 106} *, player, a0, const struct TagItem *, tagList, a1, \\
        , REALTIME_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"GetPlayerAttrs" LINK "gg:doc/NDK/Guide/realtime/GetPlayerAttrsA"}(player, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"GetPlayerAttrsA" LINK File 72}((player), (const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#endif /*  _INLINE_REALTIME_H  */
@ENDNODE
