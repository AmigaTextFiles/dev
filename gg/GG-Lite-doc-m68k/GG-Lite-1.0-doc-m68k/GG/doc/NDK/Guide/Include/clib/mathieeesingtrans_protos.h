@DATABASE "gg:doc/NDK/Guide/Include/clib/mathieeesingtrans_protos.h"
@MASTER   "gg:os-include/clib/mathieeesingtrans_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:55
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/mathieeesingtrans_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/mathieeesingtrans_protos.h" LINK File}

@ENDNODE
@NODE File "clib/mathieeesingtrans_protos.h"
#ifndef  CLIB_MATHIEEESINGTRANS_PROTOS_H
#define  CLIB_MATHIEEESINGTRANS_PROTOS_H

/*
**      $VER: mathieeesingtrans_protos.h 40.1 (17.5.1996)
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
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPAtan( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPSin( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPCos( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPTan( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPSincos( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} *cosptr, @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPSinh( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPCosh( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPTanh( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPExp( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPLog( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPPow( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} @{"exp" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 43}, @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} arg );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPSqrt( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPTieee( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPFieee( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPAsin( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPAcos( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEESPLog10( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_MATHIEEESINGTRANS_PROTOS_H */
@ENDNODE
