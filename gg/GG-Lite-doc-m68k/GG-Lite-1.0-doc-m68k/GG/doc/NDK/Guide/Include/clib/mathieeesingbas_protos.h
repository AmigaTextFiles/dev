@DATABASE "gg:doc/NDK/Guide/Include/clib/mathieeesingbas_protos.h"
@MASTER   "gg:os-include/clib/mathieeesingbas_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:55
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/mathieeesingbas_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/mathieeesingbas_protos.h" LINK File}

@ENDNODE
@NODE File "clib/mathieeesingbas_protos.h"
#ifndef  CLIB_MATHIEEESINGBAS_PROTOS_H
#define  CLIB_MATHIEEESINGBAS_PROTOS_H

/*
**      $VER: mathieeesingbas_protos.h 40.1 (17.5.1996)
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
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} IEEESPFix( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPFlt( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} integer );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} IEEESPCmp( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} leftParm, @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} rightParm );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} IEEESPTst( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPAbs( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPNeg( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPAdd( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} leftParm, @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} rightParm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPSub( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} leftParm, @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} rightParm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPMul( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} leftParm, @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} rightParm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPDiv( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} dividend, @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} divisor );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPFloor( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPCeil( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_MATHIEEESINGBAS_PROTOS_H */
@ENDNODE
