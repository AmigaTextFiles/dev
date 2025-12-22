@DATABASE "gg:doc/NDK/Guide/Include/clib/ddebug_protos.h"
@MASTER   "gg:os-include/clib/ddebug_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:35
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/ddebug_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/ddebug_protos.h" LINK File}

@ENDNODE
@NODE File "clib/ddebug_protos.h"
#ifndef  CLIB_DDEBUG_PROTOS_H
#define  CLIB_DDEBUG_PROTOS_H

/*
**      $VER: ddebug_protos.h 40.1 (17.5.1996)
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
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} DDoFmt( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} formatString, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} dataStream, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} putChProc, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} putChData );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} DGetChar( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} dgetchar( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} dgetch( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} dgetc( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} DGetNum( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} dgetnum( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} DMayGetChar( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} DMayGetCh( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} DPutChar( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} ch );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} dputchar( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} ch );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} dputch( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} ch );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} dputc( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} ch );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} DPutCh( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} ch );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} DPutFmt( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} formatString, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} values );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} DVPrintF( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} formatString, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} values );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} DPrintF( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} formatString, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} dprintf( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} formatString, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} DPutStr( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} string );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} dputstr( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} string );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} dputs( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} string );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} DPutS( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} string );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_DDEBUG_PROTOS_H */
@ENDNODE
