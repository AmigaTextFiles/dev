@DATABASE "gg:doc/NDK/Guide/Include/clib/keymap_protos.h"
@MASTER   "gg:os-include/clib/keymap_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:51
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/keymap_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/keymap_protos.h" LINK File}

@ENDNODE
@NODE File "clib/keymap_protos.h"
#ifndef  CLIB_KEYMAP_PROTOS_H
#define  CLIB_KEYMAP_PROTOS_H

/*
**      $VER: keymap_protos.h 40.1 (17.5.1996)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef  DEVICES_INPUTEVENT_H
#include <@{"devices/inputevent.h" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File"}>
#endif
#ifndef  DEVICES_KEYMAP_H
#include <@{"devices/keymap.h" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File"}>
#endif
/*--- functions in V36 or higher (Release 2.0) ---*/
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetKeyMapDefault" LINK "gg:doc/NDK/Guide/Include/inline/keymap.h/File" 23}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct KeyMap" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 21} *keyMap );
@{"struct KeyMap" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 21} *AskKeyMapDefault( VOID );
@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} @{"MapRawKey" LINK "gg:doc/NDK/Guide/Include/inline/keymap.h/File" 31}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct InputEvent" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 257} *event, STRPTR buffer, LONG length, CONST struct KeyMap *keyMap );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"MapANSI" LINK "gg:doc/NDK/Guide/Include/inline/keymap.h/File" 35}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} string, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} count, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} buffer, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} length, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct KeyMap" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File" 21} *keyMap );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_KEYMAP_PROTOS_H */
@ENDNODE
