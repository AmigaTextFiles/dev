@DATABASE "gg:doc/NDK/Guide/Include/clib/disk_protos.h"
@MASTER   "gg:os-include/clib/disk_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:36
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/disk_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/disk_protos.h" LINK File}

@ENDNODE
@NODE File "clib/disk_protos.h"
#ifndef  CLIB_DISK_PROTOS_H
#define  CLIB_DISK_PROTOS_H

/*
**      $VER: disk_protos.h 40.1 (17.5.1996)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef  RESOURCES_DISK_H
#include <@{"resources/disk.h" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File"}>
#endif
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"AllocUnit" LINK "gg:doc/NDK/Guide/Include/inline/disk.h/File" 20}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} unitNum );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeUnit" LINK "gg:doc/NDK/Guide/Include/inline/disk.h/File" 24}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} unitNum );
@{"struct DiscResourceUnit" LINK "gg:doc/NDK/Guide/Include/resources/disk.h/File" 41} *GetUnit( struct DiscResourceUnit *unitPointer );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"GiveUnit" LINK "gg:doc/NDK/Guide/Include/inline/disk.h/File" 32}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"GetUnitID" LINK "gg:doc/NDK/Guide/Include/inline/disk.h/File" 36}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} unitNum );
/*------ new for V37 ------*/
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"ReadUnitID" LINK "gg:doc/NDK/Guide/Include/inline/disk.h/File" 40}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} unitNum );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_DISK_PROTOS_H */
@ENDNODE
