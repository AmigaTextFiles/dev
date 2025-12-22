@DATABASE "gg:doc/NDK/Guide/Include/clib/mathieeedoubtrans_protos.h"
@MASTER   "gg:os-include/clib/mathieeedoubtrans_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:54
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/mathieeedoubtrans_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/mathieeedoubtrans_protos.h" LINK File}

@ENDNODE
@NODE File "clib/mathieeedoubtrans_protos.h"
#ifndef  CLIB_MATHIEEEDOUBTRANS_PROTOS_H
#define  CLIB_MATHIEEEDOUBTRANS_PROTOS_H

/*
**      $VER: mathieeedoubtrans_protos.h 40.1 (17.5.1996)
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
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPAtan( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm );
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPSin( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm );
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPCos( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm );
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPTan( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm );
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPSincos( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} *pf2, @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm );
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPSinh( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm );
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPCosh( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm );
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPTanh( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm );
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPExp( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm );
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPLog( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm );
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPPow( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} @{"exp" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 43}, @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} arg );
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPSqrt( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} IEEEDPTieee( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm );
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPFieee( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} single );
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPAsin( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm );
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPAcos( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm );
@{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} IEEEDPLog10( @{"DOUBLE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 90} parm );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_MATHIEEEDOUBTRANS_PROTOS_H */
@ENDNODE
