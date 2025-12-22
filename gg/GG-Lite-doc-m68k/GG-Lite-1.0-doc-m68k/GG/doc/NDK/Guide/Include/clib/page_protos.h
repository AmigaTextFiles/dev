@DATABASE "gg:doc/NDK/Guide/Include/clib/page_protos.h"
@MASTER   "gg:os-include/clib/page_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:56
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/page_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/page_protos.h" LINK File}

@ENDNODE
@NODE File "clib/page_protos.h"
#ifndef CLIB_PAGE_PROTOS_H
#define CLIB_PAGE_PROTOS_H
/*
**      $VER: page_protos.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      C prototypes. For use with 32 bit integers only.
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef INTUITION_CLASSES_H
#include <@{"intuition/classes.h" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File"}>
#endif

#ifdef __cplusplus
extern "C" {
#endif

@{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} * @{"PAGE_GetClass" LINK "gg:doc/NDK/Guide/Include/inline/layout.h/File" 46}(@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24});

#ifdef __cplusplus
}
#endif

#endif /* CLIB_PAGE_PROTOS_H */
@ENDNODE
