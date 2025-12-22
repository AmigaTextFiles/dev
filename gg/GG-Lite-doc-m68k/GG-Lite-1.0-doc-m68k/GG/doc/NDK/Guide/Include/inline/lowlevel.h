@DATABASE "gg:doc/NDK/Guide/Include/inline/lowlevel.h"
@MASTER   "gg:os-include/inline/lowlevel.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:14
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/lowlevel.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/lowlevel.h" LINK File}


@{b}#defines@{ub}

@{"AddKBInt()" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 48}              @{"AddTimerInt()" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 65}       @{"AddVBlankInt()" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 85}
@{"CLIB_LOWLEVEL_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 5}  @{"ElapsedTime()" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 81}       @{"GetKey()" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 40}
@{"GetLanguageSelection()" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 36}  @{"LOWLEVEL_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 29}  @{"QueryKeys()" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 44}
@{"ReadJoyPort()" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 32}           @{"RemKBInt()" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 52}          @{"RemTimerInt()" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 69}
@{"RemVBlankInt()" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 89}          @{"SetJoyPortAttrs()" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 98}   @{"SetJoyPortAttrsA()" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 93}
@{"StartTimerInt()" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 77}         @{"StopTimerInt()" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 73}      @{"SystemControl()" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 61}
@{"SystemControlA()" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 56}        

@ENDNODE
@NODE File "inline/lowlevel.h"
#ifndef _INLINE_LOWLEVEL_H
#define _INLINE_LOWLEVEL_H

#ifndef CLIB_LOWLEVEL_PROTOS_H
#define CLIB_LOWLEVEL_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  EXEC_INTERRUPTS_H
#include <@{"exec/interrupts.h" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File"}>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif
#ifndef  DEVICES_TIMER_H
#include <@{"devices/timer.h" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File"}>
#endif
#ifndef  LIBRARIES_LOWLEVEL_H
#include <@{"libraries/lowlevel.h" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File"}>
#endif

#ifndef LOWLEVEL_BASE_NAME
#define LOWLEVEL_BASE_NAME LowLevelBase
#endif

#define @{"ReadJoyPort" LINK "gg:doc/NDK/Guide/lowlevel/ReadJoyPort"}(port) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x1e, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"ReadJoyPort" LINK File 32}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, port, d0, \\
        , @{"LOWLEVEL_BASE_NAME" LINK File 29})

#define @{"GetLanguageSelection()" LINK "gg:doc/NDK/Guide/lowlevel/GetLanguageSelection"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x24, @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}, @{"GetLanguageSelection" LINK File 36}, \\
        , @{"LOWLEVEL_BASE_NAME" LINK File 29})

#define @{"GetKey()" LINK "gg:doc/NDK/Guide/lowlevel/GetKey"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x30, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"GetKey" LINK File 40}, \\
        , @{"LOWLEVEL_BASE_NAME" LINK File 29})

#define @{"QueryKeys" LINK "gg:doc/NDK/Guide/lowlevel/QueryKeys"}(queryArray, arraySize) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x36, @{"QueryKeys" LINK File 44}, @{"struct KeyQuery" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 30} *, queryArray, a0, ULONG, arraySize, d1, \\
        , LOWLEVEL_BASE_NAME)

#define @{"AddKBInt" LINK "gg:doc/NDK/Guide/lowlevel/AddKBInt"}(intRoutine, intData) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x3c, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"AddKBInt" LINK File 48}, const @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, intRoutine, a0, const @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, intData, a1, \\
        , @{"LOWLEVEL_BASE_NAME" LINK File 29})

#define @{"RemKBInt" LINK "gg:doc/NDK/Guide/lowlevel/RemKBInt"}(intHandle) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x42, @{"RemKBInt" LINK File 52}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, intHandle, a1, \\
        , @{"LOWLEVEL_BASE_NAME" LINK File 29})

#define @{"SystemControlA" LINK "gg:doc/NDK/Guide/lowlevel/SystemControlA"}(tagList) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x48, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"SystemControlA" LINK File 56}, const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, tagList, a1, \\
        , LOWLEVEL_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"SystemControl" LINK "gg:doc/NDK/Guide/lowlevel/SystemControlA"}(tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"SystemControlA" LINK File 56}((const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#define @{"AddTimerInt" LINK "gg:doc/NDK/Guide/lowlevel/AddTimerInt"}(intRoutine, intData) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x4e, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"AddTimerInt" LINK File 65}, const @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, intRoutine, a0, const @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, intData, a1, \\
        , @{"LOWLEVEL_BASE_NAME" LINK File 29})

#define @{"RemTimerInt" LINK "gg:doc/NDK/Guide/lowlevel/RemTimerInt"}(intHandle) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x54, @{"RemTimerInt" LINK File 69}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, intHandle, a1, \\
        , @{"LOWLEVEL_BASE_NAME" LINK File 29})

#define @{"StopTimerInt" LINK "gg:doc/NDK/Guide/lowlevel/StopTimerInt"}(intHandle) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x5a, @{"StopTimerInt" LINK File 73}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, intHandle, a1, \\
        , @{"LOWLEVEL_BASE_NAME" LINK File 29})

#define @{"StartTimerInt" LINK "gg:doc/NDK/Guide/lowlevel/StartTimerInt"}(intHandle, timeInterval, continuous) \\
        @{"LP3NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 251}(0x60, @{"StartTimerInt" LINK File 77}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, intHandle, a1, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, timeInterval, d0, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, continuous, d1, \\
        , @{"LOWLEVEL_BASE_NAME" LINK File 29})

#define @{"ElapsedTime" LINK "gg:doc/NDK/Guide/lowlevel/ElapsedTime"}(context) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x66, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, @{"ElapsedTime" LINK File 81}, @{"struct EClockVal" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 35} *, context, a0, \\
        , LOWLEVEL_BASE_NAME)

#define @{"AddVBlankInt" LINK "gg:doc/NDK/Guide/lowlevel/AddVBlankInt"}(intRoutine, intData) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x6c, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, @{"AddVBlankInt" LINK File 85}, const @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, intRoutine, a0, const @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, intData, a1, \\
        , @{"LOWLEVEL_BASE_NAME" LINK File 29})

#define @{"RemVBlankInt" LINK "gg:doc/NDK/Guide/lowlevel/RemVBlankInt"}(intHandle) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x72, @{"RemVBlankInt" LINK File 89}, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}, intHandle, a1, \\
        , @{"LOWLEVEL_BASE_NAME" LINK File 29})

#define @{"SetJoyPortAttrsA" LINK "gg:doc/NDK/Guide/lowlevel/SetJoyPortAttrsA"}(portNumber, tagList) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x84, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"SetJoyPortAttrsA" LINK File 93}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, portNumber, d0, const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *, tagList, a1, \\
        , LOWLEVEL_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define @{"SetJoyPortAttrs" LINK "gg:doc/NDK/Guide/lowlevel/SetJoyPortAttrsA"}(portNumber, tags...) \\
        ({@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} _tags[] = {tags}; @{"SetJoyPortAttrsA" LINK File 93}((portNumber), (const @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) _tags);})
#endif

#endif /*  _INLINE_LOWLEVEL_H  */
@ENDNODE
