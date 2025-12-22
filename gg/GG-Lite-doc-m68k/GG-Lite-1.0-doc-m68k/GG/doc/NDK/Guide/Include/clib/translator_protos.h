@DATABASE "gg:doc/NDK/Guide/Include/clib/translator_protos.h"
@MASTER   "gg:os-include/clib/translator_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:02
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/translator_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/translator_protos.h" LINK File}

@ENDNODE
@NODE File "clib/translator_protos.h"
#ifndef  CLIB_TRANSLATOR_PROTOS_H
#define  CLIB_TRANSLATOR_PROTOS_H

/*
**      $VER: translator_protos.h 40.1 (17.5.1996)
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
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"Translate" LINK "gg:doc/NDK/Guide/Include/inline/translator.h/File" 20}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} inputString, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} inputLength, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} outputBuffer, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} bufferSize );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_TRANSLATOR_PROTOS_H */
@ENDNODE
