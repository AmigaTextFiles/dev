@DATABASE "gg:doc/NDK/Guide/Include/clib/realtime_protos.h"
@MASTER   "gg:os-include/clib/realtime_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:58
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/realtime_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/realtime_protos.h" LINK File}

@ENDNODE
@NODE File "clib/realtime_protos.h"
#ifndef  CLIB_REALTIME_PROTOS_H
#define  CLIB_REALTIME_PROTOS_H

/*
**      $VER: realtime_protos.h 40.1 (17.5.1996)
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
#ifndef  LIBRARIES_REALTIME_H
#include <@{"libraries/realtime.h" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File"}>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif
/*--- functions in V37 or higher (Release 2.04) ---*/

/* Locks */

@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"LockRealTime" LINK "gg:doc/NDK/Guide/Include/inline/realtime.h/File" 26}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} lockType );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"UnlockRealTime" LINK "gg:doc/NDK/Guide/Include/inline/realtime.h/File" 30}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} lock );

/* Conductor */

@{"struct Player" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 106} *CreatePlayerA( CONST struct TagItem *tagList );
@{"struct Player" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 106} *CreatePlayer( Tag tag1, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DeletePlayer" LINK "gg:doc/NDK/Guide/Include/inline/realtime.h/File" 43}( @{"struct Player" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 106} *player );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"SetPlayerAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/realtime.h/File" 47}( @{"struct Player" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 106} *player, CONST struct TagItem *tagList );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"SetPlayerAttrs" LINK "gg:doc/NDK/Guide/Include/inline/realtime.h/File" 52}( @{"struct Player" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 106} *player, Tag tag1, ... );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SetConductorState" LINK "gg:doc/NDK/Guide/Include/inline/realtime.h/File" 56}( @{"struct Player" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 106} *player, ULONG state, LONG time );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"ExternalSync" LINK "gg:doc/NDK/Guide/Include/inline/realtime.h/File" 60}( @{"struct Player" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 106} *player, LONG minTime, LONG maxTime );
@{"struct Conductor" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 58} *NextConductor( CONST struct Conductor *previousConductor );
@{"struct Conductor" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 58} *FindConductor( CONST_STRPTR name );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetPlayerAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/realtime.h/File" 72}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct Player" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 106} *player, CONST struct TagItem *tagList );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetPlayerAttrs" LINK "gg:doc/NDK/Guide/Include/inline/realtime.h/File" 77}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct Player" LINK "gg:doc/NDK/Guide/Include/libraries/realtime.h/File" 106} *player, Tag tag1, ... );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_REALTIME_PROTOS_H */
@ENDNODE
