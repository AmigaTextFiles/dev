@DATABASE "gg:doc/NDK/Guide/Include/utility/date.h"
@MASTER   "gg:os-include/utility/date.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:32
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "utility/date.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"utility/date.h" LINK File}


@{b}Structures@{ub}

@{"ClockData" LINK "gg:doc/NDK/Guide/Include/utility/date.h/File" 24}

@ENDNODE
@NODE File "utility/date.h"
#ifndef UTILITY_DATE_H
#define UTILITY_DATE_H
/*
**      $VER: date.h 39.1 (20.1.1992)
**      Includes Release 45.1
**
**      Date conversion routines ClockData definition.
**
**      (C) Copyright 1989-2001 Amiga, Inc.
**      All Rights Reserved
*/

/*****************************************************************************/


#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif


/*****************************************************************************/


struct ClockData
{
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} sec;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} min;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} hour;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} mday;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} month;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} year;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} wday;
};


/*****************************************************************************/


#endif /* UTILITY_DATE_H */
@ENDNODE
