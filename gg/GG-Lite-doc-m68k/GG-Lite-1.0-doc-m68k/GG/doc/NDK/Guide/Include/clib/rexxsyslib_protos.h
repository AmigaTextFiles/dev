@DATABASE "gg:doc/NDK/Guide/Include/clib/rexxsyslib_protos.h"
@MASTER   "gg:os-include/clib/rexxsyslib_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:00
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/rexxsyslib_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/rexxsyslib_protos.h" LINK File}

@ENDNODE
@NODE File "clib/rexxsyslib_protos.h"
#ifndef  CLIB_REXXSYSLIB_PROTOS_H
#define  CLIB_REXXSYSLIB_PROTOS_H

/*
**      $VER: rexxsyslib_protos.h 40.1 (17.5.1996)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/*--- functions in V33 or higher (Release 1.2) ---*/
#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  REXX_RXSLIB_H
#include <@{"rexx/rxslib.h" LINK "gg:doc/NDK/Guide/Include/rexx/rxslib.h/File"}>
#endif
#ifndef  REXX_REXXIO_H
#include <@{"rexx/rexxio.h" LINK "gg:doc/NDK/Guide/Include/rexx/rexxio.h/File"}>
#endif

@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *@{"CreateArgstring" LINK "gg:doc/NDK/Guide/Include/inline/rexxsyslib.h/File" 26}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} string, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} length );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DeleteArgstring" LINK "gg:doc/NDK/Guide/Include/inline/rexxsyslib.h/File" 30}( @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *argstring );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"LengthArgstring" LINK "gg:doc/NDK/Guide/Include/inline/rexxsyslib.h/File" 34}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *argstring );
@{"struct RexxMsg" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 98} *CreateRexxMsg( CONST struct MsgPort *port, CONST_STRPTR extension, CONST_STRPTR host );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DeleteRexxMsg" LINK "gg:doc/NDK/Guide/Include/inline/rexxsyslib.h/File" 42}( @{"struct RexxMsg" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 98} *packet );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ClearRexxMsg" LINK "gg:doc/NDK/Guide/Include/inline/rexxsyslib.h/File" 46}( @{"struct RexxMsg" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 98} *msgptr, ULONG count );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"FillRexxMsg" LINK "gg:doc/NDK/Guide/Include/inline/rexxsyslib.h/File" 50}( @{"struct RexxMsg" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 98} *msgptr, ULONG count, ULONG mask );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"IsRexxMsg" LINK "gg:doc/NDK/Guide/Include/inline/rexxsyslib.h/File" 54}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct RexxMsg" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 98} *msgptr );


@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"LockRexxBase" LINK "gg:doc/NDK/Guide/Include/inline/rexxsyslib.h/File" 58}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} resource );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"UnlockRexxBase" LINK "gg:doc/NDK/Guide/Include/inline/rexxsyslib.h/File" 62}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} resource );


#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_REXXSYSLIB_PROTOS_H */
@ENDNODE
