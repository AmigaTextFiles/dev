@DATABASE "gg:doc/NDK/Guide/Include/inline/rexxsyslib.h"
@MASTER   "gg:os-include/inline/rexxsyslib.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:42
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/rexxsyslib.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/rexxsyslib.h" LINK File}


@{b}#defines@{ub}

@{"ClearRexxMsg()" LINK "gg:doc/NDK/Guide/Include/inline/rexxsyslib.h/File" 46}   @{"CLIB_REXXSYSLIB_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/rexxsyslib.h/File" 5}  @{"CreateArgstring()" LINK "gg:doc/NDK/Guide/Include/inline/rexxsyslib.h/File" 26}
@{"CreateRexxMsg()" LINK "gg:doc/NDK/Guide/Include/inline/rexxsyslib.h/File" 38}  @{"DeleteArgstring()" LINK "gg:doc/NDK/Guide/Include/inline/rexxsyslib.h/File" 30}         @{"DeleteRexxMsg()" LINK "gg:doc/NDK/Guide/Include/inline/rexxsyslib.h/File" 42}
@{"FillRexxMsg()" LINK "gg:doc/NDK/Guide/Include/inline/rexxsyslib.h/File" 50}    @{"IsRexxMsg()" LINK "gg:doc/NDK/Guide/Include/inline/rexxsyslib.h/File" 54}               @{"LengthArgstring()" LINK "gg:doc/NDK/Guide/Include/inline/rexxsyslib.h/File" 34}
@{"LockRexxBase()" LINK "gg:doc/NDK/Guide/Include/inline/rexxsyslib.h/File" 58}   @{"REXXSYSLIB_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/rexxsyslib.h/File" 23}      @{"UnlockRexxBase()" LINK "gg:doc/NDK/Guide/Include/inline/rexxsyslib.h/File" 62}

@ENDNODE
@NODE File "inline/rexxsyslib.h"
#ifndef _INLINE_REXXSYSLIB_H
#define _INLINE_REXXSYSLIB_H

#ifndef CLIB_REXXSYSLIB_PROTOS_H
#define CLIB_REXXSYSLIB_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  REXX_RXSLIB_H
#include <@{"rexx/rxslib.h" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File"}>
#endif
#ifndef  REXX_REXXIO_H
#include <@{"rexx/rexxio.h" LINK "gg:doc/NDK/Guide/Include/rexx/rexxio.h/File"}>
#endif

#ifndef REXXSYSLIB_BASE_NAME
#define REXXSYSLIB_BASE_NAME RexxSysBase
#endif

#define @{"CreateArgstring" LINK "gg:doc/NDK/Guide/rexxsyslib/CreateArgstring"}(string, length) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x7e, @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *, @{"CreateArgstring" LINK File 26}, const @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, string, a0, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, length, d0, \\
        , @{"REXXSYSLIB_BASE_NAME" LINK File 23})

#define @{"DeleteArgstring" LINK "gg:doc/NDK/Guide/rexxsyslib/DeleteArgstring"}(argstring) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x84, @{"DeleteArgstring" LINK File 30}, @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *, argstring, a0, \\
        , @{"REXXSYSLIB_BASE_NAME" LINK File 23})

#define @{"LengthArgstring" LINK "gg:doc/NDK/Guide/rexxsyslib/LengthArgstring"}(argstring) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x8a, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"LengthArgstring" LINK File 34}, const @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *, argstring, a0, \\
        , @{"REXXSYSLIB_BASE_NAME" LINK File 23})

#define @{"CreateRexxMsg" LINK "gg:doc/NDK/Guide/rexxsyslib/CreateRexxMsg"}(port, extension, host) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x90, @{"struct RexxMsg" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 98} *, CreateRexxMsg, const struct MsgPort *, port, a0, CONST_STRPTR, extension, a1, CONST_STRPTR, host, d0, \\
        , REXXSYSLIB_BASE_NAME)

#define @{"DeleteRexxMsg" LINK "gg:doc/NDK/Guide/rexxsyslib/DeleteRexxMsg"}(packet) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x96, @{"DeleteRexxMsg" LINK File 42}, @{"struct RexxMsg" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 98} *, packet, a0, \\
        , REXXSYSLIB_BASE_NAME)

#define @{"ClearRexxMsg" LINK "gg:doc/NDK/Guide/rexxsyslib/ClearRexxMsg"}(msgptr, count) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x9c, @{"ClearRexxMsg" LINK File 46}, @{"struct RexxMsg" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 98} *, msgptr, a0, ULONG, count, d0, \\
        , REXXSYSLIB_BASE_NAME)

#define @{"FillRexxMsg" LINK "gg:doc/NDK/Guide/rexxsyslib/FillRexxMsg"}(msgptr, count, mask) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0xa2, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"FillRexxMsg" LINK File 50}, @{"struct RexxMsg" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 98} *, msgptr, a0, ULONG, count, d0, ULONG, mask, d1, \\
        , REXXSYSLIB_BASE_NAME)

#define @{"IsRexxMsg" LINK "gg:doc/NDK/Guide/rexxsyslib/IsRexxMsg"}(msgptr) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0xa8, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"IsRexxMsg" LINK File 54}, const @{"struct RexxMsg" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 98} *, msgptr, a0, \\
        , REXXSYSLIB_BASE_NAME)

#define @{"LockRexxBase" LINK "gg:doc/NDK/Guide/rexxsyslib/LockRexxBase"}(resource) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x1c2, @{"LockRexxBase" LINK File 58}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, resource, d0, \\
        , @{"REXXSYSLIB_BASE_NAME" LINK File 23})

#define @{"UnlockRexxBase" LINK "gg:doc/NDK/Guide/rexxsyslib/UnlockRexxBase"}(resource) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x1c8, @{"UnlockRexxBase" LINK File 62}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, resource, d0, \\
        , @{"REXXSYSLIB_BASE_NAME" LINK File 23})

#endif /*  _INLINE_REXXSYSLIB_H  */
@ENDNODE
