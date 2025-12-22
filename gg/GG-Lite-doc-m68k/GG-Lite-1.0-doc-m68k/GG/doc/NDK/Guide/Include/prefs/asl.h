@DATABASE "gg:doc/NDK/Guide/Include/prefs/asl.h"
@MASTER   "gg:os-include/prefs/asl.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:49
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "prefs/asl.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"prefs/asl.h" LINK File}


@{b}Structures@{ub}

@{"AslPrefs" LINK "gg:doc/NDK/Guide/Include/prefs/asl.h/File" 31}


@{b}#defines@{ub}

@{"ID_ASL" LINK "gg:doc/NDK/Guide/Include/prefs/asl.h/File" 28}

@ENDNODE
@NODE File "prefs/asl.h"
#ifndef PREFS_ASL_H
#define PREFS_ASL_H
/*
**      $VER: asl.h 45.1 (27.10.2000)
**      Includes Release 45.1
**
**      File format for ASL ("application support library") preferences
**
**      (C) Copyright 1991-2001 Amiga, Inc.
**      All Rights Reserved
*/

/*****************************************************************************/


#ifndef LIBRARIES_IFFPARSE_H
#include <@{"libraries/iffparse.h" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File"}>
#endif

#ifndef LIBRARIES_ASL_H
#include <@{"libraries/asl.h" LINK "gg:doc/NDK/Guide/Include/libraries/asl.h/File"}>
#endif


/*****************************************************************************/


#define ID_ASL @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('A','S','L',' ')


struct AslPrefs
{
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    ap_Reserved[4];

        /* These members correspond directly to the associated
         * members of the 'AslSemaphore' data structure defined
         * in the <@{"libraries/asl.h" LINK "gg:doc/NDK/Guide/Include/libraries/asl.h/File"}> header file by the same names.
         */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ap_SortBy;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ap_SortDrawers;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ap_SortOrder;

        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ap_SizePosition;

        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    ap_RelativeLeft;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    ap_RelativeTop;

        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ap_RelativeWidth;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   ap_RelativeHeight;
};


/*****************************************************************************/


#endif /* PREFS_ASL_H */
@ENDNODE
