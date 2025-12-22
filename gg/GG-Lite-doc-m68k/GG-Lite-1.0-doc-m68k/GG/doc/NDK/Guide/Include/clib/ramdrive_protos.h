@DATABASE "gg:doc/NDK/Guide/Include/clib/ramdrive_protos.h"
@MASTER   "gg:os-include/clib/ramdrive_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:57
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/ramdrive_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/ramdrive_protos.h" LINK File}

@ENDNODE
@NODE File "clib/ramdrive_protos.h"
#ifndef  CLIB_RAMDRIVE_PROTOS_H
#define  CLIB_RAMDRIVE_PROTOS_H

/*
**      $VER: ramdrive_protos.h 40.1 (17.5.1996)
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
/*--- functions in V34 or higher (Release 1.3) ---*/
@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} @{"KillRAD0" LINK "gg:doc/NDK/Guide/Include/inline/ramdrive.h/File" 20}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
/*--- functions in V36 or higher (Release 2.0) ---*/
@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} @{"KillRAD" LINK "gg:doc/NDK/Guide/Include/inline/ramdrive.h/File" 24}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} unit );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_RAMDRIVE_PROTOS_H */
@ENDNODE
