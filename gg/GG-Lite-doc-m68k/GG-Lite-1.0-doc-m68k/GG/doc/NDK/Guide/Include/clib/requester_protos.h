@DATABASE "gg:doc/NDK/Guide/Include/clib/requester_protos.h"
@MASTER   "gg:os-include/clib/requester_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:00
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/requester_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/requester_protos.h" LINK File}

@ENDNODE
@NODE File "clib/requester_protos.h"
#ifndef  CLIB_REQUESTER_PROTOS_H
#define  CLIB_REQUESTER_PROTOS_H

/*
**      $VER: requester_protos.h 1.1 (6.10.1999)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef  INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif
#ifndef  INTUITION_CLASSES_H
#include <@{"intuition/classes.h" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File"}>
#endif
@{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *@{"REQUESTER_GetClass" LINK "gg:doc/NDK/Guide/Include/inline/requester.h/File" 23}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_REQUESTER_PROTOS_H */
@ENDNODE
