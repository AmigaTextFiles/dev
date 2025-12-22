@DATABASE "gg:doc/NDK/Guide/Include/clib/cia_protos.h"
@MASTER   "gg:os-include/clib/cia_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:32
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/cia_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/cia_protos.h" LINK File}

@ENDNODE
@NODE File "clib/cia_protos.h"
#ifndef  CLIB_CIA_PROTOS_H
#define  CLIB_CIA_PROTOS_H

/*
**      $VER: cia_protos.h 40.1 (17.5.1996)
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
#ifndef  EXEC_INTERRUPTS_H
#include <@{"exec/interrupts.h" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File"}>
#endif
#ifndef  EXEC_LIBRARIES_H
#include <@{"exec/libraries.h" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File"}>
#endif
@{"struct Interrupt" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 22} *AddICRVector( struct Library *resource, LONG iCRBit, struct Interrupt *interrupt );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RemICRVector" LINK "gg:doc/NDK/Guide/Include/inline/cia.h/File" 25}( @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *resource, LONG iCRBit, struct Interrupt *interrupt );
@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} @{"AbleICR" LINK "gg:doc/NDK/Guide/Include/inline/cia.h/File" 28}( @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *resource, LONG mask );
@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} @{"SetICR" LINK "gg:doc/NDK/Guide/Include/inline/cia.h/File" 31}( @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} *resource, LONG mask );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_CIA_PROTOS_H */
@ENDNODE
