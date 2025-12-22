@DATABASE "gg:doc/NDK/Guide/Include/prefs/palette.h"
@MASTER   "gg:os-include/prefs/palette.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:52
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "prefs/palette.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"prefs/palette.h" LINK File}


@{b}Structures@{ub}

@{"PalettePrefs" LINK "gg:doc/NDK/Guide/Include/prefs/palette.h/File" 35}


@{b}#defines@{ub}

@{"ID_PALT" LINK "gg:doc/NDK/Guide/Include/prefs/palette.h/File" 32}

@ENDNODE
@NODE File "prefs/palette.h"
#ifndef PREFS_PALETTE_H
#define PREFS_PALETTE_H
/*
**      $VER: palette.h 39.2 (15.6.1992)
**      Includes Release 45.1
**
**      File format for palette preferences
**
**      (C) Copyright 1992-2001 Amiga, Inc.
**      All Rights Reserved
*/

/*****************************************************************************/


#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef LIBRARIES_IFFPARSE_H
#include <@{"libraries/iffparse.h" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File"}>
#endif

#ifndef INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif


/*****************************************************************************/


#define ID_PALT @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('P','A','L','T')


struct PalettePrefs
{
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}             pap_Reserved[4];    /* System reserved                */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}            pap_4ColorPens[32];
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}            pap_8ColorPens[32];
    @{"struct ColorSpec" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1446} pap_Colors[32];     /* Used as full 16-bit RGB values */
};


/*****************************************************************************/


#endif /* PREFS_PALETTE_H */
@ENDNODE
