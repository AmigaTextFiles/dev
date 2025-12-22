@DATABASE "gg:doc/NDK/Guide/Include/clib/texteditor_protos.h"
@MASTER   "gg:os-include/clib/texteditor_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:01
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/texteditor_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/texteditor_protos.h" LINK File}

@ENDNODE
@NODE File "clib/texteditor_protos.h"
#ifndef  CLIB_TEXTEDITOR_PROTOS_H
#define  CLIB_TEXTEDITOR_PROTOS_H

/*
**      $VER: texteditor_protos.h 1.1 (6.10.1999)
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
@{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *@{"TEXTEDITOR_GetClass" LINK "gg:doc/NDK/Guide/Include/inline/texteditor.h/File" 23}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_TEXTEDITOR_PROTOS_H */
@ENDNODE
