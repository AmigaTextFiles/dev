@DATABASE "gg:doc/NDK/Guide/Include/clib/mathieeedoubbas_protos.h"
@MASTER   "gg:os-include/clib/mathieeedoubbas_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:54
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/mathieeedoubbas_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/mathieeedoubbas_protos.h" LINK File}

@ENDNODE
@NODE File "clib/mathieeedoubbas_protos.h"
#ifndef  CLIB_MATHIEEEDOUBBAS_PROTOS_H
#define  CLIB_MATHIEEEDOUBBAS_PROTOS_H

/*
**      $VER: mathieeedoubbas_protos.h 40.1 (17.5.1996)
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
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} IEEEDPFix( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm );
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPFlt( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} integer );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} IEEEDPCmp( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} leftParm, @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} rightParm );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} IEEEDPTst( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm );
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPAbs( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm );
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPNeg( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm );
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPAdd( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} leftParm, @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} rightParm );
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPSub( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} leftParm, @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} rightParm );
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPMul( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} factor1, @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} factor2 );
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPDiv( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} dividend, @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} divisor );
/*--- functions in V33 or higher (Release 1.2) ---*/
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPFloor( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm );
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPCeil( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_MATHIEEEDOUBBAS_PROTOS_H */
@ENDNODE
