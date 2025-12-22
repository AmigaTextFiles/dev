@DATABASE "gg:doc/NDK/Guide/Include/prefs/pointer.h"
@MASTER   "gg:os-include/prefs/pointer.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:52
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "prefs/pointer.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"prefs/pointer.h" LINK File}


@{b}Structures@{ub}

@{"PointerPrefs" LINK "gg:doc/NDK/Guide/Include/prefs/pointer.h/File" 29}  @{"RGBTable" LINK "gg:doc/NDK/Guide/Include/prefs/pointer.h/File" 53}


@{b}#defines@{ub}

@{"ID_PNTR" LINK "gg:doc/NDK/Guide/Include/prefs/pointer.h/File" 25}  @{"WBP_BUSY" LINK "gg:doc/NDK/Guide/Include/prefs/pointer.h/File" 49}  @{"WBP_NORMAL" LINK "gg:doc/NDK/Guide/Include/prefs/pointer.h/File" 48}

@ENDNODE
@NODE File "prefs/pointer.h"
#ifndef PREFS_POINTER_H
#define PREFS_POINTER_H
/*
**      $VER: pointer.h 39.2 (9.6.1992)
**      Includes Release 45.1
**
**      File format for pointer preferences
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

/*****************************************************************************/

#define ID_PNTR @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('P','N','T','R')

/*****************************************************************************/

struct PointerPrefs
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} pp_Reserved[4];
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} pp_Which;                             /* 0=NORMAL, 1=BUSY */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} pp_Size;                              /* see <@{"intuition/pointerclass.h" LINK "gg:doc/NDK/Guide/Include/intuition/pointerclass.h/File"}> */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} pp_Width;                             /* Width in pixels */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} pp_Height;                            /* Height in pixels */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} pp_Depth;                             /* Depth */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} pp_YSize;                             /* YSize */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} pp_X, pp_Y;                           /* Hotspot */

    /* Color Table:  numEntries = (1 << pp_Depth) - 1 */

    /* Data follows */
};

/*****************************************************************************/

/* constants for PointerPrefs.pp_Which */
#define WBP_NORMAL      0
#define WBP_BUSY        1

/*****************************************************************************/

struct RGBTable
{
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} t_Red;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} t_Green;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} t_Blue;
};

/*****************************************************************************/

#endif /* PREFS_POINTER_H */
@ENDNODE
