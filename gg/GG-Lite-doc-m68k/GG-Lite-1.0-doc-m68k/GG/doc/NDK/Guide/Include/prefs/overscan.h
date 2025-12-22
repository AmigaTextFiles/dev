@DATABASE "gg:doc/NDK/Guide/Include/prefs/overscan.h"
@MASTER   "gg:os-include/prefs/overscan.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:51
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "prefs/overscan.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"prefs/overscan.h" LINK File}


@{b}Structures@{ub}

@{"OverscanPrefs" LINK "gg:doc/NDK/Guide/Include/prefs/overscan.h/File" 37}


@{b}#defines@{ub}

@{"ID_OSCN" LINK "gg:doc/NDK/Guide/Include/prefs/overscan.h/File" 32}  @{"OSCAN_MAGIC" LINK "gg:doc/NDK/Guide/Include/prefs/overscan.h/File" 34}

@ENDNODE
@NODE File "prefs/overscan.h"
#ifndef PREFS_OVERSCAN_H
#define PREFS_OVERSCAN_H
/*
**      $VER: overscan.h 38.4 (22.10.1992)
**      Includes Release 45.1
**
**      File format for overscan preferences
**
**      (C) Copyright 1991-2001 Amiga, Inc.
**      All Rights Reserved
*/

/*****************************************************************************/


#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef LIBRARIES_IFFPARSE_H
#include <@{"libraries/iffparse.h" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File"}>
#endif

#ifndef GRAPHICS_GFX_H
#include <@{"graphics/gfx.h" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File"}>
#endif


/*****************************************************************************/


#define ID_OSCN @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('O','S','C','N')

#define OSCAN_MAGIC  0xFEDCBA89


struct OverscanPrefs
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}            os_Reserved;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}            os_Magic;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}            os_HStart;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}            os_HStop;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}            os_VStart;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}            os_VStop;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}            os_DisplayID;
    @{"Point" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 39}            os_ViewPos;
    @{"Point" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 39}            os_Text;
    @{"struct Rectangle" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 27} os_Standard;
};

/* os_HStart, os_HStop, os_VStart, os_VStop can only be looked at if
 * os_Magic equals @{"OSCAN_MAGIC" LINK File 34}. If os_Magic is set to any other value,
 * these four fields are undefined
 */


/*****************************************************************************/


#endif /* PREFS_OVERSCAN_H */
@ENDNODE
