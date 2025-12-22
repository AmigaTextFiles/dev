@DATABASE "gg:doc/NDK/Guide/Include/prefs/font.h"
@MASTER   "gg:os-include/prefs/font.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:49
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "prefs/font.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"prefs/font.h" LINK File}


@{b}Structures@{ub}

@{"FontPrefs" LINK "gg:doc/NDK/Guide/Include/prefs/font.h/File" 37}


@{b}#defines@{ub}

@{"FONTNAMESIZE" LINK "gg:doc/NDK/Guide/Include/prefs/font.h/File" 35}  @{"FP_SCREENFONT" LINK "gg:doc/NDK/Guide/Include/prefs/font.h/File" 53}  @{"FP_SYSFONT" LINK "gg:doc/NDK/Guide/Include/prefs/font.h/File" 52}  @{"FP_WBFONT" LINK "gg:doc/NDK/Guide/Include/prefs/font.h/File" 51}  @{"ID_FONT" LINK "gg:doc/NDK/Guide/Include/prefs/font.h/File" 32}

@ENDNODE
@NODE File "prefs/font.h"
#ifndef PREFS_FONT_H
#define PREFS_FONT_H
/*
**      $VER: font.h 38.2 (27.9.1991)
**      Includes Release 45.1
**
**      File format for font preferences
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

#ifndef GRAPHICS_TEXT_H
#include <@{"graphics/text.h" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File"}>
#endif


/*****************************************************************************/


#define ID_FONT @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('F','O','N','T')


#define @{"FONTNAMESIZE" LINK "gg:doc/NDK/Guide/Include/prefs/reaction.h/File" 26} (128)

struct FontPrefs
{
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}            fp_Reserved[3];
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}           fp_Reserved2;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}           fp_Type;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}           fp_FrontPen;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}           fp_BackPen;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}           fp_DrawMode;
    @{"struct TextAttr" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 65} fp_TextAttr;
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}            fp_Name[@{"FONTNAMESIZE" LINK File 35}];
};


/* constants for FontPrefs.fp_Type */
#define FP_WBFONT     0
#define FP_SYSFONT    1
#define FP_SCREENFONT 2


/*****************************************************************************/


#endif /* PREFS_FONT_H */
@ENDNODE
