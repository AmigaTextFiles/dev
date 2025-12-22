@DATABASE "gg:doc/NDK/Guide/Include/clib/mathtrans_protos.h"
@MASTER   "gg:os-include/clib/mathtrans_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:55
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/mathtrans_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/mathtrans_protos.h" LINK File}

@ENDNODE
@NODE File "clib/mathtrans_protos.h"
#ifndef  CLIB_MATHTRANS_PROTOS_H
#define  CLIB_MATHTRANS_PROTOS_H

/*
**      $VER: mathtrans_protos.h 40.1 (17.5.1996)
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
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPAtan( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPSin( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPCos( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPTan( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPSincos( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} *cosResult, @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPSinh( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPCosh( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPTanh( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPExp( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPLog( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPPow( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} power, @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} arg );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPSqrt( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPTieee( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPFieee( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
/*--- functions in V31 or higher (Release 1.1) ---*/
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPAsin( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPAcos( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );
@{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} SPLog10( @{"FLOAT" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 89} parm );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_MATHTRANS_PROTOS_H */
@ENDNODE
