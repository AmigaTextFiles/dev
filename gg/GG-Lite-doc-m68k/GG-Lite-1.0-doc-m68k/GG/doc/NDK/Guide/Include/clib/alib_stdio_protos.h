@DATABASE "gg:doc/NDK/Guide/Include/clib/alib_stdio_protos.h"
@MASTER   "gg:os-include/clib/alib_stdio_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:28
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/alib_stdio_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/alib_stdio_protos.h" LINK File}

@ENDNODE
@NODE File "clib/alib_stdio_protos.h"
#ifndef  CLIB_ALIB_STDIO_PROTOS_H
#define  CLIB_ALIB_STDIO_PROTOS_H

/*
**      $VER: alib_stdio_protos.h 40.1 (20.7.1996)
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

/* stdio functions that duplicate those in a typical C library */

@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} printf( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} fmt, ... );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} sprintf( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} buffer, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} fmt, ... );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} fclose( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} stream );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} fgetc( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} stream );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} fprintf( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} stream, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} fmt, ... );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} fputc( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} c, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} stream );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} fputs( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} s, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} stream );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} getchar( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} putchar( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} c );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} puts( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} s );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_ALIB_STDIO_PROTOS_H */
@ENDNODE
