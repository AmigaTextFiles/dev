@DATABASE "gg:doc/NDK/Guide/Include/clib/alib_protos.h"
@MASTER   "gg:os-include/clib/alib_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:27
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/alib_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/alib_protos.h" LINK File}

@ENDNODE
@NODE File "clib/alib_protos.h"
#ifndef  CLIB_ALIB_PROTOS_H
#define  CLIB_ALIB_PROTOS_H

/*
**      $VER: alib_protos.h 40.1 (6.6.1998)
**      Includes Release 45.1
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
#ifndef  DEVICES_TIMER_H
#include <@{"devices/timer.h" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File"}>
#endif
#ifndef  DEVICES_KEYMAP_H
#include <@{"devices/keymap.h" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File"}>
#endif
#ifndef  LIBRARIES_COMMODITIES_H
#include <@{"libraries/commodities.h" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File"}>
#endif
#ifndef  UTILITY_HOOKS_H
#include <@{"utility/hooks.h" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File"}>
#endif
#ifndef  INTUITION_CLASSES_H
#include <@{"intuition/classes.h" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File"}>
#endif
#ifndef  INTUITION_CLASSUSR_H
#include <@{"intuition/classusr.h" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File"}>
#endif
#ifndef  GRAPHICS_GRAPHINT_H
#include <@{"graphics/graphint.h" LINK "gg:doc/NDK/Guide/Include/graphics/graphint.h/File"}>
#endif
#ifndef  REXX_STORAGE_H
#include <@{"rexx/storage.h" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File"}>
#endif

/*  Exec support functions */

@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"BeginIO" LINK "gg:doc/NDK/Guide/Include/inline/alib.h/File" 8}( @{"struct IORequest" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 18} *ioReq );
@{"struct IORequest" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 18} *CreateExtIO( CONST struct MsgPort *port, LONG ioSize );
@{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *CreatePort( CONST_STRPTR name, LONG pri );
@{"struct IOStdReq" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 27} *CreateStdIO( CONST struct MsgPort *port );
@{"struct Task" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 24} *CreateTask( CONST_STRPTR name, LONG pri, CONST APTR initPC, ULONG stackSize );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} DeleteExtIO( @{"struct IORequest" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 18} *ioReq );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} DeletePort( @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *ioReq );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} DeleteStdIO( @{"struct IOStdReq" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 27} *ioReq );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} DeleteTask( @{"struct Task" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 24} *task );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"NewList" LINK "gg:doc/NDK/Guide/Include/inline/alib.h/File" 15}( @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *list );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} LibAllocPooled( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} poolHeader, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} memSize );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} LibCreatePool( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} memFlags, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} puddleSize, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} threshSize );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} LibDeletePool( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} poolHeader );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} LibFreePooled( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} poolHeader, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} memory, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} memSize );

/* Assorted functions in @{"amiga.lib" LINK "gg:doc/NDK/Guide/amiga_lib/MAIN"} */

@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} FastRand( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} seed );
@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} RangeRand( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} maxValue );

/* Graphics support functions in @{"amiga.lib" LINK "gg:doc/NDK/Guide/amiga_lib/MAIN"} */

@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} AddTOF( @{"struct Isrvstr" LINK "gg:doc/NDK/Guide/Include/graphics/graphint.h/File" 16} *i, LONG (*p)(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} args), @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} a );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} RemTOF( @{"struct Isrvstr" LINK "gg:doc/NDK/Guide/Include/graphics/graphint.h/File" 16} *i );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} waitbeam( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} b );

/* math support functions in @{"amiga.lib" LINK "gg:doc/NDK/Guide/amiga_lib/MAIN"} */

@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} afp( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} string );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} arnd( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} place, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"exp" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 43}, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} string );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} dbf( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"exp" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 43}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} mant );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} fpa( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} fnum, @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58} *string );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} fpbcd( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} fnum, @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58} *string );

/* Timer support functions in @{"amiga.lib" LINK "gg:doc/NDK/Guide/amiga_lib/MAIN"} (V36 and higher only) */

@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} TimeDelay( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} unit, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} secs, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} microsecs );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} DoTimer( @{"struct timeval" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 30} *, LONG unit, LONG command );

/*  Commodities functions in @{"amiga.lib" LINK "gg:doc/NDK/Guide/amiga_lib/MAIN"} (V36 and higher only) */

@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} ArgArrayDone( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} *ArgArrayInit( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} argc, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} *argv );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} ArgInt( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} *tt, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} entry, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} defaultval );
@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} ArgString( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} *tt, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} entry, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} defaultstring );
@{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *HotKey( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} description, @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *port, LONG id );
@{"struct InputEvent" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 257} *InvertString( CONST_STRPTR str, CONST struct KeyMap *km );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} FreeIEvents( @{"struct InputEvent" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 257} *events );

/* Commodities Macros */

/* @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *@{"CxCustom" LINK "gg:doc/NDK/Guide/amiga_lib/CxCustom"}(@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}(*)(),@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} id)(A0,D0) */
/* @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *@{"CxDebug" LINK "gg:doc/NDK/Guide/amiga_lib/CxDebug"}(@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} id)(D0) */
/* @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *@{"CxFilter" LINK "gg:doc/NDK/Guide/amiga_lib/CxFilter"}(@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} description)(A0) */
/* @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *@{"CxSender" LINK "gg:doc/NDK/Guide/amiga_lib/CxSender"}(@{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *port,@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} id)(A0,D0) */
/* @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *@{"CxSignal" LINK "gg:doc/NDK/Guide/amiga_lib/CxSignal"}(@{"struct Task" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 24} *task,@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} signal)(A0,D0) */
/* @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *@{"CxTranslate" LINK "gg:doc/NDK/Guide/amiga_lib/CxTranslate"}(@{"struct InputEvent" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 257} *ie)(A0) */

/*  ARexx support functions in @{"amiga.lib" LINK "gg:doc/NDK/Guide/amiga_lib/MAIN"} */

@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} CheckRexxMsg( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct RexxMsg" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 98} *rexxmsg );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} GetRexxVar( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct RexxMsg" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 98} *rexxmsg, CONST_STRPTR name, STRPTR *result );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} SetRexxVar( @{"struct RexxMsg" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 98} *rexxmsg, CONST_STRPTR name, CONST_STRPTR value, LONG length );

/*  Intuition hook and boopsi support functions in @{"amiga.lib" LINK "gg:doc/NDK/Guide/amiga_lib/MAIN"}. */
/*  These functions do not require any particular ROM revision */
/*  to operate correctly, though they deal with concepts first introduced */
/*  in V36.  These functions would work with compatibly-implemented */
/*  hooks or objects under V34. */

@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} CallHookA( @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *hookPtr, Object *obj, APTR message );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} CallHook( @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *hookPtr, Object *obj, ... );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} DoMethodA( @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *obj, @{"Msg" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 29} message );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} DoMethod( @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *obj, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} methodID, ... );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} DoSuperMethodA( @{"struct IClass" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *cl, Object *obj, Msg message );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} DoSuperMethod( @{"struct IClass" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *cl, Object *obj, ULONG methodID, ... );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} CoerceMethodA( @{"struct IClass" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *cl, Object *obj, Msg message );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} CoerceMethod( @{"struct IClass" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *cl, Object *obj, ULONG methodID, ... );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} HookEntry( @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *hookPtr, Object *obj, APTR message );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} SetSuperAttrs( @{"struct IClass" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *cl, Object *obj, ULONG tag1, ... );

/*  Network-support functions in @{"amiga.lib" LINK "gg:doc/NDK/Guide/amiga_lib/MAIN"}. */
/*  @{"ACrypt()" LINK "gg:doc/NDK/Guide/amiga_lib/ACrypt"} first appeared in later V39 versions of @{"amiga.lib" LINK "gg:doc/NDK/Guide/amiga_lib/MAIN"}, but */
/*  operates correctly under V37 and up. */

@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} ACrypt( @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} buffer, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} password, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} username );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_ALIB_PROTOS_H */
@ENDNODE
