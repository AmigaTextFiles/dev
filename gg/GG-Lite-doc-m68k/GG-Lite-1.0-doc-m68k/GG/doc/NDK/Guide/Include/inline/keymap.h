@DATABASE "gg:doc/NDK/Guide/Include/inline/keymap.h"
@MASTER   "gg:os-include/inline/keymap.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:09
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/keymap.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/keymap.h" LINK File}


@{b}#defines@{ub}

@{"AskKeyMapDefault()" LINK "gg:doc/NDK/Guide/Include/inline/keymap.h/File" 27}  @{"CLIB_KEYMAP_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/keymap.h/File" 5}  @{"KEYMAP_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/keymap.h/File" 20}  @{"MapANSI()" LINK "gg:doc/NDK/Guide/Include/inline/keymap.h/File" 35}
@{"MapRawKey()" LINK "gg:doc/NDK/Guide/Include/inline/keymap.h/File" 31}         @{"SetKeyMapDefault()" LINK "gg:doc/NDK/Guide/Include/inline/keymap.h/File" 23}    

@ENDNODE
@NODE File "inline/keymap.h"
#ifndef _INLINE_KEYMAP_H
#define _INLINE_KEYMAP_H

#ifndef CLIB_KEYMAP_PROTOS_H
#define CLIB_KEYMAP_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  DEVICES_INPUTEVENT_H
#include <@{"devices/inputevent.h" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File"}>
#endif
#ifndef  DEVICES_KEYMAP_H
#include <@{"devices/keymap.h" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File"}>
#endif

#ifndef KEYMAP_BASE_NAME
#define KEYMAP_BASE_NAME KeymapBase
#endif

#define @{"SetKeyMapDefault" LINK "gg:doc/NDK/Guide/keymap/SetKeyMapDefault"}(keyMap) \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x1e, @{"SetKeyMapDefault" LINK File 23}, const @{"struct KeyMap" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 21} *, keyMap, a0, \\
        , KEYMAP_BASE_NAME)

#define @{"AskKeyMapDefault()" LINK "gg:doc/NDK/Guide/keymap/AskKeyMapDefault"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x24, @{"struct KeyMap" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 21} *, AskKeyMapDefault, \\
        , KEYMAP_BASE_NAME)

#define @{"MapRawKey" LINK "gg:doc/NDK/Guide/keymap/MapRawKey"}(event, buffer, length, keyMap) \\
        @{"LP4" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 362}(0x2a, @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}, @{"MapRawKey" LINK File 31}, const @{"struct InputEvent" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 257} *, event, a0, STRPTR, buffer, a1, LONG, length, d1, const struct KeyMap *, keyMap, a2, \\
        , KEYMAP_BASE_NAME)

#define @{"MapANSI" LINK "gg:doc/NDK/Guide/keymap/MapANSI"}(string, count, buffer, length, keyMap) \\
        @{"LP5" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 435}(0x30, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, @{"MapANSI" LINK File 35}, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75}, string, a0, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, count, d0, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}, buffer, a1, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, length, d1, const @{"struct KeyMap" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 21} *, keyMap, a2, \\
        , KEYMAP_BASE_NAME)

#endif /*  _INLINE_KEYMAP_H  */
@ENDNODE
