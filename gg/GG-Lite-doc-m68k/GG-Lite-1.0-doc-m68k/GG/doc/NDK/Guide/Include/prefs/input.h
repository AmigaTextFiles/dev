@DATABASE "gg:doc/NDK/Guide/Include/prefs/input.h"
@MASTER   "gg:os-include/prefs/input.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:50
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "prefs/input.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"prefs/input.h" LINK File}


@{b}Structures@{ub}

@{"InputPrefs" LINK "gg:doc/NDK/Guide/Include/prefs/input.h/File" 35}


@{b}#defines@{ub}

@{"ID_INPT" LINK "gg:doc/NDK/Guide/Include/prefs/input.h/File" 32}

@ENDNODE
@NODE File "prefs/input.h"
#ifndef PREFS_INPUT_H
#define PREFS_INPUT_H
/*
**      $VER: input.h 38.2 (28.6.1991)
**      Includes Release 45.1
**
**      File format for input preferences
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

#ifndef DEVICES_TIMER_H
#include <@{"devices/timer.h" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File"}>
#endif


/*****************************************************************************/


#define ID_INPT @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('I','N','P','T')


struct InputPrefs
{
    char           ip_Keymap[16];
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}          ip_PointerTicks;
    @{"struct timeval" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 30} ip_DoubleClick;
    @{"struct timeval" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 30} ip_KeyRptDelay;
    @{"struct timeval" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 30} ip_KeyRptSpeed;
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}           ip_MouseAccel;
};


/*****************************************************************************/


#endif /* PREFS_INPUT_H */
@ENDNODE
