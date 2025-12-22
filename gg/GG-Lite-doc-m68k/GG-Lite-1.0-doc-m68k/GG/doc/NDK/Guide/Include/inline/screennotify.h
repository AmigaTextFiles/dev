@DATABASE "gg:doc/NDK/Guide/Include/inline/screennotify.h"
@MASTER   "gg:os-include/inline/screennotify.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:42
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/screennotify.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/screennotify.h" LINK File}


@{b}#defines@{ub}

@{"AddCloseScreenClient()" LINK "gg:doc/NDK/Guide/Include/inline/screennotify.h/File" 20}      @{"AddPubScreenClient()" LINK "gg:doc/NDK/Guide/Include/inline/screennotify.h/File" 28}    @{"AddWorkbenchClient()" LINK "gg:doc/NDK/Guide/Include/inline/screennotify.h/File" 36}
@{"CLIB_SCREENNOTIFY_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/screennotify.h/File" 5}  @{"RemCloseScreenClient()" LINK "gg:doc/NDK/Guide/Include/inline/screennotify.h/File" 24}  @{"RemPubScreenClient()" LINK "gg:doc/NDK/Guide/Include/inline/screennotify.h/File" 32}
@{"RemWorkbenchClient()" LINK "gg:doc/NDK/Guide/Include/inline/screennotify.h/File" 40}        @{"SCREENNOTIFY_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/screennotify.h/File" 17}  

@ENDNODE
@NODE File "inline/screennotify.h"
#ifndef _INLINE_SCREENNOTIFY_H
#define _INLINE_SCREENNOTIFY_H

#ifndef CLIB_SCREENNOTIFY_PROTOS_H
#define CLIB_SCREENNOTIFY_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef SCREENNOTIFY_BASE_NAME
#define SCREENNOTIFY_BASE_NAME ScreenNotifyBase
#endif

#define AddCloseScreenClient(screen, port, pri) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x1e, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"AddCloseScreenClient" LINK File 20}, @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *, screen, a0, struct MsgPort *, port, a1, BYTE, pri, d0, \\
        , SCREENNOTIFY_BASE_NAME)

#define RemCloseScreenClient(handle) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x24, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"RemCloseScreenClient" LINK File 24}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, handle, a0, \\
        , @{"SCREENNOTIFY_BASE_NAME" LINK File 17})

#define AddPubScreenClient(port, pri) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x2a, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"AddPubScreenClient" LINK File 28}, @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *, port, a0, BYTE, pri, d0, \\
        , SCREENNOTIFY_BASE_NAME)

#define RemPubScreenClient(handle) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x30, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"RemPubScreenClient" LINK File 32}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, handle, a0, \\
        , @{"SCREENNOTIFY_BASE_NAME" LINK File 17})

#define AddWorkbenchClient(port, pri) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x36, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"AddWorkbenchClient" LINK File 36}, @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *, port, a0, BYTE, pri, d0, \\
        , SCREENNOTIFY_BASE_NAME)

#define RemWorkbenchClient(handle) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x3c, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"RemWorkbenchClient" LINK File 40}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, handle, a0, \\
        , @{"SCREENNOTIFY_BASE_NAME" LINK File 17})

#endif /*  _INLINE_SCREENNOTIFY_H  */
@ENDNODE
