@DATABASE "gg:doc/NDK/Guide/Include/clib/datebrowser_protos.h"
@MASTER   "gg:os-include/clib/datebrowser_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:35
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/datebrowser_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/datebrowser_protos.h" LINK File}

@ENDNODE
@NODE File "clib/datebrowser_protos.h"
#ifndef  CLIB_DATEBROWSER_PROTOS_H
#define  CLIB_DATEBROWSER_PROTOS_H

/*
**      $VER: datebrowser_protos.h 1.1 (6.10.1999)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef  INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif
#ifndef  INTUITION_CLASSES_H
#include <@{"intuition/classes.h" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File"}>
#endif
@{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *@{"DATEBROWSER_GetClass" LINK "gg:doc/NDK/Guide/Include/inline/datebrowser.h/File" 23}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} @{"JulianWeekDay" LINK "gg:doc/NDK/Guide/Include/inline/datebrowser.h/File" 27}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} day, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} month, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} year );
@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} @{"JulianMonthDays" LINK "gg:doc/NDK/Guide/Include/inline/datebrowser.h/File" 31}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} month, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} year );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"JulianLeapYear" LINK "gg:doc/NDK/Guide/Include/inline/datebrowser.h/File" 35}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} year );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_DATEBROWSER_PROTOS_H */
@ENDNODE
