@DATABASE "gg:doc/NDK/Guide/Include/clib/console_protos.h"
@MASTER   "gg:os-include/clib/console_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:34
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/console_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/console_protos.h" LINK File}

@ENDNODE
@NODE File "clib/console_protos.h"
#ifndef  CLIB_CONSOLE_PROTOS_H
#define  CLIB_CONSOLE_PROTOS_H

/*
**      $VER: console_protos.h 40.1 (17.5.1996)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef  EXEC_LIBRARIES_H
#include <@{"exec/libraries.h" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File"}>
#endif
#ifndef  DEVICES_INPUTEVENT_H
#include <@{"devices/inputevent.h" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File"}>
#endif
#ifndef  DEVICES_KEYMAP_H
#include <@{"devices/keymap.h" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File"}>
#endif
@{"struct InputEvent" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 257} *CDInputHandler( CONST struct InputEvent *events, struct Library *consoleDevice );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"RawKeyConvert" LINK "gg:doc/NDK/Guide/Include/inline/console.h/File" 30}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct InputEvent" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 257} *events, STRPTR buffer, LONG length, CONST struct KeyMap *keyMap );
/*--- functions in V36 or higher (Release 2.0) ---*/

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_CONSOLE_PROTOS_H */
@ENDNODE
