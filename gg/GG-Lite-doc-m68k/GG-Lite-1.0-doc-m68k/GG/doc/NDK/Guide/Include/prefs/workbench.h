@DATABASE "gg:doc/NDK/Guide/Include/prefs/workbench.h"
@MASTER   "gg:os-include/prefs/workbench.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:59
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "prefs/workbench.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"prefs/workbench.h" LINK File}


@{b}Structures@{ub}

@{"WorkbenchHiddenDevicePrefs" LINK "gg:doc/NDK/Guide/Include/prefs/workbench.h/File" 46}  @{"WorkbenchPrefs" LINK "gg:doc/NDK/Guide/Include/prefs/workbench.h/File" 25}


@{b}#defines@{ub}

@{"ID_WBHD" LINK "gg:doc/NDK/Guide/Include/prefs/workbench.h/File" 44}  @{"ID_WBNC" LINK "gg:doc/NDK/Guide/Include/prefs/workbench.h/File" 23}

@ENDNODE
@NODE File "prefs/workbench.h"
#ifndef PREFS_WORKBENCH_H
#define PREFS_WORKBENCH_H
/*
**      $VER: workbench.h 45.1 (17.11.2000)
**      Includes Release 45.1
**
**      Workbench preferences file definitions
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef LIBRARIES_IFFPARSE_H
#include <@{"libraries/iffparse.h" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File"}>
#endif

#ifndef GRAPHICS_GFX_H
#include <@{"graphics/gfx.h" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File"}>
#endif

/*****************************************************************************/

#define ID_WBNC @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('W','B','N','C')

struct WorkbenchPrefs
{
    /* settings from @{"workbench.library" LINK "gg:doc/NDK/Guide/wb/MAIN"} */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               wbp_DefaultStackSize;   /* in bytes */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               wbp_TypeRestartTime;    /* in seconds */
    /* settings from @{"icon.library" LINK "gg:doc/NDK/Guide/icon/MAIN"} */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               wbp_IconPrecision;      /* PRECISION_#? values */
    @{"struct Rectangle" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 27}    wbp_EmbossRect;
    @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}                wbp_Borderless;
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                wbp_MaxNameLength;
    @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}                wbp_NewIconsSupport;
    @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}                wbp_ColorIconSupport;
    /* new for V45 */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               wbp_ImageMemType;
    @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}                wbp_LockPens;
    @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}                wbp_NoTitleBar;
    @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}                wbp_NoGauge;
};

#define ID_WBHD @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('W','B','H','D')

struct WorkbenchHiddenDevicePrefs
{
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}               whdp_Name[0];   /* C String including @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101} char */
};

/*****************************************************************************/

#endif /* PREFS_WORKBENCH_H */
@ENDNODE
