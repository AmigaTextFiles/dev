@DATABASE "gg:doc/NDK/Guide/Include/clib/mathffp_protos.h"
@MASTER   "gg:os-include/clib/mathffp_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:54
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/mathffp_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/mathffp_protos.h" LINK File}

@ENDNODE
@NODE File "clib/mathffp_protos.h"
#ifndef  CLIB_MATHFFP_PROTOS_H
#define  CLIB_MATHFFP_PROTOS_H

/*
**      $VER: mathffp_protos.h 40.1 (17.5.1996)
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
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} SPFix( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPFlt( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} integer );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} SPCmp( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} leftParm, @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} rightParm );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} SPTst( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPAbs( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPNeg( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPAdd( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} leftParm, @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} rightParm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPSub( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} leftParm, @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} rightParm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPMul( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} leftParm, @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} rightParm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPDiv( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} leftParm, @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} rightParm );
/*--- functions in V33 or higher (Release 1.2) ---*/
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPFloor( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPCeil( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_MATHFFP_PROTOS_H */
@ENDNODE
