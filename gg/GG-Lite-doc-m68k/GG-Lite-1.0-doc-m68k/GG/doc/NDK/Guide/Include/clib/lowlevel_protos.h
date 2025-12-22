@DATABASE "gg:doc/NDK/Guide/Include/clib/lowlevel_protos.h"
@MASTER   "gg:os-include/clib/lowlevel_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:53
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/lowlevel_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/lowlevel_protos.h" LINK File}

@ENDNODE
@NODE File "clib/lowlevel_protos.h"
#ifndef  CLIB_LOWLEVEL_PROTOS_H
#define  CLIB_LOWLEVEL_PROTOS_H

/*
**      $VER: lowlevel_protos.h 40.1 (17.5.1996)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

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
/*--- functions in V40 or higher (Release 3.1) ---*/

/* CONTROLLER HANDLING */

@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"ReadJoyPort" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 32}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} port );

/* LANGUAGE HANDLING */

@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} @{"GetLanguageSelection" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 36}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );

/* KEYBOARD HANDLING */

@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetKey" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 40}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"QueryKeys" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 44}( @{"struct KeyQuery" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 30} *queryArray, ULONG arraySize );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"AddKBInt" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 48}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} intRoutine, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} intData );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RemKBInt" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 52}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} intHandle );

/* SYSTEM HANDLING */

@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SystemControlA" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 56}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tagList );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SystemControl" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 61}( @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30} firstTag, ... );

/* TIMER HANDLING */

@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"AddTimerInt" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 65}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} intRoutine, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} intData );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RemTimerInt" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 69}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} intHandle );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"StopTimerInt" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 73}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} intHandle );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"StartTimerInt" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 77}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} intHandle, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} timeInterval, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} continuous );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"ElapsedTime" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 81}( @{"struct EClockVal" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 35} *context );

/* VBLANK HANDLING */

@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"AddVBlankInt" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 85}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} intRoutine, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} intData );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RemVBlankInt" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 89}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} intHandle );

/* MORE CONTROLLER HANDLING */

@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"SetJoyPortAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 93}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} portNumber, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tagList );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"SetJoyPortAttrs" LINK "gg:doc/NDK/Guide/Include/inline/lowlevel.h/File" 98}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} portNumber, @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30} firstTag, ... );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_LOWLEVEL_PROTOS_H */
@ENDNODE
