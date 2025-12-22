@DATABASE "gg:doc/NDK/Guide/Include/clib/nonvolatile_protos.h"
@MASTER   "gg:os-include/clib/nonvolatile_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:56
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/nonvolatile_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/nonvolatile_protos.h" LINK File}

@ENDNODE
@NODE File "clib/nonvolatile_protos.h"
#ifndef  CLIB_NONVOLATILE_PROTOS_H
#define  CLIB_NONVOLATILE_PROTOS_H

/*
**      $VER: nonvolatile_protos.h 40.1 (17.5.1996)
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
#ifndef  EXEC_LISTS_H
#include <@{"exec/lists.h" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File"}>
#endif
#ifndef  LIBRARIES_NONVOLATILE_H
#include <@{"libraries/nonvolatile.h" LINK "gg:doc/NDK/Guide/Include/libraries/nonvolatile.h/File"}>
#endif
/*--- functions in V40 or higher (Release 3.1) ---*/
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"GetCopyNV" LINK "gg:doc/NDK/Guide/Include/inline/nonvolatile.h/File" 26}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} appName, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} itemName, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} killRequesters );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeNVData" LINK "gg:doc/NDK/Guide/Include/inline/nonvolatile.h/File" 30}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} data );
@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} @{"StoreNV" LINK "gg:doc/NDK/Guide/Include/inline/nonvolatile.h/File" 34}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} appName, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} itemName, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} data, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} length, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} killRequesters );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"DeleteNV" LINK "gg:doc/NDK/Guide/Include/inline/nonvolatile.h/File" 38}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} appName, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} itemName, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} killRequesters );
@{"struct NVInfo" LINK "gg:doc/NDK/Guide/Include/libraries/nonvolatile.h/File" 29} *GetNVInfo( LONG killRequesters );
@{"struct MinList" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 31} *GetNVList( CONST_STRPTR appName, LONG killRequesters );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"SetNVProtection" LINK "gg:doc/NDK/Guide/Include/inline/nonvolatile.h/File" 50}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} appName, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} itemName, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} mask, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} killRequesters );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_NONVOLATILE_PROTOS_H */
@ENDNODE
