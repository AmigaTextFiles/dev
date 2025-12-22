@DATABASE "gg:doc/NDK/Guide/Include/inline/console.h"
@MASTER   "gg:os-include/inline/console.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:36
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/console.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/console.h" LINK File}


@{b}#defines@{ub}

@{"CDInputHandler()" LINK "gg:doc/NDK/Guide/Include/inline/console.h/File" 26}  @{"CLIB_CONSOLE_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/console.h/File" 5}  @{"CONSOLE_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/console.h/File" 23}
@{"RawKeyConvert()" LINK "gg:doc/NDK/Guide/Include/inline/console.h/File" 30}   

@ENDNODE
@NODE File "inline/console.h"
#ifndef _INLINE_CONSOLE_H
#define _INLINE_CONSOLE_H

#ifndef CLIB_CONSOLE_PROTOS_H
#define CLIB_CONSOLE_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_LIBRARIES_H
#include <@{"exec/libraries.h" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File"}>
#endif
#ifndef  DEVICES_INPUTEVENT_H
#include <@{"devices/inputevent.h" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File"}>
#endif
#ifndef  DEVICES_KEYMAP_H
#include <@{"devices/keymap.h" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File"}>
#endif

#ifndef CONSOLE_BASE_NAME
#define CONSOLE_BASE_NAME ConsoleDevice
#endif

#define @{"CDInputHandler" LINK "gg:doc/NDK/Guide/console/CDInputHandler"}(events, consoleDevice) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x2a, @{"struct InputEvent" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 257} *, CDInputHandler, const struct InputEvent *, events, a0, struct Library *, consoleDevice, a1, \\
        , CONSOLE_BASE_NAME)

#define @{"RawKeyConvert" LINK "gg:doc/NDK/Guide/console/RawKeyConvert"}(events, buffer, length, keyMap) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0x30, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"RawKeyConvert" LINK File 30}, const @{"struct InputEvent" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 257} *, events, a0, STRPTR, buffer, a1, LONG, length, d1, const struct KeyMap *, keyMap, a2, \\
        , CONSOLE_BASE_NAME)

#endif /*  _INLINE_CONSOLE_H  */
@ENDNODE
