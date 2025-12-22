@DATABASE "gg:doc/NDK/Guide/Include/clib/space_protos.h"
@MASTER   "gg:os-include/clib/space_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:01
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/space_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/space_protos.h" LINK File}

@ENDNODE
@NODE File "clib/space_protos.h"
#ifndef  CLIB_SPACE_PROTOS_H
#define  CLIB_SPACE_PROTOS_H

/*
**      $VER: space_protos.h 1.1 (6.10.1999)
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
@{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *@{"SPACE_GetClass" LINK "gg:doc/NDK/Guide/Include/inline/space.h/File" 23}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_SPACE_PROTOS_H */
@ENDNODE
