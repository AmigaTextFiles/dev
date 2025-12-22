@DATABASE "gg:doc/NDK/Guide/Include/prefs/prefhdr.h"
@MASTER   "gg:os-include/prefs/prefhdr.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:52
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "prefs/prefhdr.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"prefs/prefhdr.h" LINK File}


@{b}Structures@{ub}

@{"PrefHeader" LINK "gg:doc/NDK/Guide/Include/prefs/prefhdr.h/File" 32}


@{b}#defines@{ub}

@{"ID_PREF" LINK "gg:doc/NDK/Guide/Include/prefs/prefhdr.h/File" 28}  @{"ID_PRHD" LINK "gg:doc/NDK/Guide/Include/prefs/prefhdr.h/File" 29}

@ENDNODE
@NODE File "prefs/prefhdr.h"
#ifndef PREFS_PREFHDR_H
#define PREFS_PREFHDR_H
/*
**      $VER: prefhdr.h 38.1 (19.6.1991)
**      Includes Release 45.1
**
**      File format for preferences header
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


#define ID_PREF  @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('P','R','E','F')
#define ID_PRHD  @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('P','R','H','D')


struct PrefHeader
{
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} ph_Version;   /* version of following data */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} ph_Type;      /* type of following data    */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} ph_Flags;     /* always set to 0 for now   */
};


/*****************************************************************************/


#endif /* PREFS_PREFHDR_H */
@ENDNODE
