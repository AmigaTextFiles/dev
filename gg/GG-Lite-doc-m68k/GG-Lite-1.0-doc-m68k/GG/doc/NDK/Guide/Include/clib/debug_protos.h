@DATABASE "gg:doc/NDK/Guide/Include/clib/debug_protos.h"
@MASTER   "gg:os-include/clib/debug_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:36
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/debug_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/debug_protos.h" LINK File}

@ENDNODE
@NODE File "clib/debug_protos.h"
#ifndef  CLIB_DEBUG_PROTOS_H
#define  CLIB_DEBUG_PROTOS_H

/*
**      $VER: debug_protos.h 40.1 (17.5.1996)
**      Includes Release 45.1
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
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} KCmpStr( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} a, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} b );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} cmpstrexec( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} a, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} b );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} KGetChar( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} kgetc( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} kgetchar( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} kgetch( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} KGetCh( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} KGetNum( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} kgetnum( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} KMayGetChar( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} KMayGetCh( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} KPutFmt( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} formatString, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} values );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} KVPrintF( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} formatString, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} values );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} KPrintF( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} formatString, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} kprintf( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} formatString, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} KPutChar( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} ch );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} kputc( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} ch );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} kputchar( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} ch );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} kputch( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} ch );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} KPutCh( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} ch );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} KPutStr( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} string );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} kputs( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} string );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} KPutS( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} string );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} KDoFmt( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} formatString, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} dataStream, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} putChProc, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} putChData );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_DEBUG_PROTOS_H */
@ENDNODE
