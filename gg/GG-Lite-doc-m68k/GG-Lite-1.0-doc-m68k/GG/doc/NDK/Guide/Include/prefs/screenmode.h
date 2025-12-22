@DATABASE "gg:doc/NDK/Guide/Include/prefs/screenmode.h"
@MASTER   "gg:os-include/prefs/screenmode.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:56
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "prefs/screenmode.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"prefs/screenmode.h" LINK File}


@{b}Structures@{ub}

@{"ScreenModePrefs" LINK "gg:doc/NDK/Guide/Include/prefs/screenmode.h/File" 31}


@{b}#defines@{ub}

@{"ID_SCRM" LINK "gg:doc/NDK/Guide/Include/prefs/screenmode.h/File" 28}  @{"SMB_AUTOSCROLL" LINK "gg:doc/NDK/Guide/Include/prefs/screenmode.h/File" 42}  @{"SMF_AUTOSCROLL" LINK "gg:doc/NDK/Guide/Include/prefs/screenmode.h/File" 44}

@ENDNODE
@NODE File "prefs/screenmode.h"
#ifndef PREFS_SCREENMODE_H
#define PREFS_SCREENMODE_H
/*
**      $VER: screenmode.h 38.4 (25.6.1992)
**      Includes Release 45.1
**
**      File format for screen mode preferences
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


#define ID_SCRM @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('S','C','R','M')


struct ScreenModePrefs
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} smp_Reserved[4];
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} smp_DisplayID;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} smp_Width;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} smp_Height;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} smp_Depth;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} smp_Control;
};

/* flags for ScreenModePrefs.smp_Control */
#define SMB_AUTOSCROLL 1

#define SMF_AUTOSCROLL (1<<0)


/*****************************************************************************/


#endif /* PREFS_SCREENMODE_H */
@ENDNODE
