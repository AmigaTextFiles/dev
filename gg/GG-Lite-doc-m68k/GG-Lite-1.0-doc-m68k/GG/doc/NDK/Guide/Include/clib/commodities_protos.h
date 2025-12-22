@DATABASE "gg:doc/NDK/Guide/Include/clib/commodities_protos.h"
@MASTER   "gg:os-include/clib/commodities_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:33
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/commodities_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/commodities_protos.h" LINK File}

@ENDNODE
@NODE File "clib/commodities_protos.h"
#ifndef  CLIB_COMMODITIES_PROTOS_H
#define  CLIB_COMMODITIES_PROTOS_H

/*
**      $VER: commodities_protos.h 40.1 (17.5.1996)
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
#ifndef  EXEC_NODES_H
#include <@{"exec/nodes.h" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File"}>
#endif
#ifndef  LIBRARIES_COMMODITIES_H
#include <@{"libraries/commodities.h" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File"}>
#endif
#ifndef  DEVICES_INPUTEVENT_H
#include <@{"devices/inputevent.h" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File"}>
#endif
#ifndef  DEVICES_KEYMAP_H
#include <@{"devices/keymap.h" LINK "gg:doc/NDK/Guide/Include/devices/keymap.h/File"}>
#endif
/*--- functions in V36 or higher (Release 2.0) ---*/

/*  OBJECT UTILITIES */

@{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *@{"CreateCxObj" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 32}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} type, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} arg1, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} arg2 );
@{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *@{"CxBroker" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 36}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct NewBroker" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 40} *nb, LONG *error );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"ActivateCxObj" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 40}( @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *co, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} doIt );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DeleteCxObj" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 44}( @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *co );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DeleteCxObjAll" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 48}( @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *co );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"CxObjType" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 52}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *co );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"CxObjError" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 56}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *co );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ClearCxObjError" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 60}( @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *co );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SetCxObjPri" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 64}( @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *co, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} pri );

/*  OBJECT ATTACHMENT */

@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AttachCxObj" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 68}( @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *headObj, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *co );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"EnqueueCxObj" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 72}( @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *headObj, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *co );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"InsertCxObj" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 76}( @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *headObj, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *co, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *pred );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RemoveCxObj" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 80}( @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *co );

/*  TYPE SPECIFIC */

@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetTranslate" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 84}( @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *translator, @{"struct InputEvent" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 257} *events );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetFilter" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 88}( @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *filter, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} text );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SetFilterIX" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 92}( @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *filter, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"IX" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 157} *ix );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"ParseIX" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 96}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} description, @{"IX" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 157} *ix );

/*  COMMON MESSAGE */

@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"CxMsgType" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 100}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"CxMsg" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 76} *cxm );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"CxMsgData" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 104}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"CxMsg" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 76} *cxm );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"CxMsgID" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 108}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"CxMsg" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 76} *cxm );

/*  MESSAGE ROUTING */

@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DivertCxMsg" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 112}( @{"CxMsg" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 76} *cxm, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *headObj, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *returnObj );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RouteCxMsg" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 116}( @{"CxMsg" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 76} *cxm, @{"CxObj" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 75} *co );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DisposeCxMsg" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 120}( @{"CxMsg" LINK "gg:doc/NDK/Guide/Include/libraries/commodities.h/File" 76} *cxm );

/*  INPUT EVENT HANDLING */

@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"InvertKeyMap" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 124}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} ansiCode, @{"struct InputEvent" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 257} *event, CONST struct KeyMap *km );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AddIEvents" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 128}( @{"struct InputEvent" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 257} *events );
/*--- functions in V38 or higher (Release 2.1) ---*/
/*  MORE INPUT EVENT HANDLING */
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"MatchIX" LINK "gg:doc/NDK/Guide/Include/inline/commodities.h/File" 132}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct InputEvent" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 257} *event, CONST IX *ix );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_COMMODITIES_PROTOS_H */
@ENDNODE
