@DATABASE "gg:doc/NDK/Guide/Include/prefs/icontrol.h"
@MASTER   "gg:os-include/prefs/icontrol.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:50
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "prefs/icontrol.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"prefs/icontrol.h" LINK File}


@{b}Structures@{ub}

@{"IControlPrefs" LINK "gg:doc/NDK/Guide/Include/prefs/icontrol.h/File" 31}


@{b}#defines@{ub}

@{"ICB_COERCE_COLORS" LINK "gg:doc/NDK/Guide/Include/prefs/icontrol.h/File" 44}  @{"ICB_COERCE_LACE" LINK "gg:doc/NDK/Guide/Include/prefs/icontrol.h/File" 45}   @{"ICB_MENUSNAP" LINK "gg:doc/NDK/Guide/Include/prefs/icontrol.h/File" 47}
@{"ICB_MODEPROMOTE" LINK "gg:doc/NDK/Guide/Include/prefs/icontrol.h/File" 48}    @{"ICB_SQUARE_RATIO" LINK "gg:doc/NDK/Guide/Include/prefs/icontrol.h/File" 49}  @{"ICB_STRGAD_FILTER" LINK "gg:doc/NDK/Guide/Include/prefs/icontrol.h/File" 46}
@{"ICF_COERCE_COLORS" LINK "gg:doc/NDK/Guide/Include/prefs/icontrol.h/File" 51}  @{"ICF_COERCE_LACE" LINK "gg:doc/NDK/Guide/Include/prefs/icontrol.h/File" 52}   @{"ICF_MENUSNAP" LINK "gg:doc/NDK/Guide/Include/prefs/icontrol.h/File" 54}
@{"ICF_MODEPROMOTE" LINK "gg:doc/NDK/Guide/Include/prefs/icontrol.h/File" 55}    @{"ICF_SQUARE_RATIO" LINK "gg:doc/NDK/Guide/Include/prefs/icontrol.h/File" 56}  @{"ICF_STRGAD_FILTER" LINK "gg:doc/NDK/Guide/Include/prefs/icontrol.h/File" 53}
@{"ID_ICTL" LINK "gg:doc/NDK/Guide/Include/prefs/icontrol.h/File" 28}            

@ENDNODE
@NODE File "prefs/icontrol.h"
#ifndef PREFS_ICONTROL_H
#define PREFS_ICONTROL_H
/*
**      $VER: icontrol.h 45.1 (20.11.2000)
**      Includes Release 45.1
**
**      File format for intuition control preferences
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


#define ID_ICTL @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('I','C','T','L')


struct IControlPrefs
{
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  ic_Reserved[4];       /* System reserved              */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} ic_TimeOut;           /* Verify timeout               */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}  ic_MetaDrag;          /* Meta drag mouse event        */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} ic_Flags;                     /* IControl flags (see below)   */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} ic_WBtoFront;         /* CKey: WB to front            */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} ic_FrontToBack;       /* CKey: front screen to back   */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} ic_ReqTrue;           /* CKey: Requester @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}         */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} ic_ReqFalse;          /* CKey: Requester @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}        */
};

/* flags for IControlPrefs.ic_Flags */
#define ICB_COERCE_COLORS 0
#define ICB_COERCE_LACE   1
#define ICB_STRGAD_FILTER 2
#define ICB_MENUSNAP      3
#define ICB_MODEPROMOTE   4
#define ICB_SQUARE_RATIO  5

#define ICF_COERCE_COLORS (1<<0)
#define ICF_COERCE_LACE   (1<<1)
#define ICF_STRGAD_FILTER (1<<2)
#define ICF_MENUSNAP      (1<<3)
#define ICF_MODEPROMOTE   (1<<4)
#define ICF_SQUARE_RATIO  (1<<5)


/*****************************************************************************/


#endif /* PREFS_ICONTROL_H */
@ENDNODE
