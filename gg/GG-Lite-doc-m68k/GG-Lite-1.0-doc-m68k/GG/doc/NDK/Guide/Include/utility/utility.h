@DATABASE "gg:doc/NDK/Guide/Include/utility/utility.h"
@MASTER   "gg:os-include/utility/utility.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:36
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "utility/utility.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"utility/utility.h" LINK File}


@{b}Structures@{ub}

@{"UtilityBase" LINK "gg:doc/NDK/Guide/Include/utility/utility.h/File" 31}


@{b}#defines@{ub}

@{"UTILITYNAME" LINK "gg:doc/NDK/Guide/Include/utility/utility.h/File" 28}

@ENDNODE
@NODE File "utility/utility.h"
#ifndef UTILITY_UTILITY_H
#define UTILITY_UTILITY_H
/*
**      $VER: utility.h 39.2 (18.9.1992)
**      Includes Release 45.1
**
**      @{"utility.library" LINK "gg:doc/NDK/Guide/utility/MAIN"} include file
**
**      (C) Copyright 1992-2001 Amiga, Inc.
**      All Rights Reserved
*/

/*****************************************************************************/


#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef EXEC_LIBRARIES_H
#include <@{"exec/libraries.h" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File"}>
#endif


/*****************************************************************************/


#define UTILITYNAME "utility.library"


struct UtilityBase
{
    @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} ub_LibNode;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}          ub_Language;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}          ub_Reserved;
};


/*****************************************************************************/


#endif /* UTILITY_UTILITY_H */
@ENDNODE
