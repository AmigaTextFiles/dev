@DATABASE "gg:doc/NDK/Guide/Include/inline/datebrowser.h"
@MASTER   "gg:os-include/inline/datebrowser.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:39
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/datebrowser.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/datebrowser.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_DATEBROWSER_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/datebrowser.h/File" 5}  @{"DATEBROWSER_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/datebrowser.h/File" 20}  @{"DATEBROWSER_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/datebrowser.h/File" 23}
@{"JulianLeapYear()" LINK "gg:doc/NDK/Guide/Include/inline/datebrowser.h/File" 35}           @{"JulianMonthDays()" LINK "gg:doc/NDK/Guide/Include/inline/datebrowser.h/File" 31}      @{"JulianWeekDay()" LINK "gg:doc/NDK/Guide/Include/inline/datebrowser.h/File" 27}

@ENDNODE
@NODE File "inline/datebrowser.h"
#ifndef _INLINE_DATEBROWSER_H
#define _INLINE_DATEBROWSER_H

#ifndef CLIB_DATEBROWSER_PROTOS_H
#define CLIB_DATEBROWSER_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif
#ifndef  INTUITION_CLASSES_H
#include <@{"intuition/classes.h" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File"}>
#endif

#ifndef DATEBROWSER_BASE_NAME
#define DATEBROWSER_BASE_NAME DateBrowserBase
#endif

#define @{"DATEBROWSER_GetClass()" LINK "gg:doc/NDK/Guide/datebrowser_gc/DATEBROWSER_GetClass"} \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"DATEBROWSER_GetClass" LINK File 23}, \\
        , @{"DATEBROWSER_BASE_NAME" LINK File 20})

#define @{"JulianWeekDay" LINK "gg:doc/NDK/Guide/datebrowser_gc/JulianWeekDay"}(day, month, year) \\
        @{"LP3" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 229}(0x24, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, @{"JulianWeekDay" LINK File 27}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, day, d0, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, month, d1, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, year, d2, \\
        , @{"DATEBROWSER_BASE_NAME" LINK File 20})

#define @{"JulianMonthDays" LINK "gg:doc/NDK/Guide/datebrowser_gc/JulianMonthDays"}(month, year) \\
        @{"LP2" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 148}(0x2a, @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}, @{"JulianMonthDays" LINK File 31}, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}, month, d0, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, year, d1, \\
        , @{"DATEBROWSER_BASE_NAME" LINK File 20})

#define @{"JulianLeapYear" LINK "gg:doc/NDK/Guide/datebrowser_gc/JulianLeapYear"}(year) \\
        @{"LP1" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 56}(0x30, @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}, @{"JulianLeapYear" LINK File 35}, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}, year, d0, \\
        , @{"DATEBROWSER_BASE_NAME" LINK File 20})

#endif /*  _INLINE_DATEBROWSER_H  */
@ENDNODE
